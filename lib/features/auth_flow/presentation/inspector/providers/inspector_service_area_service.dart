import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_keywords.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/features/auth_flow/data/models/jurisdiction_data_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/settings_model.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/jurisdiction_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/service_area_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/settings_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/get_max_number_of_cities_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/jurisdiction_usecase.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:inspect_connect/features/auth_flow/utils/text_editor_controller.dart';

class InspectorServiceAreaService {
  final InspectorViewModelProvider provider;
  InspectorServiceAreaService(this.provider);

  Future<void> loadCountries() async {
    if (provider.cachedCountries != null) return;
    provider.cachedCountries = await csc.getAllCountries();
    provider.notify();
  }

  Future<void> loadStates(String countryCode) async {
    if (provider.cachedStates.containsKey(countryCode)) return;
    provider.cachedStates[countryCode] = await csc.getStatesOfCountry(
      countryCode,
    );
    provider.notify();
  }

  Future<void> loadCities(String countryCode) async {
    if (provider.cachedCities.containsKey(countryCode)) return;
    provider.cachedCities[countryCode] = await csc.getCountryCities(
      countryCode,
    );

    provider.notify();
  }

  void selectCountry(String code) {
    provider.selectedCountryCode = code;
    provider.selectedStateCode = null;
    provider.selectedCityNames.clear();
    provider.selectedCities.clear();
    provider.countryError = null;
    provider.notify();
  }

  void selectState(String code) {
    provider.selectedStateCode = code;
    provider.selectedCityNames.clear();
    provider.selectedCities.clear();
    provider.stateError = null;
    provider.notify();
  }

  void selectCities(List<String> names) {
    log('--- Cities selected from UI ---');
    log('Selected cities: $names');
    provider.selectedCityNames = names;
    provider.selectedCities = List.from(names);
    provider.cityRequiresIcc.clear();
    for (final city in names) {
      final requiresIcc = isJurisdictionCity(city);

      log('Checking ICC requirement for city: "$city"');
      log('→ Requires ICC: $requiresIcc');

      provider.cityRequiresIcc[city] = requiresIcc;
    }
    log('Final cityRequiresIcc map: ${provider.cityRequiresIcc}');

    if (names.isNotEmpty) clearCityErrors();
    provider.notify();
  }

  bool isJurisdictionCity(String cityName) {
    log('--- Jurisdiction comparison start ---');
    log('Incoming city: "$cityName"');
    log('Incoming normalized: "${cityName.toLowerCase().trim()}"');
    final jurisdictionCities = provider.jurisdictions
        .map((j) => j.name)
        .toList();
    final normalizedJurisdictionCities = provider.jurisdictions
        .map((j) => j.name.toLowerCase().trim())
        .toList();

    log('Normalized jurisdiction cities: $normalizedJurisdictionCities');

    log('Jurisdiction cities: $jurisdictionCities');

    for (final j in provider.jurisdictions) {
      log(
        'Jurisdiction city: '
        '"${j.name}" → normalized: "${j.name.toLowerCase().trim()}"',
      );
    }

    final result = provider.jurisdictions.any(
      (j) => j.name.toLowerCase().trim() == cityName.toLowerCase().trim(),
    );

    log('Comparison result for "$cityName": $result');
    log('--- Jurisdiction comparison end ---');

    return result;
  }

  void removeCity(String city) {
    provider.selectedCityNames.remove(city);
    provider.selectedCities.remove(city);

    provider.iccDocuments.removeWhere((doc) => doc.serviceCity == city);

    provider.removeCityZip(city);

    provider.cityRequiresIcc.remove(city);

    if (provider.selectedCityNames.isEmpty) {
      validateServiceArea();
    }

    provider.notify();
  }

  void clearCityErrors() {
    provider.cityError = null;
  }

