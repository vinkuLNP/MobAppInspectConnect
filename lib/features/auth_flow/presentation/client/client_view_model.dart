import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/basecomponents/base_view_model.dart';
import 'package:clean_architecture/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:clean_architecture/core/di/app_component/app_component.dart';
import 'package:clean_architecture/core/utils/auto_router_setup/auto_router.dart';
import 'package:clean_architecture/core/utils/helpers/device_helper/device_helper.dart';
import 'package:clean_architecture/features/auth_flow/domain/entities/auth_user.dart';
import 'package:clean_architecture/features/auth_flow/domain/usecases/sign_in_usecase.dart';
import 'package:clean_architecture/features/auth_flow/domain/usecases/sign_up_usecases.dart';
import 'package:clean_architecture/features/auth_flow/utils/otp_enum.dart';
import 'package:flutter/material.dart';

class ClientViewModelProvider extends BaseViewModel {
  void init() {}

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool get obscure => _obscure;
  bool _autoValidate = false;
  bool get autoValidate => _autoValidate;

  void enableAutoValidate() {
    if (!_autoValidate) {
      _autoValidate = true;
      notifyListeners();
    }
  }

  bool _isSigningIn = false;
  bool get isSigningIn => _isSigningIn;

  void setSigningIn(bool value) {
    _isSigningIn = value;
    notifyListeners();
  }

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrlSignUp = TextEditingController();
  final addressCtrl = TextEditingController();
  final passwordCtrlSignUp = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool _obscureConfirm = true;
  bool get obscureConfirm => _obscureConfirm;
  void toggleObscureConfirm() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  bool agreeTnC = false;
  bool isTruthful = false;
  void setAgreeTnC(bool? v) {
    agreeTnC = v ?? false;
    notifyListeners();
  }

  void setIsTruthful(bool? v) {
    isTruthful = v ?? false;
    notifyListeners();
  }

