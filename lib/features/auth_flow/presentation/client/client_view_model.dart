import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/helpers/device_helper/device_helper.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/get_user__usercase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/otp_verification_usecases.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/resend_otp_usecases.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/sign_in_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/sign_up_usecases.dart';
import 'package:inspect_connect/features/auth_flow/utils/otp_enum.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:provider/provider.dart';

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
    context.pushRoute(ResetPasswordRoute(showBackButton: true));
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


Future<void> resetPassword({
  required GlobalKey<FormState> formKey,
  required BuildContext context,
}) async {
  if (!(formKey.currentState?.validate() ?? false)) {
    log('[RESET_PASSWORD] ❌ Form validation failed — aborting.');
    return;
  }

  _isResetting = true;
  notifyListeners();
  setSigningIn(true);

  try {
    log('[RESET_PASSWORD] 🚀 Starting reset password process...');
    log('[RESET_PASSWORD] Collecting device info...');

    deviceToken = await DeviceInfoHelper.getDeviceToken();
    deviceType = await DeviceInfoHelper.getDeviceType();

    log('[RESET_PASSWORD] Device token: $deviceToken');
    log('[RESET_PASSWORD] Device type: $deviceType');

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

    log('[RESET_PASSWORD] Parameters ready:');
    log('  name=${params.name}');
    log('  email=${params.email}');
    log('  phone=${params.phoneNumber}');
    log('  countryCode=${params.countryCode}');
    log('  password=${params.password.isNotEmpty ? "***" : "empty"}');

    final state = await executeParamsUseCase<AuthUser, SignUpParams>(
      useCase: useCase,
      query: params,
      launchLoader: true,
    );

    state?.when(
      data: (user) async {
        log('[RESET_PASSWORD] ✅ API returned user data:');
        log('  id=${user.id}');
        log('  token=${user.token}');
        log('  fullName=${user.fullName}');
        log('  email=${user.emailHashed}');
        log('  phone=${user.phoneNumber}');

        final localUser = user.toLocalEntity();
        log('[RESET_PASSWORD] Converted to local entity:');
        log('  token=${localUser.token}');
        log('  name=${localUser.name}');
        log('  email=${localUser.email}');
        log('  phone=${localUser.phoneNumber}');

        await locator<AuthLocalDataSource>().saveUser(localUser);
        log('[RESET_PASSWORD] ✅ Local user saved.');

        final userProvider = context.read<UserProvider>();
        await userProvider.setUser(localUser);
        await userProvider.loadUser();
        log('[RESET_PASSWORD] ✅ User loaded into provider.');

        log('[RESET_PASSWORD] Verifying saved data:');
        log('  saved token=${localUser.token}');
        log('  saved name=${localUser.name}');
        log('  saved email=${localUser.email}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verify Your Otp Now')),
        );
        context.pushRoute(OtpVerificationRoute(addShowButton: true));
      },
      error: (e) {
        log('[RESET_PASSWORD] ❌ API error: ${e.message}');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? 'Signup failed')));
      },
    );
  } catch (e, s) {
    log('[RESET_PASSWORD] ❌ Exception during reset: $e');
    log('[RESET_PASSWORD] Stacktrace: $s');
  } finally {
    setSigningIn(false);
    _isResetting = false;
    notifyListeners();
    log('[RESET_PASSWORD] 🧹 Cleanup complete.');
  }
}



