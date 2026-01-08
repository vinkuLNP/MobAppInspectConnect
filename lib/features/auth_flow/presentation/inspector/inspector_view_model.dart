import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/inspector_local_data_source.dart';
import 'package:inspect_connect/features/auth_flow/data/models/ui_icc_document.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_type_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/icc_document_entity.dart';
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
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/upload_image_usecase.dart';

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
  final Map<String, List<IccDocumentLocalEntity>> iccLocalFiles = {};
  final Map<String, List<String>> iccUploadedUrls = {};
  Map<String, String> iccExpiryDates = {};
  Map<String, List<IccUiDocument>> iccDocsByCity = {};
  void preloadIccDocuments(String city, List<IccDocumentLocalEntity> docs) {
    iccDocsByCity[city] = docs.map((d) {
      return IccUiDocument(
        uploadedUrl: d.documentUrl,
        expiryDate: DateTime.parse(d.expiryDate),
      );
    }).toList();

    notifyListeners();
  }

  File? profileImage;
  String? profileImageUrl;
  File? idDocumentFile;
  String? idDocumentUploadedUrl;

  File? coiFile;
  String? coiUploadedUrl;

  List<File> referenceLetters = [];
  List<String> referenceLettersUrls = [];
  Future<void> addIccFile({
    required BuildContext context,
    required String city,
    required File file,
  }) async {
    try {
      setProcessing(true);

      if (await file.length() > 2 * 1024 * 1024) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File must be under 2 MB')),
          );
        }
        return;
      }

      final uploadUseCase = locator<UploadImageUseCase>();

      final result =
          await executeParamsUseCase<
            UploadImageResponseModel,
            UploadImageParams
          >(
            useCase: uploadUseCase,
            query: UploadImageParams(
              filePath: UploadImageDto(filePath: file.path),
            ),
            launchLoader: true,
          );

      result?.when(
        data: (response) {
          iccDocsByCity.putIfAbsent(city, () => []);
          iccDocsByCity[city]!.add(
            IccUiDocument(localFile: file, uploadedUrl: response.fileUrl),
          );
          notifyListeners();
        },
        error: (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.message ?? 'Upload failed')));
        },
      );
    } catch (e) {
      log('ICC upload error: $e');
    } finally {
      setProcessing(false);
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

  InspectorDocumentsTypeEntity? selectedIdDocType;
  DateTime? selectedIdDocExpiry;

  DateTime? coiExpiry;
  bool _autoValidate = false;
  bool get autoValidate => _autoValidate;

  String certificateExpiryDate = '';
  DateTime certificateExpiryDateShow = DateTime.now();

  String get selectedcertificateExpiryDate => certificateExpiryDate;
  List<JurisdictionEntity> jurisdictions = [];
  List<InspectorDocumentsTypeEntity> inspectorDocumentsType = [];
  Map<String, bool> cityRequiresIcc = {};
  List<IccDocumentLocalEntity> iccDocuments = [];
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

  File? idLicense;
  File? idLicenseUrl;

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

  void removeCoi() {
    coiUploadedUrl = null;
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
  }) => additionalStepService.pickFile(
    context,
    type,
    allowOnlyImages: allowOnlyImages,
  );

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
    zipCode: zipCode,
    mailingAddress: mailingAddress,
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

  void hydrateIccFromLocalDb(List<dynamic>? storedDocs) {
    if (storedDocs == null || storedDocs.isEmpty) return;

    iccDocsByCity.clear();

    for (final e in storedDocs) {
      late final String city;
      late final String url;
      late final DateTime expiry;

      if (e is Map<String, dynamic>) {
        city = e['serviceCity'];
        url = e['documentUrl'];
        expiry = DateTime.parse(e['expiryDate']);
      } else if (e is IccDocumentLocalEntity) {
        city = e.serviceCity;
        url = e.documentUrl;
        expiry = DateTime.parse(e.expiryDate);
      } else {
        continue;
      }

      iccDocsByCity.putIfAbsent(city, () => []);
      iccDocsByCity[city]!.add(
        IccUiDocument(
          // : url.split('/').last,
          uploadedUrl: url,
          expiryDate: expiry,
          // isUploaded: true,
        ),
      );
    }

    notify();
  }

  void recalculateCityIccRequirement() {
    cityRequiresIcc.clear();

    for (final city in selectedCityNames) {
      cityRequiresIcc[city] = inspectorServiceAreaService.isJurisdictionCity(
        city,
      );
    }
  }

  List<IccDocumentLocalEntity> iccDocsForCity(String city) {
    return iccDocuments.where((d) => d.serviceCity == city).toList();
  }

  bool validateIccDocuments() {
    for (final city in selectedCityNames) {
      if (cityRequiresIcc[city] == true) {
        final docs = iccDocuments.where((d) => d.serviceCity == city).toList();

        if (docs.isEmpty) {
          cityError = 'ICC document required for $city';
          notify();
          return false;
        }

        for (final d in docs) {
          if (d.expiryDate == '') {
            cityError = 'Expiry date required for ICC in $city';
            notify();
            return false;
          }
        }
      }
    }
    return true;
  }

  Future<void> pickIccExpiryDate(
    BuildContext context,
    IccDocumentLocalEntity doc,
  ) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      doc.expiryDate = picked.toIso8601String().split('T').first;
      notify();
    }
  }
}