  String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email';
  }

  String? validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone is required';
    return v.trim().length < 10 ? 'Enter a valid phone' : null;
  }

  String? validatePassword(String? v) {
    RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$',
    );
    if (v == null || v.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(v)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  String? validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'Confirm your password';
    if (v != passwordCtrlSignUp.text) return 'Passwords do not match';
    return null;
  }

  Future<void> submitSignUp({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    // if (!agreeTnC || !isTruthful) {
    //   return;
    // }
    startOtpFlow(OtpPurpose.signUp);
    // fullNameCtrl.clear();
    // phoneCtrl.clear();
    // emailCtrlSignUp.clear();
    print(emailCtrlSignUp);
    context.pushRoute(const ResetPasswordRoute());
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrlSignUp.dispose();
    addressCtrl.dispose();
    passwordCtrlSignUp.dispose();
    confirmPasswordCtrl.dispose();
    _timer?.cancel();
    pinController.dispose();
    focusNode.dispose();
    resetEmailCtrl.dispose();
    resetPhoneCtrl.dispose();
    _otpPurpose = null;
    super.dispose();
  }

  final pinController = TextEditingController();
  final focusNode = FocusNode();

  static const int codeLength = 6;
  static const int resendCooldownSec = 30;

  int _secondsLeft = resendCooldownSec;
  int get secondsLeft => _secondsLeft;

  bool get canVerify => pinController.text.trim().length == codeLength;
  bool get canResend => _secondsLeft == 0;

  Timer? _timer;

  bool _lastCanVerify = false;

  void verifyInit() {
    _startCooldown();
    pinController.addListener(() {
      final now = canVerify;
      if (now != _lastCanVerify) {
        _lastCanVerify = now;
        notifyListeners();
      }
    });
  }

  Future<void> verify({required BuildContext context}) async {
    if (!canVerify) return;
    final code = pinController.text.trim();
    // switch (_otpPurpose) {
    //   case OtpPurpose.signUp:
    //     context.router.replaceAll([const ClientSignInRoute()]);
    //     break;
    //   case OtpPurpose.forgotPassword:
    pinController.clear();
    context.router.replaceAll([const ResetPasswordRoute()]);
    //     break;
    //   default:
    //     context.router.replaceAll([const ClientSignInRoute()]);
    //     break;
    // }
  }

  Future<void> resend() async {
    if (!canResend) return;
    pinController.clear();
    _startCooldown();
  }

  void _startCooldown() {
    _secondsLeft = resendCooldownSec;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        t.cancel();
      } else {
        _secondsLeft--;
      }
      notifyListeners();
    });
    notifyListeners();
  }

  String? phoneIso;
  String? phoneDial;
  String? phoneRaw;
  String? phoneE164;

  void setPhoneParts({
    required String iso,
    required String dial,
    required String number,
    required String e164,
  }) {
    phoneIso = iso;
    phoneDial = dial;
    phoneRaw = number;
    phoneE164 = e164;
  }

  String? validateIntlPhone() {
    if ((phoneE164 ?? '').isEmpty) return 'Phone is required';
    if ((phoneRaw ?? '').length < 6) return 'Enter a valid phone';
    return null;
  }

  final resetEmailCtrl = TextEditingController();
  final resetPhoneCtrl = TextEditingController();

  bool _isSendingReset = false;
  bool get isSendingReset => _isSendingReset;

  bool _isResetting = false;
  bool get isResetting => _isResetting;

  String? _resetTargetLabel;
  String? get resetTargetLabel => _resetTargetLabel;

  String? validateEmailOrIntlPhone() {
    final email = resetEmailCtrl.text.trim();
    final eOk =
        email.isNotEmpty &&
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    // final pOk =
    //     (phoneE164 != null &&
    //     phoneE164!.isNotEmpty &&
    //     (phoneRaw?.length ?? 0) >= 6);
    if (!eOk) return 'Enter a valid email ';
    return null;
  }

  Future<void> requestPasswordReset({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setSigningIn(true);

    _isSendingReset = true;
    notifyListeners();

    try {
      final email = resetEmailCtrl.text.trim();
      // final useEmail = email.isNotEmpty;

      _resetTargetLabel = email;
      // useEmail ? email : phoneE164;

      // verifyInit();
      startOtpFlow(OtpPurpose.forgotPassword);
      resetEmailCtrl.clear();
      context.pushRoute(const OtpVerificationRoute());
    } finally {
      _isSendingReset = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    // _isResetting = true;
    // notifyListeners();

    // try {
    //   context.router.replaceAll([const ClientSignInRoute()]);
    //   passwordCtrlSignUp.clear();
    //   confirmPasswordCtrl.clear();
    // } finally {
    // _isResetting = false;
    // notifyListeners();
    // }

    _isResetting = true;
    notifyListeners();
    setSigningIn(true);
    try {
      deviceToken = await DeviceInfoHelper.getDeviceToken();
      deviceType = await DeviceInfoHelper.getDeviceType();
      final useCase = locator<SignUpUseCase>();

      final params = SignUpParams(
        role: 1,
        email: emailCtrlSignUp.text.trim(),
        name: fullNameCtrl.text.trim(),
        phoneNumber: phoneRaw ?? '',
        countryCode: phoneDial ?? "91",
        password: passwordCtrlSignUp.text.trim(),
        deviceToken: deviceToken,
        deviceType: deviceType,
        mailingAddress: "456 Broadway, New York, NY 10001",
        agreedToTerms: true,
        isTruthfully: true,
        location: {
          "type": "Point",
          "locationName": "Midtown",
          "coordinates": [-73.9857, 40.7484],
        },
      );

      final state = await executeParamsUseCase<AuthUser, SignUpParams>(
        useCase: useCase,
        query: params,
        launchLoader: true,
      );

      state?.when(
        data: (user) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Verify Your Otp Now')));
          context.pushRoute(const OtpVerificationRoute());
        },
        error: (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.message ?? 'Signup failed')));
        },
      );
    } finally {
      setSigningIn(false);
      _isResetting = false;
      notifyListeners();
    }
  }

  OtpPurpose? _otpPurpose;
  OtpPurpose? get otpPurpose => _otpPurpose;

  void startOtpFlow(OtpPurpose purpose) {
    _otpPurpose = purpose;
    verifyInit();
    notifyListeners();
  }

  String deviceToken = '';
  String deviceType = 'windows';

  Future<void> signIn({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    log('--login-- SignIn Info ----> token=$deviceToken type=$deviceType');

    setSigningIn(true);

    try {
      deviceToken = await DeviceInfoHelper.getDeviceToken();
      deviceType = await DeviceInfoHelper.getDeviceType();

      final signInUseCase = locator<SignInUseCase>();
      log('---- SignIn Info ----> token=$deviceToken type=$deviceType');

      final state = await executeParamsUseCase<AuthUser, SignInParams>(
        useCase: signInUseCase,
        query: SignInParams(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
          deviceToken: deviceToken,
          deviceType: deviceType,
        ),
        launchLoader: true,
      );

      state?.when(
        data: (user) async {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign-in successful')));
          // context.router.replaceAll([const HomeRoute()]);
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Sign-in failed')),
          );
        },
      );
    } finally {
      emailCtrl.clear();
      passwordCtrl.clear();
      setSigningIn(false); // ✅ unfreeze button
    }
  }

  Future<void> signUp({required BuildContext context}) async {
    setSigningIn(true);
    try {
      deviceToken = await DeviceInfoHelper.getDeviceToken();
      deviceType = await DeviceInfoHelper.getDeviceType();
      final useCase = locator<SignUpUseCase>();

      final params = SignUpParams(
        role: 1,
        email: "test1232@yopmail.com",
        name: fullNameCtrl.text.trim(),
        phoneNumber: phoneRaw ?? '',
        countryCode: phoneDial ?? "91",
        password: "Test@123",
        deviceToken: deviceToken,
        deviceType: deviceType,
        mailingAddress: "456 Broadway, New York, NY 10001",
        agreedToTerms: true,
        isTruthfully: true,
        location: {
          "type": "Point",
          "locationName": "Midtown",
          "coordinates": [-73.9857, 40.7484],
        },
      );

      final state = await executeParamsUseCase<AuthUser, SignUpParams>(
        useCase: useCase,
        query: params,
        launchLoader: true,
      );

      state?.when(
        data: (user) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Signup successful')));
        },
        error: (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.message ?? 'Signup failed')));
        },
      );
    } finally {
      setSigningIn(false);
    }
  }

  Future<void> forgotPasswordApi({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    log('--login-- SignIn Info ----> token=$deviceToken type=$deviceType');

    setSigningIn(true);

    try {
      deviceToken = await DeviceInfoHelper.getDeviceToken();
      deviceType = await DeviceInfoHelper.getDeviceType();

      final signInUseCase = locator<SignInUseCase>();
      log('---- SignIn Info ----> token=$deviceToken type=$deviceType');

      final state = await executeParamsUseCase<AuthUser, SignInParams>(
        useCase: signInUseCase,
        query: SignInParams(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
          deviceToken: deviceToken,
          deviceType: deviceType,
        ),
        launchLoader: true,
      );

      state?.when(
        data: (user) async {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign-in successful')));
          // context.router.replaceAll([const HomeRoute()]);
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Sign-in failed')),
          );
        },
      );
    } finally {
      emailCtrl.clear();
      passwordCtrl.clear();
      setSigningIn(false); // ✅ unfreeze button
    }
  }

  // Future<void> signUp({
  //   required GlobalKey<FormState> formKey,
  //   required BuildContext context,
  // }) async {
  //   if (!(formKey.currentState?.validate() ?? false)) return;

  //   final signUpUseCase = locator<SignUpUseCase>(); // Lazy load here

  //   final state = await executeParamsUseCase<AuthUser, SignUpParams>(
  //     useCase: signUpUseCase,
  //     query: SignUpParams(
  //       fullName: fullNameCtrl.text.trim(),
  //       email: emailCtrlSignUp.text.trim(),
  //       phoneE164: phoneE164 ?? '',
  //     ),
  //     launchLoader: true,
  //   );

  //   state?.when(
  //     data: (user) async {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Welcome ${user.fullName}!')),
  //       );
  //     },
  //     error: (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(e.errorResultModel.message ?? 'Sign-up failed')),
  //       );
  //     },
  //   );
  // }
}
