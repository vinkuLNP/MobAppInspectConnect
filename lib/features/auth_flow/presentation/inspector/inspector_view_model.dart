import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/helpers/device_helper/device_helper.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/inspector_local_data_source.dart';
import 'package:inspect_connect/features/auth_flow/data/models/certificate_inspector_type_datamodel.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_agency_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_type_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/service_area_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/agency_type_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/certificate_type_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/inspector_signup_case.dart';
import 'package:inspect_connect/features/auth_flow/utils/otp_enum.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/upload_image_usecase.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:country_state_city/country_state_city.dart' as csc;

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

  String certificateExpiryDate = '';
  DateTime certificateExpiryDateShow = DateTime.now();

  String get selectedcertificateExpiryDate => certificateExpiryDate;
  void setDate(DateTime d) {
    certificateExpiryDateShow = DateTime(d.year, d.month, d.day);
    certificateExpiryDate = certificateExpiryDateShow
        .toIso8601String()
        .split('T')
        .first;
    notifyListeners();
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
  List<String> uploadedCertificateUrls = [];
  List<String>? selectedAgencyIds;

  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrlSignUp = TextEditingController();
  final addressCtrl = TextEditingController();
  final passwordCtrlSignUp = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final mailingAddressController = TextEditingController();
  void saveDataToProvider() {
    country = countryController.text;
    state = stateController.text;
    city = cityController.text;
    zipCode = zipController.text;
    mailingAddress = mailingAddressController.text;
  }

  String? city;
  String? mailingAddress;
  String? zipCode;
  List<ServiceAreaLocalEntity> serviceAreas = [];

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
    if (!agreeTnC || !isTruthful) {
      return;
    }
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

  String? errorMessage;

  bool validateProfessionalDetails() {
    final totalDocs = documents.length + existingDocumentUrls.length;

    if (certificateInspectorType == null) {
      errorMessage = "Please select a certificate type";
      notifyListeners();
      return false;
    }

    if (totalDocs == 0 || uploadedCertificateUrls == []) {
      errorMessage = "Please upload at least one certification document";
      notifyListeners();
      return false;
    }

    errorMessage = null;
    return true;
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
    try {
      setProcessing(true);
      if (picker == null && picker!.files.single.path == null) return;
      final file = File(picker.files.single.path.toString());
      if (await file.length() > 2 * 1024 * 1024) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: textWidget(
                text: 'File must be under 2 MB',
                color: AppColors.backgroundColor,
              ),
            ),
          );
        }
        return;
      }
      final uploadImage = UploadImageDto(filePath: file.path);
      final uploadImageUseCase = locator<UploadImageUseCase>();
      final result =
          await executeParamsUseCase<
            UploadImageResponseModel,
            UploadImageParams
          >(
            useCase: uploadImageUseCase,
            query: UploadImageParams(filePath: uploadImage),
            launchLoader: true,
          );

      result?.when(
        data: (response) {
          documents.add(
            picker.files.single.path != null
                ? File(picker.files.single.path!)
                : file,
          );
          uploadedCertificateUrls.add(response.fileUrl);
          notifyListeners();
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: textWidget(
                text: e.message ?? 'Image upload failed',
                color: AppColors.backgroundColor,
              ),
            ),
          );
        },
      );
    } catch (e) {
      log('Error picking file: $e');
    } finally {
      setProcessing(false);
    }
  }

  void removeDocumentAt(int index) {
    documents.removeAt(index);
    uploadedCertificateUrls.removeAt(index);
    notifyListeners();
  }

  void removeExistingDocumentAt(int index) {
    existingDocumentUrls.removeAt(index);
    uploadedCertificateUrls.removeAt(index);
    notifyListeners();
  }

  void openDocument(String url) {}

  void openLocalDocument(File file) {}

  final picker = ImagePicker();

  File? profileImage;
  File? profileImageUrl;

  File? idLicense;
  File? idLicenseUrl;

  List<File> referenceLetters = [];
  List<File> referenceLettersUrls = [];

  bool agreedToTerms = false;
  bool confirmTruth = false;
  final TextEditingController workHistoryController = TextEditingController();

  bool isProcessing = false;

  void toggleTerms(bool? value) {
    agreedToTerms = value ?? false;
    notifyListeners();
  }

  bool showValidationError = false;

  void validateBeforeSubmit({required BuildContext context}) {
    if (!agreedToTerms || !confirmTruth) {
      showValidationError = true;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: textWidget(
            text: 'Please agree to all terms before continuing.',
            color: AppColors.backgroundColor,
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    showValidationError = false;
    notifyListeners();
  }

  void toggleTruth(bool? value) {
    confirmTruth = value ?? false;
    notifyListeners();
  }

  bool validate(BuildContext context) {
    if (profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: textWidget(
            text: 'Please upload a profile image',
            color: AppColors.backgroundColor,
          ),
        ),
      );
      return false;
    }
    if (!agreedToTerms || !confirmTruth) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: textWidget(
            text: 'Please agree to all conditions',
            color: AppColors.backgroundColor,
          ),
        ),
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
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: textWidget(
            text: 'Profile submitted successfully!',
            color: AppColors.backgroundColor,
          ),
        ),
      );
    }
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
    selectedCertificateTypeId = t?.id;
    log('------------id. ${t!.id.toString()}');
    log('------------name. ${t.name.toString()}');

    fetchCertificateAgencies();
    notifyListeners();
  }

  void setAgencyType(AgencyEntity? t) {
    _agencyType = t;
    selectedAgencyIds = [t?.id ?? ''];
    notifyListeners();
  }

  Future<void> fetchCertificateTypes({String? savedId}) async {
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
          final modelList = response
              .map(
                (e) => CertificateInspectorTypeModelData(
                  id: e.id,
                  name: e.name,
                  status: e.status,
                  createdAt: e.createdAt,
                  updatedAt: e.updatedAt,
                  v: e.v,
                ),
              )
              .toList();

          certificateType = modelList;

          CertificateInspectorTypeModelData selectedType;
          if (savedId != null) {
            log(savedId);
            selectedType = modelList.firstWhere(
              (e) => e.id == savedId,
              orElse: () => modelList.first,
            );
          } else {
            selectedType = modelList.first;
          }

          setCertificateType(selectedType);
          notifyListeners();
        },
        error: (e) {
          log("Error fetching certificate types: $e");
        },
      );
    } catch (e) {
      log("Exception in fetchCertificateTypes: $e");
    } finally {
      setProcessing(false);
    }
  }

  Future<void> fetchCertificateAgencies({String? savedId}) async {
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
          if (savedId != null) {
            final matched = response.firstWhere(
              (e) => e.id == savedId,
              orElse: () => response.first,
            );
            setAgencyType(matched);
          } else {
            setAgencyType(response.first);
          }
          notifyListeners();
        },
        error: (e) {},
      );
    } catch (e) {
      log(e.toString());
    } finally {
      setProcessing(false);
    }
  }

  Future<void> pickFile(
    BuildContext context,
    String type, {
    bool allowOnlyImages = false,
  }) async {
    try {
      setProcessing(true);

      if (allowOnlyImages) {
        final picked = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );

        if (picked == null) return;

        final file = File(picked.path);
        if (await file.length() > 1 * 1024 * 1024) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: 'File must be under 1 MB',
                  color: AppColors.backgroundColor,
                ),
              ),
            );
          }
          return;
        }

        final uploadImage = UploadImageDto(filePath: file.path);
        final uploadImageUseCase = locator<UploadImageUseCase>();
        final result =
            await executeParamsUseCase<
              UploadImageResponseModel,
              UploadImageParams
            >(
              useCase: uploadImageUseCase,
              query: UploadImageParams(filePath: uploadImage),
              launchLoader: true,
            );

        result?.when(
          data: (response) {
            profileImageUrl = File(response.fileUrl);
            profileImage = File(file.path);
            notifyListeners();
          },
          error: (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: e.message ?? 'Image upload failed',
                  color: AppColors.backgroundColor,
                ),
              ),
            );
          },
        );
      } else {
        setProcessing(true);
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
        );
        if (result == null && result!.files.single.path == null) return;
        final file = File(result.files.single.path.toString());
        if (await file.length() > 2 * 1024 * 1024) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: 'File must be under 2 MB',
                  color: AppColors.backgroundColor,
                ),
              ),
            );
          }
          return;
        }
        final uploadImage = UploadImageDto(filePath: file.path);
        final uploadImageUseCase = locator<UploadImageUseCase>();
        final responseResult =
            await executeParamsUseCase<
              UploadImageResponseModel,
              UploadImageParams
            >(
              useCase: uploadImageUseCase,
              query: UploadImageParams(filePath: uploadImage),
              launchLoader: true,
            );

        responseResult?.when(
          data: (response) {
            if (type == 'id') {
              idLicense = file;
              idLicenseUrl = File(response.fileUrl);
            } else if (type == 'ref') {
              referenceLetters.add(file);
              referenceLettersUrls.add(File(response.fileUrl));
            }
            notifyListeners();
          },
          error: (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: e.message ?? 'Image upload failed',
                  color: AppColors.backgroundColor,
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      log('Error picking file: $e');
    } finally {
      setProcessing(false);
    }
  }

  Future<void> savePersonalStep() async {
    if (selectedCertificateTypeId != null) {
      await fetchCertificateTypes(savedId: selectedCertificateTypeId);
    } else {
      fetchCertificateTypes();
    }

    final deviceToken = await DeviceInfoHelper.getDeviceToken();
    final deviceType = await DeviceInfoHelper.getDeviceType();
    await _localDs.updateFields({
      'role': 2,
      'deviceType': deviceType,

      'deviceToken': deviceToken,
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

  Future<void> setUserCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final lat = pos.latitude;
    final lng = pos.longitude;

    final placemarks = await placemarkFromCoordinates(lat, lng);
    final p = placemarks.first;

    userCurrentCountry = p.isoCountryCode ?? "";
    userCurrentState = p.administrativeArea ?? "";
    userCurrentCity = p.locality ?? "";

    userCurrentLat = lat;
    userCurrentLng = lng;

    notifyListeners();
  }

  double? userCurrentLat;
  double? userCurrentLng;
  String userCurrentCountry = '';
  String userCurrentState = '';
  String userCurrentCity = '';

  Future<void> saveServiceAreaStep({
    required String country,
    required String state,
    required String city,
    String? mailingAddress,
    String? zipCode,
    required List<ServiceAreaLocalEntity>? serviceAreas,
  }) async {
    final fieldsToUpdate = {
      'country': userCurrentCountry,
      'state': userCurrentState,
      'city': userCurrentCity,
      if (mailingAddress != null) 'mailingAddress': mailingAddress,
      if (zipCode != null) 'zipCode': zipCode,
      'locationType': 'Point',
      'locationName': 'Midtown',
      'latitude': userCurrentLat,
      'longitude': userCurrentLng,
    };

    if (serviceAreas != null) {
      fieldsToUpdate['serviceAreas'] = serviceAreas.map((s) {
        log('latidit---------------${s.latitude.toString()}');
        log('ngto---------------${s.longitude.toString()}');

        return {
          "countryCode": s.countryCode,
          "stateCode": s.stateCode,
          "cityName": s.cityName,
          "location": {
            "type": s.locationType ?? "Point",
            "coordinates": [s.longitude, s.latitude],
          },
        };
      }).toList();
    }

    await _localDs.updateFields(fieldsToUpdate);
  }

  Future<void> saveAdditionalStep({
    String? profileImageUrlOrPath,
    String? idLicenseUrlOrPath,
    String? workHistoryDescription,

    List<String>? referenceDocs,
    bool? agreed,
    bool? truthful,
  }) async {
    await _localDs.updateFields({
      if (profileImageUrlOrPath != null) 'profileImage': profileImageUrlOrPath,
      if (idLicenseUrlOrPath != null)
        'uploadedIdOrLicenseDocument': idLicenseUrlOrPath,
      if (referenceDocs != null) 'referenceDocuments': referenceDocs,
      if (workHistoryDescription != null)
        'workHistoryDescription': workHistoryDescription,

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

    fullNameCtrl.text = saved.name ?? '';
    phoneCtrl.text = saved.phoneNumber ?? '';
    phoneE164 = saved.phoneNumber;
    emailCtrlSignUp.text = saved.email ?? '';
    passwordCtrlSignUp.text = saved.password ?? '';
    if (saved.phoneNumber != null && saved.phoneNumber!.isNotEmpty) {
      final phone = saved.phoneNumber!;
      String dial = saved.countryCode ?? '';
      String iso = saved.isoCode ?? '';

      String raw = phone;

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

    selectedCertificateTypeId = saved.certificateTypeId;
    setDate(DateTime.parse(saved.certificateExpiryDate.toString()));
    uploadedCertificateUrls = saved.certificateDocuments ?? [];
    existingDocumentUrls = List.from(uploadedCertificateUrls);
    selectedAgencyIds = saved.certificateAgencyIds ?? [];
    await fetchCertificateTypes(savedId: selectedCertificateTypeId);
    countryController.text = saved.country.toString();
    stateController.text = saved.state.toString();
    cityController.text = saved.city.toString();
    mailingAddressController.text = saved.mailingAddress.toString();
    zipController.text = saved.zipCode.toString();
    if (saved.profileImage != null &&
        saved.profileImage!.isNotEmpty &&
        saved.profileImage != 'null') {
      profileImageUrl = File(saved.profileImage!);
    }

    if (saved.uploadedIdOrLicenseDocument != null &&
        saved.uploadedIdOrLicenseDocument!.isNotEmpty &&
        saved.uploadedIdOrLicenseDocument != 'null') {
      idLicenseUrl = File(saved.uploadedIdOrLicenseDocument!);
    }

    referenceLettersUrls = (saved.referenceDocuments ?? [])
        .where((e) => e != 'null' && e.isNotEmpty)
        .map((e) => File(e))
        .toList();
    workHistoryController.text = saved.workHistoryDescription ?? '';
    agreedToTerms = saved.agreedToTerms ?? false;
    confirmTruth = saved.isTruthfully ?? false;
    serviceAreas = saved.serviceAreas;
    if (saved.serviceAreas != [] && saved.serviceAreas.isNotEmpty) {
      final areas = saved.serviceAreas;
loadCountries();

      final savedCountryCode = areas.first.countryCode;
      final savedStateCode = areas.first.stateCode;

      countryCode = savedCountryCode;
      stateCode = savedStateCode;

      selectedCountryCode = savedCountryCode;
      selectedStateCode = savedStateCode;
      selectedCities = areas
          .map((e) => e.cityName)
          .whereType<String>()
          .toList();
      selectedCityNames = List.from(selectedCities);

      countryError = null;
      stateError = null;
      cityError = null;
      await loadStates(savedCountryCode.toString());
      await loadCities(savedCountryCode.toString());
      setUserCurrentLocation();

      notifyListeners();
    }

    notifyListeners();
  }





 String? selectedCountryCode;
  String? selectedStateCode;
  List<String> selectedCityNames = [];

List<csc.Country>? cachedCountries;
Map<String, List<csc.State>> cachedStates = {};
Map<String, List<csc.City>> cachedCities = {};

bool loadingCountries = false;
bool loadingStates = false;
bool loadingCities = false;

Future<void> loadCountries() async {
  if (cachedCountries != null) return;
  loadingCountries = true;
  notifyListeners();

  cachedCountries = await csc.getAllCountries();

  loadingCountries = false;
  notifyListeners();
}

Future<void> loadStates(String countryCode) async {
  if (cachedStates.containsKey(countryCode)) return;
  loadingStates = true;
  notifyListeners();

  cachedStates[countryCode] = await csc.getStatesOfCountry(countryCode);

  loadingStates = false;
  notifyListeners();
}

Future<void> loadCities(String countryCode) async {
  if (cachedCities.containsKey(countryCode)) return;
  loadingCities = true;
  notifyListeners();

  cachedCities[countryCode] = await csc.getCountryCities(countryCode);

  loadingCities = false;
  notifyListeners();
}

void selectCountry(String code) {
  selectedCountryCode = code;
  selectedStateCode = null;
  selectedCityNames.clear();
  selectedCities.clear();
  countryError = null;
  notifyListeners();
}

void selectState(String code) {
  selectedStateCode = code;
  selectedCityNames.clear();
  selectedCities.clear();
  stateError = null;
  notifyListeners();
}

void selectCities(List<String> names) {
  selectedCityNames = names;
  selectedCities = List.from(names);
  if (names.isNotEmpty) clearCityErrors();
  notifyListeners();
}

void removeCity(String city) {
  selectedCityNames.remove(city);
  selectedCities.remove(city);

  if (selectedCityNames.isEmpty) {
    validateServiceArea();
  }
  notifyListeners();
}



  Future<void> signUp({required BuildContext context}) async {
    _isResetting = true;
    notifyListeners();
    setProcessing(true);

    try {
      log('[SignUP] 🚀 Startingsignup process...');
      log('[SignUP] Collecting device info...');

      final saved = await _localDs.getFullData();

      final useCase = locator<InspectorSignUpUseCase>();

      final params = InspectorSignUpParams(inspectorSignUpLocalEntity: saved!);

      log('[SignUP] Parameters ready:');
      log('  name=${params.inspectorSignUpLocalEntity.name}');
      log('  email=${params.inspectorSignUpLocalEntity.email}');
      log('  phone=${params..inspectorSignUpLocalEntity.phoneNumber}');
      log('  countryCode=${params.inspectorSignUpLocalEntity.countryCode}');
      log(
        '  password=${params.inspectorSignUpLocalEntity.password!.isNotEmpty ? "***" : "empty"}',
      );

      final state = await executeParamsUseCase<AuthUser, InspectorSignUpParams>(
        useCase: useCase,
        query: params,
        launchLoader: true,
      );

      state?.when(
        data: (user) async {
          log('  id=${user.id}');
          log('  token=${user.authToken}');
          log('  fullName=${user.name}');
          log('  email=${user.emailHashed}');
          log('  phone=${user.phoneNumber}');

          final localUser = user.toLocalEntity();
          log('[SignUP] Converted to local entity:');
          log('  token=${localUser.authToken}');
          log('  name=${localUser.name}');
          log('  email=${localUser.email}');
          log('  phone=${localUser.phoneNumber}');

          await locator<AuthLocalDataSource>().saveUser(localUser);
          log('[SignUP] ✅ Local user saved.');
          if (context.mounted) {
            final userProvider = context.read<UserProvider>();
            await userProvider.setUser(localUser);
            await userProvider.loadUser();
          }

          log('[SignUP] ✅ User loaded into provider.');

          log('[SignUP] Verifying saved data:');
          log('  saved token=${localUser.authToken}');
          log('  saved name=${localUser.name}');
          log('  saved email=${localUser.email}');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: 'Verify Your Otp Now',
                  color: AppColors.backgroundColor,
                ),
              ),
            );
            context.pushRoute(OtpVerificationRoute(addShowButton: true));
          }
        },
        error: (e) {
          log('[SignUP] ❌ API error: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: textWidget(
                text: e.message ?? 'Signup failed',
                color: AppColors.backgroundColor,
              ),
            ),
          );
        },
      );
    } catch (e, s) {
      log('[SignUP] ❌ Exception during reset: $e');
      log('[SignUP] Stacktrace: $s');
    } finally {
      setProcessing(false);
      _isResetting = false;
      notifyListeners();
      log('[SignUP] 🧹 Cleanup complete.');
    }
  }

  String country = '';
  String state = '';
  List<String> cities = [];
  List<String> selectedCities = [];
  String? countryCode;
  String? stateCode;

  void setCountry(String value) {
    log(value);
    countryCode = value;
    stateCode = null;
    cities = [];
    selectedCities.clear();
    countryError = null;
    notifyListeners();
  }

  void setState(String value) {
    stateCode = value;
    cities = [];
    selectedCities.clear();
    stateError = null;
    notifyListeners();
  }

  void toggleCity(String city) {
    if (selectedCities.contains(city)) {
      selectedCities.remove(city);
    } else {
      selectedCities.add(city);
      cityError = null;
    }

    notifyListeners();
  }

  String? countryError;
  String? stateError;
  String? cityError;
  String? zipError;
  String? mailingAddressError;
  void clearCityErrors() {
    cityError = null;
    notifyListeners();
  }

  bool validateServiceArea() {
    countryError = countryCode == null ? "Please select a country" : null;
    stateError = stateCode == null ? "Please select a state" : null;
    cityError = selectedCities.isEmpty ? "Select at least 1 city" : null;

    zipError = _validateZip(zipController.text);
    mailingAddressError = _validateAddress(mailingAddressController.text);

    notifyListeners();

    return countryError == null &&
        stateError == null &&
        cityError == null &&
        zipError == null &&
        mailingAddressError == null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) return "Please enter mailing address";
    return null;
  }

  String? _validateZip(String? value) {
    if (value == null || value.isEmpty) return "Please enter zip code";
    final numeric = RegExp(r"^[0-9]+$");
    if (!numeric.hasMatch(value)) return "Zip must be numeric";
    return null;
  }

  Future<void> generateServiceAreas({
    required String countryCode,
    required String stateCode,
    required List<String> selectedCities,
  }) async {
    serviceAreas.clear();

    final allCities = (await csc.getCountryCities(
      countryCode,
    )).where((c) => c.stateCode == stateCode).toList();

    for (final cityName in selectedCities) {
      final city = allCities.firstWhere(
        (c) => c.name == cityName,
        orElse: () => throw Exception("City $cityName not found in $stateCode"),
      );

      serviceAreas.add(
        ServiceAreaLocalEntity(
          countryCode: countryCode,
          stateCode: stateCode,
          cityName: cityName,
          locationType: "Point",
          latitude: double.tryParse(city.latitude.toString()),
          longitude: double.tryParse(city.longitude.toString()),
        ),
      );
    }
  }
}
