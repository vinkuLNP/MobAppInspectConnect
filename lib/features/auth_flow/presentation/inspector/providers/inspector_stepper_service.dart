import 'dart:developer';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_loggers.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_widgets.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/inspector_signup_case.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../../utils/text_editor_controller.dart';

class InsepctorPersistentDataService {
  final InspectorViewModelProvider provider;
  InsepctorPersistentDataService(this.provider);

  Future<InspectorSignUpLocalEntity?> getSavedData() async {
    return await provider.localDs.getFullData();
  }

  Future<void> loadSavedData() async {
    final saved = await provider.localDs.getFullData();
    log('📦 Loaded saved data: ${saved?.toString()}');
    if (saved == null) return;

    fullNameCtrl.text = saved.name ?? '';
    phoneCtrl.text = saved.phoneNumber ?? '';
    provider.phoneE164 = saved.phoneNumber;
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

      provider.setPhoneParts(
        iso: iso,
        dial: dial.isNotEmpty ? dial : '+91',
        number: raw,
        e164: phone,
      );
    }

    provider.selectedCertificateTypeId = saved.certificateTypeId;
    provider.setDate(DateTime.parse(saved.certificateExpiryDate.toString()));
    provider.uploadedCertificateUrls = saved.certificateDocuments ?? [];
    provider.existingDocumentUrls = List.from(provider.uploadedCertificateUrls);
    provider.selectedAgencyIds = saved.certificateAgencyIds ?? [];
    await provider.fetchCertificateTypes(
      savedId: provider.selectedCertificateTypeId,
    );
    countryController.text = saved.country.toString();
    stateController.text = saved.state.toString();
    cityController.text = saved.city.toString();
    mailingAddressController.text = saved.mailingAddress.toString();
    zipController.text = saved.zipCode.toString();
    if (saved.profileImage != null &&
        saved.profileImage!.isNotEmpty &&
        saved.profileImage != 'null') {
      provider.profileImageUrl = File(saved.profileImage!);
    }

    if (saved.uploadedIdOrLicenseDocument != null &&
        saved.uploadedIdOrLicenseDocument!.isNotEmpty &&
        saved.uploadedIdOrLicenseDocument != 'null') {
      provider.idLicenseUrl = File(saved.uploadedIdOrLicenseDocument!);
    }

    provider.referenceLettersUrls = (saved.referenceDocuments ?? [])
        .where((e) => e != 'null' && e.isNotEmpty)
        .map((e) => File(e))
        .toList();
    workHistoryController.text = saved.workHistoryDescription ?? '';
    provider.agreedToTerms = saved.agreedToTerms ?? false;
    provider.confirmTruth = saved.isTruthfully ?? false;
    provider.serviceAreas = saved.serviceAreas;
    if (saved.serviceAreas != [] && saved.serviceAreas.isNotEmpty) {
      final areas = saved.serviceAreas;
      provider.loadCountries();

      final savedCountryCode = areas.first.countryCode;
      final savedStateCode = areas.first.stateCode;

      provider.countryCode = savedCountryCode;
      provider.stateCode = savedStateCode;

      provider.selectedCountryCode = savedCountryCode;
      provider.selectedStateCode = savedStateCode;
      provider.selectedCities = areas
          .map((e) => e.cityName)
          .whereType<String>()
          .toList();
      provider.selectedCityNames = List.from(provider.selectedCities);

      provider.countryError = null;
      provider.stateError = null;
      provider.cityError = null;
      await provider.loadStates(savedCountryCode.toString());
      await provider.loadCities(savedCountryCode.toString());
      provider.setUserCurrentLocation();
    }

    provider.notify();
  }

  Future<void> signUp({required BuildContext context}) async {
    provider.notify();
    provider.setProcessing(true);

    try {
      AppLogger.info('SignUp', '🚀 Starting signup process');
      AppLogger.info('SignUp', 'Collecting device info');

      final saved = await provider.localDs.getFullData();
      if (saved == null) {
        AppLogger.error('SignUp', 'Saved data is null');
        return;
      }

      final useCase = locator<InspectorSignUpUseCase>();
      final params = InspectorSignUpParams(inspectorSignUpLocalEntity: saved);

      AppLogger.info('SignUp', 'Parameters ready');
      AppLogger.info('SignUp', 'name=${saved.name}');
      AppLogger.info('SignUp', 'email=${saved.email}');
      AppLogger.info('SignUp', 'phone=${saved.phoneNumber}');
      AppLogger.info('SignUp', 'countryCode=${saved.countryCode}');

      final state = await provider
          .executeParamsUseCase<AuthUser, InspectorSignUpParams>(
            useCase: useCase,
            query: params,
            launchLoader: true,
          );

      state?.when(
        data: (user) async {
          AppLogger.info('SignUp', 'Signup success → userId=${user.id}');

          final localUser = user.toLocalEntity();
          await locator<AuthLocalDataSource>().saveUser(localUser);

          if (context.mounted) {
            final userProvider = context.read<UserProvider>();
            await userProvider.setUser(localUser);
            await userProvider.loadUser();

            showSnackBar(context, message: verifyOtp);

            context.pushRoute(OtpVerificationRoute(addShowButton: true));
          }
        },
        error: (e) {
          AppLogger.error('SignUp', e.message ?? signupFailed);

          showSnackBar(context, message: e.message ?? signupFailed);
        },
      );
    } catch (e, s) {
      AppLogger.error('SignUp', 'Exception: $e');
      log(s.toString());
    } finally {
      provider.setProcessing(false);
      provider.notify();
      AppLogger.info('SignUp', '🧹 Cleanup complete');
    }
  }
}
