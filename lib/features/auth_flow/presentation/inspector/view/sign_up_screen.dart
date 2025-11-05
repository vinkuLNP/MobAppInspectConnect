// import 'package:auto_route/auto_route.dart';
// import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
// import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
// import 'package:inspect_connect/core/utils/constants/app_colors.dart';
// import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
// import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
// import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';
// import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
// import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
// import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/common_auth_bar.dart';
// import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:provider/provider.dart';

// @RoutePage()
// class InspectorSignUpView extends StatefulWidget {
//   const InspectorSignUpView({super.key});

//   @override
//   State<InspectorSignUpView> createState() => _InspectorSignUpViewState();
// }

// class _InspectorSignUpViewState extends State<InspectorSignUpView> {
//   final _personalKey = GlobalKey<FormState>();
//   final _professionalKey = GlobalKey<FormState>();
//   final _serviceAreaKey = GlobalKey<FormState>();
//   final _additionalKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<InspectorViewModelProvider>();
//     final steps = [
//       _StepMeta(
//         'Personal Details',
//         buildPersonal(vm, _personalKey),
//         _personalKey,
//       ),
//       _StepMeta(
//         'Professional Details',
//         buildProfessional(vm),
//         _professionalKey,
//       ),
//       _StepMeta('Service Area', buildServiceArea(vm), _serviceAreaKey),
//       _StepMeta('Additional Details', buildAdditional(vm), _additionalKey),
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
//                   // buttonBackgroundColor: AppColors.authThemeColor,
//                   onTap: () async {
//                     final key = steps[vm.currentStep].formKey;
//                     final isValid = key.currentState?.validate() ?? false;
//                     if (!isValid) {
//                       vm.enableAutoValidate();
//                       return;
//                     }
//                     // if (key.currentState?.validate() ?? false) {
//                     key.currentState?.save();
//                     if (vm.currentStep < steps.length - 1) {
//                       vm.goNext();
//                     } else {
//                       // Submit
//                       await vm.submit();
//                       if (mounted) {
//                         showDialog(
//                           context: context,
//                           builder: (_) => AlertDialog(
//                             title: const Text('Success'),
//                             content: const Text(
//                               'Your account details have been captured.',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.of(context).pop(),
//                                 child: const Text('OK'),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//                     }
//                     // }
//                   },
//                   text: vm.currentStep < 3 ? 'Next' : 'Submit',
//                 ),
//               ),
//             ],
//           ),
//         ),

//         form: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 14),
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
//               margin: EdgeInsets.zero,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 10,
//                 ),
//                 child: Form(
//                   key: steps[vm.currentStep].formKey,
//                   child: SingleChildScrollView(
//                     child: steps[vm.currentStep].content,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildPersonal(
//     InspectorViewModelProvider p,
//     GlobalKey<FormState> formKey,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle('Personal Details'),
//         const SizedBox(height: 8),

//         // Consumer<InspectorViewModelProvider>(
//         //   builder: (_, vm, _) => AppInputField(
//         //     label: 'Full Name',
//         //     controller: vm.fullNameCtrl,
//         //     validator: vm.validateRequired,
//         //   ),
//         // ),
//         AppInputField(
//           label: 'Full Name',
//           hint: 'Full Name',
//           controller: p.fullNameCtrl,
//           validator: p.validateRequired,
//           onChanged: (_) {
//             // if (p.autoValidate)
//             formKey.currentState?.validate();
//           },
//         ),

//         const SizedBox(height: 14),
//         textWidget(text: 'Phone Number', fontWeight: FontWeight.w400),
//         const SizedBox(height: 8),

//         Consumer<InspectorViewModelProvider>(
//           builder: (_, vm, _) => FormField<String>(
//             validator: (_) {
//               final p = vm.phoneRaw ?? '';
//               // if (!vm.autoValidate) return null;
//               if ((vm.phoneE164 ?? '').isEmpty) {
//                 return 'Phone is required';
//               }
//               if (p.length < 10) return 'Enter a valid phone';
//               return null;
//             },
//             builder: (state) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   IntlPhoneField(
//                     controller: vm.phoneCtrl,