  bool validateServiceArea() {
    provider.countryError = provider.countryCode == null
        ? selectCountryError
        : null;
    provider.stateError = provider.stateCode == null ? selectStateError : null;
    provider.cityError = provider.selectedCities.isEmpty
        ? selectCityError
        : null;
    provider.iccError = null;
    for (final city in provider.selectedCities) {
      final error = validateIccForCity(city);
      if (error != null) {
        provider.iccError = error;
        break;
      }
    }

    provider.mailingAddressError = validateAddress(
      inspMailingAddressController.text,
    );

    provider.notify();

    return provider.countryError == null &&
        provider.stateError == null &&
        provider.cityError == null &&
        provider.iccError == null &&
        provider.mailingAddressError == null;
  }

  String? validateIccForCity(String city) {
    final requiresIcc = provider.cityRequiresIcc[city] == true;
    if (!requiresIcc) return null;

    final docs = provider.iccDocsByCity[city];

    if (docs == null || docs.isEmpty) {
      return "$iccDocumentRequiredFor $city";
    }

    for (final doc in docs) {
      if (doc.expiryDate == null) {
        return "$expiryDateRequiredForIccIn $city";
      }
    }

    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) return mailingAddressRequired;
    return null;
  }

  String? validateZip(String? value) {
    if (value == null || value.isEmpty) return zipRequired;
    final numeric = RegExp(r"^[0-9]+$");
    if (!numeric.hasMatch(value)) return zipNumericOnly;
    return null;
  }

  Future<void> generateServiceAreas({
    required String countryCode,
    required String stateCode,
    required List<String> selectedCities,
  }) async {
    provider.serviceAreas.clear();

    final allCities = (await csc.getCountryCities(
      countryCode,
    )).where((c) => c.stateCode == stateCode).toList();

    for (final cityName in selectedCities) {
      final city = allCities.firstWhere(
        (c) => c.name == cityName,
        orElse: () => throw Exception(cityNotFound(cityName, stateCode)),
      );

      provider.serviceAreas.add(
        ServiceAreaLocalEntity(
          countryCode: countryCode,
          stateCode: stateCode,
          cityName: cityName,
          zipCode: provider.cityZipCodes[cityName],
          locationType: ServiceAreaKeywords.locationTypePoint,
          latitude: double.tryParse(city.latitude.toString()),
          longitude: double.tryParse(city.longitude.toString()),
        ),
      );
    }
  }

  void saveSelectedServiceDataToProvider() {
    provider.country = provider.selectedCountryCode == null
        ? defaultCountry
        : provider.cachedCountries!
              .firstWhere((c) => c.isoCode == provider.selectedCountryCode!)
              .name;
    provider.state = provider.selectedStateCode == null
        ? defaultState
        : provider.cachedStates[provider.selectedCountryCode]!
              .firstWhere((s) => s.isoCode == provider.selectedStateCode!)
              .name;
    provider.city = provider.selectedCityNames[0];
    provider.zipCode = inspZipController.text;
    provider.mailingAddress = inspMailingAddressController.text;
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
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    final lat = pos.latitude;
    final lng = pos.longitude;

    final placemarks = await placemarkFromCoordinates(lat, lng);
    final p = placemarks.first;

    provider.userCurrentCountry = p.isoCountryCode ?? "";
    provider.userCurrentState = p.administrativeArea ?? "";
    provider.userCurrentCity = p.locality ?? "";

    provider.userCurrentLat = lat;
    provider.userCurrentLng = lng;

    provider.notify();
  }

  Future<void> saveServiceAreaStep({
    required String country,
    required String state,
    required String city,
    String? mailingAddress,
    String? zipCode,
    required List<ServiceAreaLocalEntity>? serviceAreas,
  }) async {
    log('Saving Service Area Step');
    log('ICC Local Files at save: ${provider.iccLocalFiles}');
    log('ICC Uploaded URLs at save: ${provider.iccDocsByCity}');

    final fieldsToUpdate = {
      ServiceAreaKeywords.keyCountry: provider.userCurrentCountry,
      ServiceAreaKeywords.keyState: provider.userCurrentState,
      ServiceAreaKeywords.keyCity: provider.userCurrentCity,
      if (mailingAddress != null)
        ServiceAreaKeywords.keyMailingAddress: mailingAddress,
      if (zipCode != null) ServiceAreaKeywords.keyZipCode: zipCode,
      ServiceAreaKeywords.keyLocationType:
          ServiceAreaKeywords.locationTypePoint,
      ServiceAreaKeywords.keyLocationName:
          ServiceAreaKeywords.locationNameDefault,
      ServiceAreaKeywords.keyLatitude: provider.userCurrentLat,
      ServiceAreaKeywords.keyLongitude: provider.userCurrentLng,
    };

    if (serviceAreas != null) {
      fieldsToUpdate[ServiceAreaKeywords.keyServiceAreas] = serviceAreas.map((
        s,
      ) {
        log('latidit---------------${s.latitude.toString()}');
        log('ngto---------------${s.longitude.toString()}');

        return {
          ServiceAreaKeywords.keyCountryCode: s.countryCode,
          ServiceAreaKeywords.keyStateCode: s.stateCode,
          ServiceAreaKeywords.keyCityName: s.cityName,
          ServiceAreaKeywords.keyZipCode: provider.cityZipCodes[s.cityName],
          ServiceAreaKeywords.keyLocation: {
            ServiceAreaKeywords.keyType:
                s.locationType ?? ServiceAreaKeywords.locationTypePoint,
            ServiceAreaKeywords.keyCoordinates: [s.longitude, s.latitude],
          },
        };
      }).toList();
    }

    fieldsToUpdate['iccDocument'] = provider.iccDocsByCity.entries.expand((
      entry,
    ) {
      final city = entry.key;
      return entry.value.map((doc) {
        return {
          'serviceCity': city,
          'id': doc.documentId,
          'fileName': doc.fileName,
          'documentUrl': doc.uploadedUrl,
          'expiryDate': doc.expiryDate!.toIso8601String().split('T').first,
        };
      });
    }).toList();
    await provider.localDs.updateFields(fieldsToUpdate);
  }

  Future<void> fetchJurisdictions() async {
    try {
      provider.setProcessing(true);

      final getSubTypesUseCase = locator<GetJurisdictionCitiesUseCase>();

      final state = await provider
          .executeParamsUseCase<
            List<JurisdictionEntity>,
            GetJurisdictionParams
          >(useCase: getSubTypesUseCase, launchLoader: true);

      state?.when(
        data: (response) {
          final modelList = response
              .map(
                (e) => JurisdictionDataModel(
                  id: e.id,
                  name: e.name,
                  type: e.type,
                  status: e.status,
                  createdAt: e.createdAt,
                  updatedAt: e.updatedAt,
                  v: e.v,
                ),
              )
              .toList();

          provider.jurisdictions = modelList;
          log(provider.jurisdictions.length.toString());
          provider.notify();
        },
        error: (e) {
          log("Error fetching certificate types: $e");
        },
      );
    } catch (e) {
      log("Exception in fetchCertificateTypes: $e");
    } finally {
      provider.setProcessing(false);
    }
  }

  Future<void> fetchMaxNumberOfCities() async {
    try {
      provider.setProcessing(true);

      final getSubTypesUseCase = locator<GetSettingsUseCase>();

      final state = await provider
          .executeParamsUseCase<SettingEntity, SettingsParams>(
            useCase: getSubTypesUseCase,
            launchLoader: true,
            query: SettingsParams(type: 5.toString()),
          );

      state?.when(
        data: (response) {
          final modelList = SettingsDataModel.fromEntity(response);
          provider.setting = modelList;
          log(provider.setting!.toString());
          provider.maxCitiesAllowed = modelList.maxCities;

          provider.notify();
        },
        error: (e) {
          log("Error fetching certificate types: $e");
        },
      );
    } catch (e) {
      log("Exception in fetchCertificateTypes: $e");
    } finally {
      provider.setProcessing(false);
    }
  }
}
