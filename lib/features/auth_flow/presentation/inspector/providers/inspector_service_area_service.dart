import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inspect_connect/core/utils/constants/app_keywords.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/service_area_entity.dart';
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
    provider.selectedCityNames = names;
    provider.selectedCities = List.from(names);
    if (names.isNotEmpty) clearCityErrors();
    provider.notify();
  }

  void removeCity(String city) {
    provider.selectedCityNames.remove(city);
    provider.selectedCities.remove(city);

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

    provider.zipError = validateZip(zipController.text);
    provider.mailingAddressError = validateAddress(
      mailingAddressController.text,
    );

    provider.notify();

    return provider.countryError == null &&
        provider.stateError == null &&
        provider.cityError == null &&
        provider.zipError == null &&
        provider.mailingAddressError == null;
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
    provider.zipCode = zipController.text;
    provider.mailingAddress = mailingAddressController.text;
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
          ServiceAreaKeywords.keyLocation: {
            ServiceAreaKeywords.keyType:
                s.locationType ?? ServiceAreaKeywords.locationTypePoint,
            ServiceAreaKeywords.keyCoordinates: [s.longitude, s.latitude],
          },
        };
      }).toList();
    }

    await provider.localDs.updateFields(fieldsToUpdate);
  }
}
