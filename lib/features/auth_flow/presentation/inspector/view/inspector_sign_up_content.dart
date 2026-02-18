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
import 'package:inspect_connect/features/auth_flow/utils/text_editor_controller.dart';
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
                log('ICC Local Files: ${vm.iccLocalFiles}');
                log('ICC Uploaded URLs: ${vm.iccUploadedUrls}');
                log('Selected Cities: ${vm.selectedCityNames}');
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
                log("called");
                String? getSafePath(dynamic fileOrUrl) {
                  if (fileOrUrl == null) return null;
                  final path = fileOrUrl is File
                      ? fileOrUrl.path
                      : fileOrUrl.toString();

                  if (path.startsWith(httpProtocol) ||
                      path.startsWith(httpsProtocol)) {
                    return path;
                  }
                  return path;
                }

                final profilePath = getSafePath(vm.profileImageUrl);
                final idPath = getSafePath(vm.idDocumentUploadedUrl);
                final refs = vm.referenceLetters.map((f) {
                  final path = f.path;
                  return (path.startsWith(httpProtocol) ||
                          path.startsWith(httpsProtocol))
                      ? path
                      : path;
                }).toList();

                await vm.saveAdditionalStep(
                  profileImageUrlOrPath: profilePath.toString(),
                  idLicenseUrlOrPath: idPath,
                  referenceDocs: refs,
                  agreed: vm.agreedToTerms,
                  truthful: vm.confirmTruth,
                  workHistoryDescription: inspWorkHistoryController.text,
                );
                break;
            }

            if (vm.currentStep < steps.length - 1) {
              vm.goNext();
            } else {
              // await vm.submit();
              final saved = await vm.getSavedData();
              log('final data: ${saved?.toString()}');
              if (context.mounted) {
                vm.signUp(context: context);
              }
            }
          },
        ),
        form: Stack(
          children: [
            AbsorbPointer(
              absorbing: vm.isProcessing,
              child: Opacity(
                opacity: vm.isProcessing ? 0.6 : 1.0,
                child: Column(
                  children: [
                    AppCardContainer(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 16,
                      ),
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
            ),
            if (vm.isProcessing)
              Positioned.fill(
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
