import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_common_card_container.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/features/auth_flow/data/models/step_meta_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_steps/additional_detail.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_steps/personal_details_step.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_steps/professional_details.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_steps/service_area.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/sign_up_bottom_button_bar.dart';
import 'package:provider/provider.dart';
import '../inspector_view_model.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/inspector_common_auth_bar.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';

class InspectorSignUpContent extends StatefulWidget {
  final bool showBackButton;
  const InspectorSignUpContent({super.key, required this.showBackButton});

  @override
  State<InspectorSignUpContent> createState() => _InspectorSignUpContentState();
}

class _InspectorSignUpContentState extends State<InspectorSignUpContent> {
  final _personalKey = GlobalKey<FormState>();
  final _professionalKey = GlobalKey<FormState>();
  final _serviceAreaKey = GlobalKey<FormState>();
  final _additionalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final vm = context.read<InspectorViewModelProvider>();
        vm.loadSavedData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InspectorViewModelProvider>();
    final steps = [
      StepMeta(
        personalDetails,
        PersonalDetailsStep(vm, _personalKey),
        _personalKey,
      ),
      StepMeta(
        professionalDetails,
        ProfessionalDetailsStep(vm, _professionalKey),
        _professionalKey,
      ),
      StepMeta(
        serviceArea,
        ServiceAreaStep(vm, _serviceAreaKey),
        _serviceAreaKey,
      ),
      StepMeta(
        additionalDetails,
        AdditionalDetailsStep(vm, _additionalKey),
        _additionalKey,
      ),
    ];

    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) => InspectorCommonAuthBar(
        title: signUpTitle,
        showBackButton: false,
        subtitle: signUpSubtitle,
        image: finalImage,
        rc: rc,
        headerWidget: StepperHeader(
          current: vm.currentStep,
          labels: const [
            personalDetailsLabel,
            professionalDetailsLabel,
            serviceAreaLabel,
            additionalDetailsLabel,
          ],
          onTap: (i) {
            if (i <= vm.currentStep) vm.goTo(i);
          },
        ),
        bottomSection: SignupActionBar(
          vm: vm,
          onNext: () async {
            final key = steps[vm.currentStep].formKey;
            final isValid = key.currentState?.validate() ?? false;
            if (!isValid) {
              vm.enableAutoValidate();
              return;
            }
            key.currentState?.save();
            switch (vm.currentStep) {
              case 0:
                await vm.savePersonalStep();
                log('💾 Personal details saved');
                break;
              case 1:
                if (!vm.validateProfessionalDetails()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(vm.errorMessage ?? invalidInput)),
                  );
                  return;
                }

                await vm.saveProfessionalStep(
                  certificateTypeId: vm.selectedCertificateTypeId ?? '',
                  certificateExpiryDate: vm.certificateExpiryDate != ''
                      ? vm.certificateExpiryDate.toString()
                      : '',
                  uploadedCertificateUrls: vm.uploadedCertificateUrls,
                  agencyIds: vm.selectedAgencyIds,
                );
                break;
              case 2:
                final isValid = vm.validateServiceArea();
                if (!isValid) return;
                vm.saveSelectedServiceDataToProvider();

                await vm.generateServiceAreas(
                  countryCode: vm.countryCode.toString(),
                  stateCode: vm.stateCode.toString(),
                  selectedCities: vm.selectedCities,
                );

                await vm.saveServiceAreaStep(
                  country: vm.country,
                  state: vm.state,
                  city: vm.city ?? '',
                  mailingAddress: vm.mailingAddress,
                  zipCode: vm.zipCode,
                  serviceAreas: vm.serviceAreas,
                );

                break;
              case 3:
                vm.validateBeforeSubmit(context: ctx);
                if (!vm.agreedToTerms || !vm.confirmTruth) {
                  return;
                }
                String? getSafePath(dynamic fileOrUrl) {
                  if (fileOrUrl == null) return null;
                  final path = fileOrUrl is File
                      ? fileOrUrl.path
                      : fileOrUrl.toString();

                  if (path.startsWith('http://') ||
                      path.startsWith('https://')) {
                    return path;
                  }
                  return path;
                }

                final profilePath = getSafePath(vm.profileImageUrl);
                final idPath = getSafePath(vm.idLicenseUrl);
                final refs = vm.referenceLettersUrls.map((f) {
                  final path = f.path;
                  return (path.startsWith('http://') ||
                          path.startsWith('https://'))
                      ? path
                      : path;
                }).toList();

                await vm.saveAdditionalStep(
                  profileImageUrlOrPath: profilePath.toString(),
                  idLicenseUrlOrPath: idPath.toString(),
                  referenceDocs: refs,
                  agreed: vm.agreedToTerms,
                  truthful: vm.confirmTruth,
                  workHistoryDescription: vm.workHistoryController.text,
                );
                break;
            }

            if (vm.currentStep < steps.length - 1) {
              vm.goNext();
            } else {
              await vm.submit();
              final saved = await vm.getSavedData();
              log('final data: ${saved?.toString()}');
              if (context.mounted) {
                vm.signUp(context: context);
              }
            }
          },
        ),
        form: Column(
          children: [
            AppCardContainer(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Form(
                key: steps[vm.currentStep].formKey,
                autovalidateMode: vm.autoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: SingleChildScrollView(
                  child: steps[vm.currentStep].content,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}



// 1️⃣ Create a Step Controller in ViewModel
// In InspectorViewModelProvider
// Future<bool> handleNextStep(BuildContext context) async {
//   switch (currentStep) {
//     case 0:
//       await savePersonalStep();
//       return true;

//     case 1:
//       if (!validateProfessionalDetails()) {
//         _showError(context);
//         return false;
//       }
//       await saveProfessionalStep(
//         certificateTypeId: selectedCertificateTypeId ?? '',
//         certificateExpiryDate: certificateExpiryDate,
//         uploadedCertificateUrls: uploadedCertificateUrls,
//         agencyIds: selectedAgencyIds,
//       );
//       return true;

//     case 2:
//       if (!validateServiceArea()) return false;

//       saveDataToProvider();
//       await generateServiceAreas(
//         countryCode: countryCode,
//         stateCode: stateCode,
//         selectedCities: selectedCities,
//       );

//       await saveServiceAreaStep(
//         country: country,
//         state: state,
//         city: city ?? '',
//         mailingAddress: mailingAddress,
//         zipCode: zipCode,
//         serviceAreas: serviceAreas,
//       );
//       return true;

//     case 3:
//       return await _handleFinalStep(context);
//   }
//   return false;
// }

// Final Step Logic (Moved out of UI)
// Future<bool> _handleFinalStep(BuildContext context) async {
//   validateBeforeSubmit(context: context);

//   if (!agreedToTerms || !confirmTruth) return false;

//   await saveAdditionalStep(
//     profileImageUrlOrPath: _safePath(profileImageUrl),
//     idLicenseUrlOrPath: _safePath(idLicenseUrl),
//     referenceDocs: referenceLettersUrls.map(_safePath).toList(),
//     agreed: agreedToTerms,
//     truthful: confirmTruth,
//     workHistoryDescription: workHistoryController.text,
//   );

//   await submit();
//   return true;
// }

// Shared Helper (ViewModel, not UI)
// String _safePath(dynamic fileOrUrl) {
//   if (fileOrUrl == null) return '';

//   if (fileOrUrl is File) return fileOrUrl.path;

//   final path = fileOrUrl.toString();
//   return path;
// }

// Error Helper
// void _showError(BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text(errorMessage ?? invalidInput)),
//   );
// }

// 2️⃣ Make Steps Static & Clean

// Move step configuration to a getter:

// late final List<StepMeta> _steps;

// @override
// void initState() {
//   super.initState();

//   _steps = [
//     StepMeta(personalDetails, PersonalDetailsStep(vm, _personalKey), _personalKey),
//     StepMeta(professionalDetails, ProfessionalDetailsStep(vm, _professionalKey), _professionalKey),
//     StepMeta(serviceArea, ServiceAreaStep(vm, _serviceAreaKey), _serviceAreaKey),
//     StepMeta(additionalDetails, AdditionalDetailsStep(vm, _additionalKey), _additionalKey),
//   ];

//   Future.microtask(() => context.read<InspectorViewModelProvider>().loadSavedData());
// }

// 3️⃣ Ultra-Clean onNext in UI
// Before ❌

// 200+ lines of logic

// After ✅
// onNext: () async {
//   final step = _steps[vm.currentStep];
//   final isValid = step.formKey.currentState?.validate() ?? false;

//   if (!isValid) {
//     vm.enableAutoValidate();
//     return;
//   }

//   step.formKey.currentState?.save();

//   final success = await vm.handleNextStep(context);
//   if (!success) return;

//   if (vm.currentStep < _steps.length - 1) {
//     vm.goNext();
//   } else {
//     vm.signUp(context: context);
//   }
// },


// 💥 This is the biggest win

// 4️⃣ UI Polish (Subtle but Effective)
// A. Consistent Card Spacing
// AppCardContainer(
//   margin: const EdgeInsets.symmetric(horizontal: 12),
//   padding: const EdgeInsets.all(20),
//   child: Form(...)
// )

// B. Smooth Transitions Between Steps
// AnimatedSwitcher(
//   duration: const Duration(milliseconds: 300),
//   child: steps[vm.currentStep].content,
// )

// C. Prevent Scroll Jank
// SingleChildScrollView(
//   physics: const BouncingScrollPhysics(),
//   child: steps[vm.currentStep].content,
// )

// 5️⃣ Resulting Benefits

// ✅ Much smaller widget
// ✅ Business logic centralized
// ✅ Easy to add/remove steps
// ✅ Easier debugging
// ✅ Cleaner UI transitions
// ✅ Testable ViewModel methods

// Next Improvements (Optional)

// If you want to go further later:

// Convert StepMeta into sealed classes

// Extract StepperHeader logic into ViewModel

// Introduce AsyncState (loading/error/success)

// Add form-level analytics per step

// If you want, next I can:

// Refactor one step widget (e.g. ProfessionalDetailsStep)

// Convert this to Riverpod

// Add unit tests for ViewModel

// Improve StepperHeader UX