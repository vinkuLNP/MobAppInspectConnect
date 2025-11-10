

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/inspector_sign_up_content.dart';
import 'package:provider/provider.dart';

@RoutePage()

class InspectorSignUpView extends StatelessWidget {
  final bool showBackButton;
  const InspectorSignUpView({super.key, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
     return ChangeNotifierProvider(
      create: (_) => InspectorViewModelProvider(),
      child: InspectorSignUpContent(showBackButton: showBackButton),
    );
  }
}
// class InspectorSignUpView extends StatefulWidget {
//   final bool showBackButton;
//   const InspectorSignUpView({super.key, required this.showBackButton});

//   @override
//   State<InspectorSignUpView> createState() => _InspectorSignUpViewState();
// }

// class _InspectorSignUpViewState extends State<InspectorSignUpView> {
//   final _personalKey = GlobalKey<FormState>();
//   final _professionalKey = GlobalKey<FormState>();
//   final _serviceAreaKey = GlobalKey<FormState>();
//   final _additionalKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       final vm = context.read<InspectorViewModelProvider>();
//       vm.loadSavedData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<InspectorViewModelProvider>();
//     final steps = [
//       _StepMeta(
//         'Personal Details',
//         PersonalDetailsStep(vm, _personalKey),
//         _personalKey,
//       ),
//       _StepMeta(
//         'Professional Details',
//         ProfessionalDetailsStep(vm, _professionalKey),
//         _professionalKey,
//       ),
//       _StepMeta(
//         'Service Area',
//         ServiceAreaStep(vm, _serviceAreaKey),
//         _serviceAreaKey,
//       ),
//       _StepMeta(
//         'Additional Details',
//         AdditionalDetailsStep(vm, _additionalKey),
//         _additionalKey,
//       ),
//     ];

//     return BaseResponsiveWidget(
//       initializeConfig: true,
//       buildWidget: (ctx, rc, app) => InspectorCommonAuthBar(
//         title: 'Sign Up',
//         showBackButton: false,
//         subtitle: 'Create Your Account!',
//         image: finalImage,
//         rc: rc,
//         headerWidget: StepperHeader(
//           current: vm.currentStep,
//           labels: const [
//             'Personal\nDetails',
//             'Professional\nDetails',
//             'Service\nArea',
//             'Additional\nDetails',
//           ],
//           onTap: (i) {
//             if (i <= vm.currentStep) vm.goTo(i);
//           },
//         ),
//         bottomSection: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: AppButton(
//                   isBorder: true,
//                   buttonBackgroundColor: Colors.white,
//                   borderColor: Colors.grey,
//                   textColor: AppColors.authThemeColor,
//                   onTap: () => vm.currentStep == 0 ? null : vm.goPrevious(),
//                   text: 'Previous',
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: AppButton(
//                   buttonBackgroundColor:
//                       (vm.currentStep == 3 &&
//                           (!vm.agreedToTerms || !vm.confirmTruth))
//                       ? Colors.grey
//                       : AppColors.authThemeColor,
//                   onTap:
//                       (vm.currentStep == 3 &&
//                           (!vm.agreedToTerms || !vm.confirmTruth))
//                       ? null // disables the button
//                       : () async {
//                           final key = steps[vm.currentStep].formKey;
//                           final isValid = key.currentState?.validate() ?? false;
//                           if (!isValid) {
//                             vm.enableAutoValidate();
//                             return;
//                           }
//                           key.currentState?.save();
//                           switch (vm.currentStep) {
//                             case 0:
//                               await vm.savePersonalStep();
//                               log('💾 Personal details saved');
//                               break;
//                             case 1:
//                               await vm.saveProfessionalStep(
//                                 certificateTypeId:
//                                     vm.selectedCertificateTypeId ?? '',
//                                 certificateExpiryDate:
//                                     vm.certificateExpiryDate.toString() ?? '',
//                                 uploadedCertificateUrls:
//                                     vm.uploadedCertificateUrls,
//                                 agencyIds: vm.selectedAgencyIds,
//                               );
//                               break;
//                             case 2:
//                               vm.saveDataToProvider();
//                               await vm.saveServiceAreaStep(
//                                 country: vm.country ?? '',
//                                 state: vm.state ?? '',
//                                 city: vm.city ?? '',
//                                 mailingAddress: vm.mailingAddress,
//                                 zipCode: vm.zipCode,

//                                 // lat: vm.serviceArea.latitude,
//                                 // lng: vm.serviceArea.longitude,
//                               );
//                               break;
//                             case 3:
//                               vm.validateBeforeSubmit(context: ctx);
//                               if (!vm.agreedToTerms || !vm.confirmTruth) {
//                                 return; // stop here if validation fails
//                               }
//                               // final profilePath =
//                               //     vm.profileImageUrl?.path ?? vm.profileImageUrl;
//                               // final idPath = vm.idLicenseUrl?.path ?? vm.idLicenseUrl;
//                               // final refs = vm.referenceLettersUrls
//                               //     .map((f) => f.path)
//                               //     .toList();
//                               String? getSafePath(dynamic fileOrUrl) {
//                                 if (fileOrUrl == null) return null;
//                                 final path = fileOrUrl is File
//                                     ? fileOrUrl.path
//                                     : fileOrUrl.toString();

//                                 // If it’s a Cloudinary or any http URL, keep it as-is
//                                 if (path.startsWith('http://') ||
//                                     path.startsWith('https://')) {
//                                   return path;
//                                 }
//                                 return path; // Local file path
//                               }

//                               final profilePath = getSafePath(
//                                 vm.profileImageUrl,
//                               );
//                               final idPath = getSafePath(vm.idLicenseUrl);
//                               final refs = vm.referenceLettersUrls.map((f) {
//                                 final path = f.path;
//                                 return (path.startsWith('http://') ||
//                                         path.startsWith('https://'))
//                                     ? path
//                                     : path;
//                               }).toList();

//                               await vm.saveAdditionalStep(
//                                 profileImageUrlOrPath: profilePath.toString(),
//                                 idLicenseUrlOrPath: idPath.toString(),
//                                 referenceDocs: refs,
//                                 agreed: vm.agreedToTerms,
//                                 truthful: vm.confirmTruth,
//                                 workHistoryDescription:
//                                     vm.workHistoryController.text,
//                               );
//                               break;
//                           }

//                           if (vm.currentStep < steps.length - 1) {
//                             vm.goNext();
//                           } else {
//                             await vm.submit();
//                             final saved = await vm.getSavedData();
//                             log('final data: ${saved?.toString()}');
//                             if (mounted) {
//                               vm.signUp(context: context);
//                               //   //                     ScaffoldMessenger.of(context)
//                               //   //     .showSnackBar(const SnackBar(content: Text('Sign-up successful')));
//                               //   // pinController.clear();
//                               //   //
//                               //   showDialog(
//                               //     context: context,
//                               //     builder: (_) => AlertDialog(
//                               //       title: const Text('Success'),
//                               //       content: const Text(
//                               //         'Your account details have been captured.',
//                               //       ),
//                               //       actions: [
//                               //         TextButton(
//                               //           onPressed: () => context.router.replaceAll([
//                               //             const InspectorDashboardRoute(),
//                               //           ]),
//                               //           child: const Text('OK'),
//                               //         ),
//                               //       ],
//                               //     ),
//                               //   );
//                             }
//                           }
//                         },
//                   text: vm.currentStep < 3 ? 'Next' : 'Submit',
//                 ),
//               ),
//             ],
//           ),
//         ),
//         form: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade200,
//                     blurRadius: 12,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: Form(
//                 key: steps[vm.currentStep].formKey,
//                 autovalidateMode: vm.autoValidate
//                     ? AutovalidateMode.always
//                     : AutovalidateMode.disabled,
//                 child: SingleChildScrollView(
//                   child: steps[vm.currentStep].content,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _StepMeta {
//   final String title;
//   final Widget content;
//   final GlobalKey<FormState> formKey;
//   _StepMeta(this.title, this.content, this.formKey);
// }

