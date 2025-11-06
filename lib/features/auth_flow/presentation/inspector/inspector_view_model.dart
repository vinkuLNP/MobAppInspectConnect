import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/inspector_local_data_source.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_agency_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_type_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/agency_type_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/certificate_type_usecase.dart';
import 'package:inspect_connect/features/auth_flow/utils/otp_enum.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class InspectorViewModelProvider extends BaseViewModel {
  final InspectorSignUpLocalDataSource _localDs =
      locator<InspectorSignUpLocalDataSource>();
  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    notifyListeners();
    fetchCertificateTypes();

    isLoading = false;
    notifyListeners();
  }

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

  String? selectedCertificateTypeId;
  String? certificateExpiryDate;
  List<String>? uploadedCertificateUrls;
  List<String>? selectedAgencyIds;

  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrlSignUp = TextEditingController();
  final addressCtrl = TextEditingController();
  final passwordCtrlSignUp = TextEditingController();

  String? country;
  String? state;
  String? city;
  String? mailingAddress;
  String? zipCode;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
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

  Future<void> submitSignUp({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    // if (!agreeTnC || !isTruthful) {
    //   return;
    // }
    startOtpFlow(OtpPurpose.signUp);

    context.pushRoute(OtpVerificationRoute(addShowButton: true));
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
        context.router.replaceAll([ResetPasswordRoute(showBackButton: false)]);
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
      context.pushRoute(OtpVerificationRoute(addShowButton: true));
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
      context.router.replaceAll([InspectorSignInRoute()]);
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

  Future<void> submit() async {
    await Future.delayed(const Duration(milliseconds: 500));
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

  final picker = ImagePicker();

  File? profileImage;
  File? idLicense;
  List<File> referenceLetters = [];
  bool agreedToTerms = false;
  bool confirmTruth = false;
  final TextEditingController workHistoryController = TextEditingController();

  bool isProcessing = false;

  void toggleTerms(bool? value) {
    agreedToTerms = value ?? false;
    notifyListeners();
  }

  void toggleTruth(bool? value) {
    confirmTruth = value ?? false;
    notifyListeners();
  }

  bool validate(BuildContext context) {
    if (profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a profile image')),
      );
      return false;
    }
    if (!agreedToTerms || !confirmTruth) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to all conditions')),
      );
      return false;
    }
    return true;
  }

  Future<void> submitProfile(BuildContext context) async {
    if (!validate(context)) return;

    isProcessing = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    isProcessing = false;
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile submitted successfully!')),
    );
  }

  List<File> idImages = [];
  List<File> referenceLetterImages = [];

  void removeProfileImage() {
    profileImage = null;
    notifyListeners();
  }

  void removeIdImage(int i) {
    idLicense = null;
    notifyListeners();
  }

  void removeReferenceLetterImage(int i) {
    referenceLetters.removeAt(i);
    notifyListeners();
  }

  void setProcessing(bool value) {
    isProcessing = value;
    notifyListeners();
  }

  List<CertificateInspectorTypeEntity> certificateType = [];
  List<AgencyEntity> agencyType = [];

  CertificateInspectorTypeEntity? _certificateInspectorType;
  AgencyEntity? _agencyType;
  CertificateInspectorTypeEntity? get certificateInspectorType =>
      _certificateInspectorType;
  AgencyEntity? get agencyTypeData => _agencyType;

  void setCertificateType(CertificateInspectorTypeEntity? t) {
    _certificateInspectorType = t;
fetchCertificateAgencies();
    notifyListeners();
  }

  void setAgencyType(AgencyEntity? t) {
    _agencyType = t;

    notifyListeners();
  }

  Future<void> fetchCertificateTypes() async {
    try {
      setProcessing(true);
      final getSubTypesUseCase = locator<GetCertificateTypeUseCase>();
      final state =
          await executeParamsUseCase<
            List<CertificateInspectorTypeEntity>,
            GetCertificateInspectorTypesParams
          >(useCase: getSubTypesUseCase, launchLoader: true);

      state?.when(
        data: (response) {
          certificateType = response;
          setCertificateType(certificateType[0]);
          notifyListeners();
        },
        error: (e) {},
      );
    } catch (e) {
    } finally {
      setProcessing(false);
    }
  }

  Future<void> fetchCertificateAgencies() async {
    try {
      setProcessing(true);
      final getSubTypesUseCase = locator<GetAgencyUseCase>();
      final state =
          await executeParamsUseCase<List<AgencyEntity>, GetAgencyTypesParams>(
            useCase: getSubTypesUseCase,
            launchLoader: true,
          );

      state?.when(
        data: (response) {
          agencyType = response;
          setAgencyType(agencyType[0]);
          notifyListeners();
        },
        error: (e) {},
      );
    } catch (e) {
    } finally {
      setProcessing(false);
    }
  }

  Future<void> pickFile(
    BuildContext context,
    String type, {
    bool allowOnlyImages = false,
  }) async {
    if (allowOnlyImages) {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        profileImage = File(picked.path);
        notifyListeners();
      }
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        if (type == 'id') {
          idLicense = file;
        } else if (type == 'ref') {
          referenceLetters.add(file);
        }

        notifyListeners();
      }
    }
  }

  Future<void> savePersonalStep() async {
    fetchCertificateTypes();
    await _localDs.updateFields({
      'name': fullNameCtrl.text.trim(),
      'phoneNumber': phoneCtrl.text.trim(),
      'countryCode': phoneE164 != null && phoneE164!.startsWith('+')
          ? phoneE164!.substring(0, phoneE164!.length - (phoneCtrl.text.length))
          : phoneDial ?? (await _localDs.getFullData())?.countryCode ?? '+91',
      'email': emailCtrlSignUp.text.trim(),
      'password': passwordCtrlSignUp.text,
      'isoCode': phoneIso != "" || phoneIso != null || phoneIso!.isNotEmpty
          ? phoneIso
          : (await _localDs.getFullData())?.isoCode ?? 'IN',
    });
  }

  // Save professional step (step 2)
  Future<void> saveProfessionalStep({
    required String certificateTypeId,
    required String certificateExpiryDate,
    List<String>? uploadedCertificateUrls,
    List<String>? agencyIds,
  }) async {
    await _localDs.updateFields({
      'certificateTypeId': certificateTypeId,
      'certificateExpiryDate': certificateExpiryDate,
      'certificateDocuments': uploadedCertificateUrls ?? [],
      'certificateAgencyIds': agencyIds ?? [],
    });
  }

  // Save service area (step 3)
  Future<void> saveServiceAreaStep({
    required String country,
    required String state,
    required String city,
    String? mailingAddress,
    String? zipCode,
    // double? lat,
    // double? lng,
  }) async {
    await _localDs.updateFields({
      'country': country,
      'state': state,
      'city': city,
      if (mailingAddress != null) 'mailingAddress': mailingAddress,
      if (zipCode != null) 'zipCode': zipCode,

      // if (lat != null) 'latitude': lat,
      // if (lng != null) 'longitude': lng,
    });
  }

  Future<void> saveAdditionalStep({
    String? profileImageUrlOrPath,
    String? idLicenseUrlOrPath,
    List<String>? referenceDocs,
    bool? agreed,
    bool? truthful,
  }) async {
    await _localDs.updateFields({
      if (profileImageUrlOrPath != null) 'profileImage': profileImageUrlOrPath,
      if (idLicenseUrlOrPath != null)
        'uploadedIdOrLicenseDocument': idLicenseUrlOrPath,
      if (referenceDocs != null) 'referenceDocuments': referenceDocs,
      if (agreed != null) 'agreedToTerms': agreed,
      if (truthful != null) 'isTruthfully': truthful,
    });
  }

  Future<InspectorSignUpLocalEntity?> getSavedData() async {
    return await _localDs.getFullData();
  }

  Future<void> loadSavedData() async {
    final saved = await _localDs.getFullData();
    log('📦 Loaded saved data: ${saved?.toString()}');
    if (saved == null) return;

    // Step 1 - Personal
    fullNameCtrl.text = saved.name ?? '';
    phoneCtrl.text = saved.phoneNumber ?? '';
    phoneE164 = saved.phoneNumber;
    emailCtrlSignUp.text = saved.email ?? '';
    passwordCtrlSignUp.text = saved.password ?? '';
    if (saved.phoneNumber != null && saved.phoneNumber!.isNotEmpty) {
      // Extract dial code & raw number if possible
      final phone = saved.phoneNumber!;
      String dial = saved.countryCode ?? '';
      String iso = saved.isoCode ?? '';

      String raw = phone;

      // Try to split country code (assuming format like +911234567890)
      final match = RegExp(r'^\+(\d{1,3})(\d+)$').firstMatch(phone);
      if (match != null) {
        dial = '+${match.group(1)}';
        raw = match.group(2)!;
      }

      setPhoneParts(
        iso: iso,
        dial: dial.isNotEmpty ? dial : '+91',
        number: raw,
        e164: phone,
      );
    }

    // Step 2 - Professional
    selectedCertificateTypeId = saved.certificateTypeId;
    certificateExpiryDate = saved.certificateExpiryDate;
    uploadedCertificateUrls = saved.certificateDocuments ?? [];
    selectedAgencyIds = saved.certificateAgencyIds ?? [];

    // Step 3 - Service area
    country = saved.country;
    state = saved.state;
    city = saved.city;
    mailingAddress = saved.mailingAddress;
    zipCode = saved.zipCode;

    // Step 4 - Additional
    if (saved.profileImage != null && saved.profileImage!.isNotEmpty) {
      profileImage = File(saved.profileImage!);
    }
    if (saved.uploadedIdOrLicenseDocument != null &&
        saved.uploadedIdOrLicenseDocument!.isNotEmpty) {
      idLicense = File(saved.uploadedIdOrLicenseDocument!);
    }
    referenceLetters = (saved.referenceDocuments ?? [])
        .map((e) => File(e))
        .toList();
    agreedToTerms = saved.agreedToTerms ?? false;
    confirmTruth = saved.isTruthfully ?? false;

    notifyListeners();
  }
}