Future<void> verify({required BuildContext context}) async {
  if (!canVerify) return;

  try {
    log('[VERIFY] Starting verification process...');

    // final user = await locator<AuthLocalDataSource>().getUser();
    // if (user == null) {
    //   log('[VERIFY] ❌ No local user found.');
    //   throw Exception('User not found in local storage');
    // }

    // log('[VERIFY] Found local user: id=${user.id}, token=${user.token}, phone=${user.phoneNumber}');
// 
    final verifyOtpUseCase = locator<OtpVerificarionUseCase>();
    final state = await executeParamsUseCase<AuthUser, OtpVerificationParams>(
      useCase: verifyOtpUseCase,
      query: OtpVerificationParams(
        phoneNumber: '9925356568',
        // user.phoneNumber ?? emailCtrl.text.trim(),
        countryCode: '+91',
        // user.countryCode ?? passwordCtrl.text.trim(),
        phoneOtp: pinController.text.trim(),
      ),
      launchLoader: true,
    );

    state?.when(
      data: (user) async {


        log('[VERIFY] ✅ OTP verification successful, received user from API:@$user');
        log('  id=${user.id}');
        log('  iroled=${user.role}');

        

        log('  token=${user.token}');
        log('  name=${user.fullName}');
        log('  email=${user.emailHashed}');
        log('  phone=${user.phoneNumber}');

        final newUserLocal = user.toLocalEntity();
        final existingUser = await locator<AuthLocalDataSource>().getUser();

        log('[VERIFY] Existing local user before merge:');
        log('  id=${existingUser?.id}');
        log('  token=${existingUser?.token}');
        log('  name=${existingUser?.name}');
        log('  email=${existingUser?.email}');
        log('  phone=${existingUser?.phoneNumber}');

        // Merge or replace
        final merged = existingUser != null
            ? existingUser.mergeWithNewData(newUserLocal)
            : newUserLocal;

        log('[VERIFY] Merged user before saving:');
        log('  id=${merged.id}');
        log('  token=${merged.token}');
        log('  name=${merged.name}');
        log('  email=${merged.email}');
        log('  phone=${merged.phoneNumber}');

        await locator<AuthLocalDataSource>().saveUser(merged);
        log('[VERIFY] ✅ User saved locally after merge.');

        await fetchUserDetail(user: user, context: context);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sign-up successful')));
        pinController.clear();
        if(user.role == 1){
        context.router.replaceAll([const ClientDashboardRoute()]);

        }else{
        context.router.replaceAll([const InspectorDashboardRoute()]);

        }
      },
      error: (e) {
        log('[VERIFY] ❌ OTP verification failed: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Sign-up failed')),
        );
      },
    );
  } catch (e, s) {
    log('[VERIFY] ❌ Exception: $e');
    log('[VERIFY] Stacktrace: $s');
  } finally {
    emailCtrl.clear();
    passwordCtrl.clear();
    log('[VERIFY] Cleanup complete.');
  }
}


// Future<void> fetchUserDetail({
//   required AuthUser user,
//   required BuildContext context,
// }) async {
//   log('[FETCH_USER_DETAIL] Fetching user details for userId=${user.id}');

//   final localUser = user.toLocalEntity();
//   log('[FETCH_USER_DETAIL] Local entity before save: token=${localUser.token}, name=${localUser.name}');

//   await locator<AuthLocalDataSource>().saveUser(localUser);
//   log('[FETCH_USER_DETAIL] Saved local user.');

//   final userProvider = context.read<UserProvider>();
//   await userProvider.setUser(localUser);
//   await userProvider.loadUser();

//   log('[FETCH_USER_DETAIL] Local user loaded into provider: id=${user.id}, token=${user.token}');

  // final fetchUserUseCase = locator<GetUserUseCase>();
  // final userState = await executeParamsUseCase<UserDetail, GetUserParams>(
  //   useCase: fetchUserUseCase,
  //   query: GetUserParams(userId: user.id),
  //   launchLoader: true,
  // );

  // userState?.when(
  //   data: (userData) async {
  //     log('[FETCH_USER_DETAIL] ✅ Received user detail from API: ${userData.fullName} (${userData.email})');

  //     final mergedUser = localUser.mergeWithUserDetail(userData);
  //     log('[FETCH_USER_DETAIL] Merged user detail: token=${mergedUser.token}, name=${mergedUser.name}');

  //     await locator<AuthLocalDataSource>().saveUser(mergedUser);
  //     log('[FETCH_USER_DETAIL] ✅ User detail saved locally after merge.');

  //     await userProvider.setUser(mergedUser);
  //     log('[FETCH_USER_DETAIL] ✅ User updated in provider.');
  //   },
  //   error: (e) {
  //     log('[FETCH_USER_DETAIL] ❌ Failed to fetch user detail: ${e.message}');
  //     context.router.replaceAll([const ClientDashboardRoute()]);
  //   },
  // );
// }