//                     style: appTextStyle(fontSize: 12),
//                     initialCountryCode: 'IN',
//                     decoration: InputDecoration(
//                       hintText: 'Phone Number',
//                       counterText: '',
                    //   errorStyle: appTextStyle(fontSize: 12, color: Colors.red),
                    //   hintStyle: appTextStyle(fontSize: 12, color: Colors.grey),

                    //   border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),

                    //   enabledBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //     borderSide: const BorderSide(color: Colors.grey),
                    //   ),
                    //   focusedBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //     borderSide: const BorderSide(
                    //       color: AppColors.authThemeColor,
                    //       width: 2,
                    //     ),
                    //   ),
                    //   contentPadding: const EdgeInsets.symmetric(
                    //     horizontal: 16,
                    //     vertical: 14,
                    //   ),
                    // ),
                    // showDropdownIcon: true,

                    // inputFormatters: [
                    //   FilteringTextInputFormatter.digitsOnly,
                    //   LengthLimitingTextInputFormatter(10),
                    // ],
                    // flagsButtonPadding: const EdgeInsets.only(left: 8),
                    // dropdownIconPosition: IconPosition.trailing,
                    // disableLengthCheck: true,

                    // validator: (_) => null,

                    // onChanged: (phone) {
                    //   vm.setPhoneParts(
                    //     iso: phone.countryISOCode,
                    //     dial: phone.countryCode,
                    //     number: phone.number,
                    //     e164: phone.completeNumber,
                    //   );
                    //   // if (vm.autoValidate) {
                    //   //   state.validate();
                    //   // }
                    // },
//                     onCountryChanged: (country) {
//                       vm.setPhoneParts(
//                         iso: country.code,
//                         dial: '+${country.dialCode}',
//                         number: vm.phoneRaw ?? '',
//                         e164: (vm.phoneRaw?.isNotEmpty ?? false)
//                             ? '+${country.dialCode}${vm.phoneRaw}'
//                             : '',
//                       );
//                       // if (vm.autoValidate) state.validate();
//                     },
//                   ),
//                   if (state.hasError) ...[
//                     const SizedBox(height: 6),
//                     textWidget(
//                       text: "    ${state.errorText!}",
//                       fontSize: 12,
//                       color: Colors.red,
//                     ),
//                   ],
//                 ],
//               );
//             },
//           ),
//         ),

//         const SizedBox(height: 10),

//         Consumer<InspectorViewModelProvider>(
//           builder: (_, vm, _) => AppInputField(
//             label: 'Email',
//             hint: 'Email',

//             controller: vm.emailCtrlSignUp,
//             keyboardType: TextInputType.emailAddress,
//             validator: vm.validateEmail,
//             onChanged: (_) {
//               // if (vm.autoValidate) formKey.currentState?.validate();
//             },
//           ),
//         ),
//         const SizedBox(height: 10),
//         Consumer<InspectorViewModelProvider>(
//           builder: (_, vm, _) => AppPasswordField(
//             label: 'Password',
//             controller: vm.passwordCtrlSignUp,
//             obscure: vm.obscurePassword,
//             onToggle: vm.toggleObscurePassword,
//             validator: vm.validatePassword,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildProfessional(InspectorViewModelProvider p) {
//     final theme = Theme.of(context);

//     String _fmt(DateTime d) =>
//         '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle('Professional Details'),
//         const SizedBox(height: 12),

//         DropdownButtonFormField<String>(
//           value: p.certificationType,
//           items: p.certAuthorityByType.keys
//               .map((k) => DropdownMenuItem(value: k, child: Text(k)))
//               .toList(),
//           onChanged: p.setCertificationType,
//           validator: p.validateCertType,
//           decoration: const InputDecoration(
//             labelText: 'Certification Type *',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 12),

//         TextFormField(
//           enabled: false,
//           initialValue: p.certifyingBody ?? '',
//           decoration: InputDecoration(
//             labelText: 'Certifying Rigmaroles (Auto-filled)',
//             hintText: 'Please select a certification type first',
//             border: const OutlineInputBorder(),
//             disabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//                 color: theme.colorScheme.outlineVariant,
//                 width: 1,
//               ),
//               borderRadius: BorderRadius.circular(4),
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),

