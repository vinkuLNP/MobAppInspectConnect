import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/inspector_local_data_source.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_type_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_documents_type.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/jurisdiction_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/service_area_entity.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/providers/insepctor_additional_step_service.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/providers/inspector_personal_step_service.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/providers/inspector_professional_service.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/providers/inspector_service_area_service.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/providers/inspector_persistent_data_service.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:inspect_connect/features/auth_flow/utils/text_editor_controller.dart';

class InspectorViewModelProvider extends BaseViewModel {
  Future<void> init() async {
    log('init being called');
    fetchCertificateTypes();
    loadCountries();
    fetchJurisdictions();
    fetchInspectorDocumentsType();
    notifyListeners();
  }

  late final InspectorPersonalStepService personalStepService;
  late final InspectorProfessionalStepService professionalStepService;
  late final InsepctorAdditionalStepService additionalStepService;
  late final InsepctorPersistentDataService persistentDataService;

  late final InspectorServiceAreaService inspectorServiceAreaService;

  InspectorViewModelProvider() {
    personalStepService = InspectorPersonalStepService(this);
    persistentDataService = InsepctorPersistentDataService(this);
    professionalStepService = InspectorProfessionalStepService(this);
    additionalStepService = InsepctorAdditionalStepService(this);
    inspectorServiceAreaService = InspectorServiceAreaService(this);
    init();
  }

  final InspectorSignUpLocalDataSource localDs =
      locator<InspectorSignUpLocalDataSource>();

  String? selectedCountryCode;
  String? selectedStateCode;
  List<String> selectedCityNames = [];
  List<csc.Country>? cachedCountries;
  Map<String, List<csc.State>> cachedStates = {};
  Map<String, List<csc.City>> cachedCities = {};
  String country = '';
  String state = '';
  List<String> cities = [];
  List<String> selectedCities = [];
  String? countryCode;
  String? stateCode;
  String? countryError;
  String? stateError;
  String? cityError;
  String? zipError;
  String? mailingAddressError;
  final Map<String, List<File>> iccLocalFiles = {};
  final Map<String, List<String>> iccUploadedUrls = {};

  void addIccFile(String city, File file) {
    iccLocalFiles.putIfAbsent(city, () => []);
    if (iccLocalFiles[city]!.length + (iccUploadedUrls[city]?.length ?? 0) <
        4) {
      iccLocalFiles[city]!.add(file);
      notifyListeners();
    }
  }

  void removeIccLocalFile(String city, int index) {
    iccLocalFiles[city]?.removeAt(index);
    notifyListeners();
  }

  void removeIccUploadedUrl(String city, int index) {
    iccUploadedUrls[city]?.removeAt(index);
    notifyListeners();
  }

  bool _autoValidate = false;
  bool get autoValidate => _autoValidate;

  String certificateExpiryDate = '';
  DateTime certificateExpiryDateShow = DateTime.now();

  String get selectedcertificateExpiryDate => certificateExpiryDate;
  List<JurisdictionEntity> jurisdictions = [];
  List<InspectorDocumentsTypeEntity> inspectorDocumentsType = [];
  Map<String, bool> cityRequiresIcc = {};
  Map<String, File?> iccDocuments = {};
  String? selectedCertificateTypeId;
  List<String> uploadedCertificateUrls = [];
  List<String>? selectedAgencyIds;
  String? city;
  String? mailingAddress;
  String? zipCode;
  List<ServiceAreaLocalEntity> serviceAreas = [];

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool agreeTnC = false;
  bool isTruthful = false;

  final focusNode = FocusNode();

  Timer? _timer;

  String? errorMessage;
  String? phoneIso;
  String? phoneDial;
  String? phoneRaw;
  String? phoneE164;

  int _currentStep = 0;
  int get currentStep => _currentStep;
  List<File> documents = [];
  List<String> existingDocumentUrls = [];

  File? profileImage;
  File? profileImageUrl;

  File? idLicense;
  File? idLicenseUrl;

  List<File> referenceLetters = [];
  List<File> referenceLettersUrls = [];

  bool agreedToTerms = false;
  bool confirmTruth = false;

  bool isProcessing = false;
  bool showValidationError = false;
  List<File> idImages = [];
  List<File> referenceLetterImages = [];

  List<CertificateInspectorTypeEntity> certificateType = [];

  CertificateInspectorTypeEntity? userCertificateInspectorType;
  CertificateInspectorTypeEntity? get certificateInspectorType =>
      userCertificateInspectorType;

  double? userCurrentLat;
  double? userCurrentLng;
  String userCurrentCountry = '';
  String userCurrentState = '';
  String userCurrentCity = '';

  void notify() {
    notifyListeners();
  }

  void enableAutoValidate() {
    if (!_autoValidate) {
      _autoValidate = true;
      notifyListeners();
    }
  }

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void setProcessing(bool value) {
    isProcessing = value;
    notifyListeners();
  }

  @override
  void dispose() {
    inspEmailCtrl.clear();
    inspPasswordCtrl.clear();
    inspFullNameCtrl.clear();
    inspPhoneCtrl.clear();
    inspEmailCtrlSignUp.clear();
    inspAddressCtrl.clear();
    inspPasswordCtrlSignUp.clear();
    _timer?.cancel();
    pinController.clear();
    focusNode.dispose();
    super.dispose();
  }

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

  void toggleTerms(bool? value) {
    agreedToTerms = value ?? false;
    notifyListeners();
  }