Future<void> fetchUserDetail({
  required AuthUser user,
  required BuildContext context,
}) async {
  log('[FETCH_USER_DETAIL] Fetching user details for userId=${user.id}');

  // Get existing local user first
  final existingUser = await locator<AuthLocalDataSource>().getUser();

  final localUser = user.toLocalEntity();

  // ✅ Preserve token if API user doesn’t include one
  if (localUser.token == null || localUser.token!.isEmpty) {
    log('[FETCH_USER_DETAIL] ⚠️ No token in API user — reusing local token.');
    localUser.token = existingUser?.token;
  }

  log('[FETCH_USER_DETAIL] Local entity before save: token=${localUser.token}, name=${localUser.name}');

  await locator<AuthLocalDataSource>().saveUser(localUser);
  log('[FETCH_USER_DETAIL] Saved local user.');

  final userProvider = context.read<UserProvider>();
  await userProvider.setUser(localUser);
  await userProvider.loadUser();

  log('[FETCH_USER_DETAIL] Local user loaded into provider: id=${user.id}, token=${localUser.token}');
  final fetchUserUseCase = locator<GetUserUseCase>();
  final userState = await executeParamsUseCase<UserDetail, GetUserParams>(
    useCase: fetchUserUseCase,
    query: GetUserParams(userId: user.id),
    launchLoader: true,
  );

  userState?.when(
    data: (userData) async {
      log('[FETCH_USER_DETAIL] ✅ Received user detail from API: ${userData.fullName} (${userData.email})');

      final mergedUser = localUser.mergeWithUserDetail(userData);
      log('[FETCH_USER_DETAIL] Merged user detail: token=${mergedUser.token}, name=${mergedUser.name}');

      await locator<AuthLocalDataSource>().saveUser(mergedUser);
      log('[FETCH_USER_DETAIL] ✅ User detail saved locally after merge.');

      await userProvider.setUser(mergedUser);
      log('[FETCH_USER_DETAIL] ✅ User updated in provider.');
    },
    error: (e) {
      log('[FETCH_USER_DETAIL] ❌ Failed to fetch user detail: ${e.message}');
      context.router.replaceAll([const ClientDashboardRoute()]);
    },
  );
}




  Future<void> resend({required BuildContext context}) async {
    if (!canResend) return;

    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
      final resendOtpUseCase = locator<ResendOtpUseCase>();
      final state = await executeParamsUseCase<AuthUser, ResendOtpParams>(
        useCase: resendOtpUseCase,
        query: ResendOtpParams(
          phoneNumber: user.phoneNumber ?? emailCtrl.text.trim(),
          countryCode: user.countryCode ?? passwordCtrl.text.trim(),
        ),
        launchLoader: true,
      );

      state?.when(
        data: (user) async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resend Otp successful')),
          );

          pinController.clear();
          _startCooldown();
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
      // setSigningIn(false);
    }
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
      context.pushRoute(OtpVerificationRoute(addShowButton: true));
    } finally {
      _isSendingReset = false;
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
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    log('✅ Internet available');
  }

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
       
          await fetchUserDetail(user: user, context: context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign-in successful')));
          emailCtrl.clear();
          passwordCtrl.clear();
          context.router.replaceAll([const ClientDashboardRoute()]);
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Sign-in failed')),
          );
        },
      );
    } 
    on SocketException catch (_) {
  log('❌ No Internet connection');
}
    finally {
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
      setSigningIn(false);
    }
  }
}
   // final localUser = user.toLocalEntity();
          // await locator<AuthLocalDataSource>().saveUser(localUser);
          // final userProvider = context.read<UserProvider>();
          // await userProvider.setUser(localUser);

          // await userProvider.loadUser();
          // log(user.id);
          // log(user.token);

          // final fetchUserUseCase = locator<GetUserUseCase>();
          // final userState =
          //     await executeParamsUseCase<UserDetail, GetUserParams>(
          //       useCase: fetchUserUseCase,
          //       query: GetUserParams(userId: user.id),
          //       launchLoader: true,
          //     );
          // userState?.when(
          //   data: (userData) async {
          //     final mergedUser = localUser.mergeWithUserDetail(userData);
          //     await locator<AuthLocalDataSource>().saveUser(mergedUser);

          //     await userProvider.setUser(mergedUser);

          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Sign-in successful')),
          //     );
          //     emailCtrl.clear();
          //     passwordCtrl.clear();
          //     context.router.replaceAll([const ClientDashboardRoute()]);
          //   },
          //   error: (e) {
          //     context.router.replaceAll([const ClientDashboardRoute()]);
          //   },
          // );
