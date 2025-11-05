import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/additional_details_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/personal_detail_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/professtional_detail_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/service_area_entity.dart';
import 'package:inspect_connect/features/auth_flow/utils/otp_enum.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class InspectorViewModelProvider extends BaseViewModel {
  void init() {}
  bool _autoValidate = false;
  bool get autoValidate => _autoValidate;

  void enableAutoValidate() {
    if (!_autoValidate) {
      _autoValidate = true;
      notifyListeners();
    }
  }
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool get obscure => _obscure;

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  Future<void> signIn({required GlobalKey<FormState> formKey}) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
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

    context.pushRoute( OtpVerificationRoute(addShowButton: true));
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
    switch (_otpPurpose) {
      case OtpPurpose.signUp:
        context.router.replaceAll([const InspectorSignInRoute()]);
        break;
      case OtpPurpose.forgotPassword:
        context.router.replaceAll([ ResetPasswordRoute(showBackButton: false)]);
        break;
      default:
        context.router.replaceAll([const InspectorSignInRoute()]);
        break;
    }
  }

  Future<void> resend() async {
    if (!canResend) return;
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
    final pOk =
        (phoneE164 != null &&
        phoneE164!.isNotEmpty &&
        (phoneRaw?.length ?? 0) >= 6);
    if (!eOk && !pOk) return 'Enter a valid email or phone';
    return null;
  }

  Future<void> requestPasswordReset({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    _isSendingReset = true;
    notifyListeners();

    try {
      final email = resetEmailCtrl.text.trim();
      final useEmail = email.isNotEmpty;

      _resetTargetLabel = useEmail ? email : phoneE164;

      // verifyInit();
      startOtpFlow(OtpPurpose.forgotPassword);
      context.pushRoute( OtpVerificationRoute(addShowButton: true));
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
    if (!canVerify) return;

    _isResetting = true;
    notifyListeners();

    try {

      context.router.replaceAll([ InspectorSignInRoute()]);
    } finally {
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

  int _currentStep = 0;
  int get currentStep => _currentStep;

  final personal = PersonalDetails();
  final professional = ProfessionalDetails();
  final serviceArea = ServiceAreaDetails();
  final additional = AdditionalDetails();

  void goNext() {
    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    }
  }

  void goPrevious() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goTo(int index) {
    _currentStep = index.clamp(0, 3);
    notifyListeners();
  }

  /// Example final submission
  Future<void> submit() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

 void addServiceArea(String area) {
    if (area.trim().isEmpty) return;
    serviceArea.serviceAreas.add(area.trim());
    notifyListeners();
  }

  void removeServiceArea(String area) {
    serviceArea.serviceAreas.remove(area);
    notifyListeners();
  }

  void setCity(String city) {
    serviceArea.city = city.trim();
    notifyListeners();
  }

  // --- Terms toggle ---
  void setTermsAccepted(bool v) {
    additional.termsAccepted = v;
    notifyListeners();
  }

final Map<String, String> certAuthorityByType = {
    'PMP Certification': 'Project Management Institute (PMI)',
    'NEBOSH IGC': 'NEBOSH',
    'ISO 9001 Lead Auditor': 'IRCA / Exemplar Global',
    'Other': 'Self-declared / Local body'
  };

 String? certificationType;
  String? certifyingBody;             // auto-filled
  DateTime? expirationDate;
  List<PlatformFile> certFiles = [];
  
  void setCertificationType(String? v) {
    certificationType = v;
    certifyingBody = v == null ? null : certAuthorityByType[v];
    notifyListeners();
  }

  void setExpirationDate(DateTime? d) {
    expirationDate = d;
    notifyListeners();
  }

  Future<void> pickCertificationFiles() async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: false,
    );
    if (res != null && res.files.isNotEmpty) {
      certFiles = res.files;
      notifyListeners();
    }
  }

  int get uploadedCount => certFiles.length;

  // validators you can reuse in the form
  String? validateCertType(String? _) =>
      certificationType == null ? 'Certification type is required' : null;

  String? validateExpiry(String? _) {
    if (expirationDate == null) return 'Select an expiration date';
    final today = DateTime.now();
    if (!expirationDate!.isAfter(DateTime(today.year, today.month, today.day))) {
      return 'Date must be in the future';
    }
    return null;
  }


  List<File> documents = [];
  List<String> existingDocumentUrls = [];

  Future<void> uploadDocument(BuildContext context) async {
    final picker = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (picker != null && picker.files.single.path != null) {
      documents.add(File(picker.files.single.path!));
      notifyListeners();
    }
  }

  void removeDocumentAt(int index) {
    documents.removeAt(index);
    notifyListeners();
  }

  void removeExistingDocumentAt(int index) {
    existingDocumentUrls.removeAt(index);
    notifyListeners();
  }

  void openDocument(String url) {
    // open remote document (use url_launcher or open_file)
  }

  void openLocalDocument(File file) {
    // open local file
  }

  String? country;
  String? state;
  String? city;

  void setCountry(String? value) {
    country = value;
    state = null;
    city = null;
    notifyListeners();
  }

  void setStateValue(String? value) {
    state = value;
    city = null;
    notifyListeners();
  }

  void setDropCity(String? value) {
    city = value;
    notifyListeners();
  }
}