  void validateBeforeSubmit({required BuildContext context}) {
    if (!agreedToTerms || !confirmTruth) {
      showValidationError = true;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: textWidget(
            text: agreeToTerms,
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

  void setCountry(String value) {
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

  void clearCityErrors() {
    cityError = null;
    notifyListeners();
  }

  void setDate(DateTime d) => professionalStepService.setDate(d);

  void saveSelectedServiceDataToProvider() =>
      inspectorServiceAreaService.saveSelectedServiceDataToProvider();

  String? validateRequired(String? v) =>
      personalStepService.validateRequired(v);

  String? validateEmail(String? v) => personalStepService.validateEmail(v);
  String? validatePhone(String? v) => personalStepService.validatePhone(v);
  String? validatePassword(String? v) =>
      personalStepService.validatePassword(v);
  bool validateProfessionalDetails() =>
      professionalStepService.validateProfessionalDetails();
  void setPhoneParts({
    required String iso,
    required String dial,
    required String number,
    required String e164,
  }) => personalStepService.setPhoneParts(
    iso: iso,
    dial: dial,
    number: number,
    e164: e164,
  );

  Future<void> uploadDocument(BuildContext context) =>
      professionalStepService.uploadDocument(context);

  void removeDocumentAt(int index) =>
      professionalStepService.removeDocumentAt(index);

  void removeExistingDocumentAt(int index) =>
      professionalStepService.removeExistingDocumentAt(index);

  void setCertificateType(CertificateInspectorTypeEntity? t) =>
      professionalStepService.setCertificateType(t);

  Future<void> fetchCertificateTypes({String? savedId}) =>
      professionalStepService.fetchCertificateTypes(savedId: savedId);

  Future<void> pickFile(
    BuildContext context,
    String type, {
    bool allowOnlyImages = false,
  }) => additionalStepService.pickFile(context, type);

  Future<void> savePersonalStep() => personalStepService.savePersonalStep();

  Future<void> saveProfessionalStep({
    required String certificateTypeId,
    required String certificateExpiryDate,
    List<String>? uploadedCertificateUrls,
    List<String>? agencyIds,
  }) => professionalStepService.saveProfessionalStep(
    certificateTypeId: certificateTypeId,
    certificateExpiryDate: certificateExpiryDate,
    uploadedCertificateUrls: uploadedCertificateUrls,
  );

  Future<void> setUserCurrentLocation() =>
      inspectorServiceAreaService.setUserCurrentLocation();

  Future<void> fetchJurisdictions() =>
      inspectorServiceAreaService.fetchJurisdictions();

  Future<void> fetchInspectorDocumentsType() =>
      additionalStepService.fetchDocumentTypes();

  Future<void> saveServiceAreaStep({
    required String country,
    required String state,
    required String city,
    String? mailingAddress,
    String? zipCode,
    required List<ServiceAreaLocalEntity>? serviceAreas,
  }) => inspectorServiceAreaService.saveServiceAreaStep(
    country: country,
    state: state,
    city: city,
    serviceAreas: serviceAreas,
  );

  Future<void> saveAdditionalStep({
    String? profileImageUrlOrPath,
    String? idLicenseUrlOrPath,
    String? workHistoryDescription,
    List<String>? referenceDocs,
    bool? agreed,
    bool? truthful,
  }) => additionalStepService.saveAdditionalStep(
    profileImageUrlOrPath: profileImageUrlOrPath,
    idLicenseUrlOrPath: idLicenseUrlOrPath,
    workHistoryDescription: workHistoryDescription,
    referenceDocs: referenceDocs,
    agreed: agreed,
    truthful: truthful,
  );

  Future<InspectorSignUpLocalEntity?> getSavedData() =>
      persistentDataService.getSavedData();

  Future<void> loadSavedData() => persistentDataService.loadSavedData();

  Future<void> loadCountries() => inspectorServiceAreaService.loadCountries();

  Future<void> loadStates(String countryCode) =>
      inspectorServiceAreaService.loadStates(countryCode);

  Future<void> loadCities(String countryCode) =>
      inspectorServiceAreaService.loadCities(countryCode);

  void selectCountry(String code) =>
      inspectorServiceAreaService.selectCountry(code);

  void selectState(String code) =>
      inspectorServiceAreaService.selectState(code);
  void selectCities(List<String> names) =>
      inspectorServiceAreaService.selectCities(names);

  void removeCity(String city) => inspectorServiceAreaService.removeCity(city);

  Future<void> signUp({required BuildContext context}) =>
      persistentDataService.signUp(context: context);

  bool validateServiceArea() =>
      inspectorServiceAreaService.validateServiceArea();

  Future<void> generateServiceAreas({
    required String countryCode,
    required String stateCode,
    required List<String> selectedCities,
  }) => inspectorServiceAreaService.generateServiceAreas(
    countryCode: countryCode,
    stateCode: stateCode,
    selectedCities: selectedCities,
  );

  final Map<String, TextEditingController> cityZipControllers = {};

  final Map<String, String> cityZipCodes = {};

  TextEditingController getCityZipController(String city) {
    return cityZipControllers.putIfAbsent(
      city,
      () => TextEditingController(text: cityZipCodes[city] ?? ''),
    );
  }

  void removeCityZip(String city) {
    cityZipControllers[city]?.dispose();
    cityZipControllers.remove(city);
    cityZipCodes.remove(city);
  }

  bool validateIccDocuments() {
    for (final entry in cityRequiresIcc.entries) {
      if (entry.value == true && iccDocuments[entry.key] == null) {
        return false;
      }
    }
    return true;
  }
}