//         FormField<String>(
//           validator: p.validateExpiry,
//           builder: (state) => Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 readOnly: true,
//                 controller: TextEditingController(
//                   text: p.expirationDate == null ? '' : _fmt(p.expirationDate!),
//                 ),
//                 decoration: InputDecoration(
//                   labelText: 'Expiration Date',
//                   suffixIcon: const Icon(Icons.calendar_today_rounded),
//                   border: const OutlineInputBorder(),
//                 ),
//                 onTap: () async {
//                   final now = DateTime.now();
//                   final picked = await showDatePicker(
//                     context: context,
//                     initialDate: p.expirationDate ?? now,
//                     firstDate: now,
//                     lastDate: DateTime(now.year + 10),
//                   );
//                   if (picked != null) {
//                     p.setExpirationDate(
//                       DateTime(picked.year, picked.month, picked.day),
//                     );
//                     state.didChange('set');
//                   }
//                 },
//               ),
//               if (state.hasError) ...[
//                 const SizedBox(height: 6),
//                 Text(
//                   state.errorText!,
//                   style: TextStyle(
//                     color: theme.colorScheme.error,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),

        // FormField<bool>(
        //   // validator: (_) => p.uploadedCount == 0
        //   //     ? 'Please upload at least one document'
        //   //     : null,
        //   builder: (state) => Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       OutlinedButton.icon(
        //         icon: const Icon(Icons.upload_rounded),
        //         label: const Text('Upload Certification Documents'),
        //         onPressed: () async {
        //           await p.pickCertificationFiles();
        //           state.didChange(true);
        //         },
        //         style: OutlinedButton.styleFrom(
        //           padding: const EdgeInsets.symmetric(
        //             horizontal: 16,
        //             vertical: 14,
        //           ),
        //         ),
        //       ),
        //       const SizedBox(height: 8),
        //       Text(
        //         '${p.uploadedCount} file(s) uploaded',
        //         style: theme.textTheme.bodyMedium?.copyWith(
        //           color: theme.colorScheme.onSurfaceVariant,
        //         ),
        //       ),
        //       if (state.hasError) ...[
        //         const SizedBox(height: 6),
        //         Text(
        //           state.errorText!,
        //           style: TextStyle(
        //             color: theme.colorScheme.error,
        //             fontSize: 12,
        //           ),
        //         ),
//               ],
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildServiceArea(InspectorViewModelProvider p) {
//     final controller = TextEditingController();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle('Service Area'),
//         const SizedBox(height: 8),
//         TextFormField(
//           initialValue: p.serviceArea.city,
//           decoration: const InputDecoration(labelText: 'Base City'),
//           validator: (v) =>
//               (v == null || v.trim().isEmpty) ? 'City is required' : null,
//           onSaved: (v) => p.setCity(v ?? ''),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: controller,
//                 decoration: const InputDecoration(
//                   labelText: 'Add Area (e.g., suburb or zip)',
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             FilledButton(
//               onPressed: () {
//                 p.addServiceArea(controller.text);
//                 controller.clear();
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Consumer<InspectorViewModelProvider>(
//           builder: (_, p, __) => Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: p.serviceArea.serviceAreas
//                 .map(
//                   (s) => Chip(
//                     label: Text(s),
//                     onDeleted: () => p.removeServiceArea(s),
//                   ),
//                 )
//                 .toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildAdditional(InspectorViewModelProvider p) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle('Additional Details'),
//         const SizedBox(height: 8),
//         SwitchListTile(
//           contentPadding: EdgeInsets.zero,
//           title: const Text('I accept the Terms & Conditions'),
//           value: p.additional.termsAccepted,
//           onChanged: p.setTermsAccepted,
//         ),
//         const SizedBox(height: 12),
//         TextFormField(
//           maxLines: 4,
//           initialValue: p.additional.notes,
//           decoration: const InputDecoration(
//             labelText: 'Notes (optional)',
//             alignLabelWithHint: true,
//           ),
//           onSaved: (v) => p.additional.notes = v?.trim() ?? '',
//         ),
//         const SizedBox(height: 12),
//         if (!p.additional.termsAccepted)
//           const Text(
//             'Please accept the Terms & Conditions to continue.',
//             style: TextStyle(color: Colors.red),
//           ),
//       ],
//     );
//   }
// }

// class _StepMeta {
//   final String title;
//   final Widget content;
//   final GlobalKey<FormState> formKey;
//   _StepMeta(this.title, this.content, this.formKey);
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../inspector_view_model.dart';

// class InspectorSignUpView extends StatefulWidget {
//   const InspectorSignUpView({super.key});

//   @override
//   State<InspectorSignUpView> createState() => _InspectorSignUpViewState();
// }

// class _InspectorSignUpViewState extends State<InspectorSignUpView> {
//   final _personalKey = GlobalKey<FormState>();
//   final _professionalKey = GlobalKey<FormState>();
//   final _serviceAreaKey = GlobalKey<FormState>();
//   final _additionalKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<InspectorViewModelProvider>();

//     final steps = [
//       _StepMeta('Personal Details', PersonalDetailsStep(formKey: _personalKey), _personalKey),
//       _StepMeta('Professional Details', ProfessionalDetailsStep(formKey: _professionalKey), _professionalKey),
//       _StepMeta('Service Area', ServiceAreaStep(formKey: _serviceAreaKey), _serviceAreaKey),
//       _StepMeta('Additional Details', AdditionalDetailsStep(formKey: _additionalKey), _additionalKey),
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text('Inspector Sign Up')),
//       body: Column(
//         children: [
//           Expanded(
//             child: Form(
//               key: steps[vm.currentStep].formKey,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: steps[vm.currentStep].content,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: vm.currentStep == 0 ? null : vm.goPrevious,
//                     child: const Text('Previous'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       final key = steps[vm.currentStep].formKey;
//                       final isValid = key.currentState?.validate() ?? false;
//                       if (!isValid) {
//                         vm.enableAutoValidate();
//                         return;
//                       }
//                       key.currentState?.save();
//                       if (vm.currentStep < steps.length - 1) {
//                         vm.goNext();
//                       } else {
//                         await vm.submit();
//                       }
//                     },
//                     child: Text(vm.currentStep < steps.length - 1 ? 'Next' : 'Submit'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
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

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_steps/additional_detail.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_steps/personal_details_step.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_steps/professional_details.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_steps/service_area.dart';
import 'package:provider/provider.dart';

import '../inspector_view_model.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/common_auth_bar.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';

@RoutePage()
class InspectorSignUpView extends StatefulWidget {
  const InspectorSignUpView({super.key});

  @override
  State<InspectorSignUpView> createState() => _InspectorSignUpViewState();
}

class _InspectorSignUpViewState extends State<InspectorSignUpView> {
  final _personalKey = GlobalKey<FormState>();
  final _professionalKey = GlobalKey<FormState>();
  final _serviceAreaKey = GlobalKey<FormState>();
  final _additionalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InspectorViewModelProvider>();
    final steps = [
      _StepMeta(
        'Personal Details',
        PersonalDetailsStep(vm, _personalKey),
        _personalKey,
      ),
      _StepMeta(
        'Professional Details',
        ProfessionalDetailsStep(vm, _professionalKey),
        _professionalKey,
      ),
      _StepMeta(
        'Service Area',
        ServiceAreaStep(vm, _serviceAreaKey),
        _serviceAreaKey,
      ),
      _StepMeta(
        'Additional Details',
        AdditionalDetailsStep(vm, _additionalKey),
        _additionalKey,
      ),
    ];

    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) => InspectorCommonAuthBar(
        title: 'Sign Up',
        showBackButton: false,
        subtitle: 'Create Your Account!',
        image: finalImage,
        rc: rc,
        headerWidget: StepperHeader(
          current: vm.currentStep,
          labels: const [
            'Personal\nDetails',
            'Professional\nDetails',
            'Service\nArea',
            'Additional\nDetails',
          ],
          onTap: (i) {
            if (i <= vm.currentStep) vm.goTo(i);
          },
        ),
        bottomSection: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  isBorder: true,
                  buttonBackgroundColor: Colors.white,
                  borderColor: Colors.grey,
                  textColor: AppColors.authThemeColor,
                  onTap: () => vm.currentStep == 0 ? null : vm.goPrevious(),
                  text: 'Previous',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  onTap: () async {
                    final key = steps[vm.currentStep].formKey;
                    final isValid = key.currentState?.validate() ?? false;
                    if (!isValid) {
                      vm.enableAutoValidate();
                      return;
                    }
                    key.currentState?.save();
                    if (vm.currentStep < steps.length - 1) {
                      vm.goNext();
                    } else {
                      await vm.submit();
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Success'),
                            content: const Text(
                              'Your account details have been captured.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  text: vm.currentStep < 3 ? 'Next' : 'Submit',
                ),
              ),
            ],
          ),
        ),
        form: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: steps[vm.currentStep].formKey,
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

class _StepMeta {
  final String title;
  final Widget content;
  final GlobalKey<FormState> formKey;
  _StepMeta(this.title, this.content, this.formKey);
}
