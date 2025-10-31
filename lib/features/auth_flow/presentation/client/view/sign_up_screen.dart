import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/auth_form_switch_row.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/common_auth_bar.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

// @RoutePage()
// class ClientSignUpView extends StatefulWidget {
//   const ClientSignUpView({super.key});

//   @override
//   State<ClientSignUpView> createState() => _ClientSignUpViewState();
// }

// class _ClientSignUpViewState extends State<ClientSignUpView> {
//   final formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<ClientViewModelProvider>();

//     return BaseResponsiveWidget(
//       initializeConfig: false,
//       buildWidget: (ctx, rc, app) => Scaffold(
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             child: Form(
//               key: formKey,
//               autovalidateMode: vm.autoValidate
//                   ? AutovalidateMode.always
//                   : AutovalidateMode.disabled,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   appCommonLogoBar(height: rc.screenHeight * 0.2),
//                   Align(
//                     alignment: Alignment.center,
//                     child: textWidget(
//                       text: 'Sign Up',
//                       fontSize: 30,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.center,
//                     child: textWidget(
//                       text: 'Please fill in the details below to sign up',
//                       fontSize: 16,

//                       colour: Colors.black54,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   Consumer<ClientViewModelProvider>(
//                     builder: (_, vm, _) => AppInputField(
//                       label: 'Full Name',
//                       hint: 'Full Name',
//                       controller: vm.fullNameCtrl,
//                       validator: vm.validateRequired,
//                       onChanged: (_) {
//                         if (vm.autoValidate) formKey.currentState?.validate();
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   Text(
//                     'Phone Number',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 18,
//                     ),
//                   ),
//                   const SizedBox(height: 8),

// Consumer<ClientViewModelProvider>(
//   builder: (_, vm, _) => FormField<String>(
//     validator: (_) {
//       final p = vm.phoneRaw ?? '';
//       if (!vm.autoValidate) return null;
//       if ((vm.phoneE164 ?? '').isEmpty) {
//         return 'Phone is required';
//       }
//       if (p.length < 10) return 'Enter a valid phone';
//       return null;
//     },
//     builder: (state) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           IntlPhoneField(
//             controller: vm.phoneCtrl,
//             initialCountryCode: 'IN',
//             decoration: InputDecoration(
//               hintText: 'Phone Number',
//               counterText: '',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(
//                   color: Colors.grey,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(
//                   color: AppColors.themeColor,
//                   width: 2,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//             ),
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//               LengthLimitingTextInputFormatter(10),
//             ],
//             flagsButtonPadding: const EdgeInsets.only(
//               left: 8,
//             ),
//             dropdownIconPosition: IconPosition.trailing,
//             disableLengthCheck: true,

//             validator: (_) => null,

//             onChanged: (phone) {
//               vm.setPhoneParts(
//                 iso: phone.countryISOCode,
//                 dial: phone.countryCode,
//                 number: phone.number,
//                 e164: phone.completeNumber,
//               );
//               if (vm.autoValidate) {
//                 state.validate();
//               }
//             },
//             onCountryChanged: (country) {
//               vm.setPhoneParts(
//                 iso: country.code,
//                 dial: '+${country.dialCode}',
//                 number: vm.phoneRaw ?? '',
//                 e164: (vm.phoneRaw?.isNotEmpty ?? false)
//                     ? '+${country.dialCode}${vm.phoneRaw}'
//                     : '',
//               );
//               if (vm.autoValidate) state.validate();
//             },
//           ),
//           if (state.hasError) ...[
//             const SizedBox(height: 6),
//             Text(
//               state.errorText!,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.error,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ],
//       );
//     },
//   ),
// ),

//                   const SizedBox(height: 10),

//                   Consumer<ClientViewModelProvider>(
//                     builder: (_, vm, _) => AppInputField(
//                       label: 'Email',
//                       hint: 'Email ',

//                       controller: vm.emailCtrlSignUp,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: vm.validateEmail,
//                       onChanged: (_) {
//                         if (vm.autoValidate) formKey.currentState?.validate();
//                       },
//                     ),
//                   ),

//                   SizedBox(height: (rc.screenHeight * 0.08).clamp(40.0, 80.0)),

//                   SizedBox(
//                     height: 54,
//                     child: AppButton(
//                       buttonBackgroundColor: AppColors.themeColor,

//                       onTap: () async {
//                         final isValid =
//                             formKey.currentState?.validate() ?? false;
//                         if (!isValid) {
//                           vm.enableAutoValidate();
//                           return;
//                         }
//                         await vm.submitSignUp(
//                           formKey: formKey,
//                           context: context,
//                         );
//                       },
//                       text: 'Sign Up',
//                     ),
//                   ),
//                   // ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       textWidget(text: "Already have an account?"),
//                       GestureDetector(
//                         onTap: () {

//                           vm.emailCtrlSignUp.clear();
//                            vm.phoneCtrl.clear();
//                            vm.fullNameCtrl.clear();

//                           context.pushRoute(const ClientSignInRoute());
//                         },
//                         child: textWidget(
//                           text: 'Sign In',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18,
//                           colour: AppColors.themeColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

@RoutePage()
class ClientSignUpView extends StatelessWidget {
  final bool showBackButton;
  const ClientSignUpView({super.key, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        final vm = ctx.watch<ClientViewModelProvider>();

        return CommonAuthBar(
          title: 'Sign Up',
          showBackButton: showBackButton,
          subtitle: 'Create Your Account!',
          image: finalImage,
          rc: rc,
          form: Form(
            key: formKey,
            autovalidateMode: vm.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppInputField(
                  label: 'Full Name',
                  hint: 'Full Name',
                  controller: vm.fullNameCtrl,
                  validator: vm.validateRequired,
                  onChanged: (_) {
                    if (vm.autoValidate) formKey.currentState?.validate();
                  },
                ),
                const SizedBox(height: 14),
                textWidget(text: 'Phone Number', fontWeight: FontWeight.w400),
                const SizedBox(height: 8),

                Consumer<ClientViewModelProvider>(
                  builder: (_, vm, _) => FormField<String>(
                    validator: (_) {
                      final p = vm.phoneRaw ?? '';
                      if (!vm.autoValidate) return null;
                      if ((vm.phoneE164 ?? '').isEmpty) {
                        return 'Phone is required';
                      }
                      if (p.length < 10) return 'Enter a valid phone';
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntlPhoneField(
                            controller: vm.phoneCtrl,

                            style: appTextStyle(fontSize: 12),
                            initialCountryCode: 'IN',
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              counterText: '',
                              errorStyle: appTextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                              hintStyle: appTextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.authThemeColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            showDropdownIcon: true,

                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            flagsButtonPadding: const EdgeInsets.only(left: 8),
                            dropdownIconPosition: IconPosition.trailing,
                            disableLengthCheck: true,

                            validator: (_) => null,

                            onChanged: (phone) {
                              vm.setPhoneParts(
                                iso: phone.countryISOCode,
                                dial: phone.countryCode,
                                number: phone.number,
                                e164: phone.completeNumber,
                              );
                              if (vm.autoValidate) {
                                state.validate();
                              }
                            },
                            onCountryChanged: (country) {
                              vm.setPhoneParts(
                                iso: country.code,
                                dial: '+${country.dialCode}',
                                number: vm.phoneRaw ?? '',
                                e164: (vm.phoneRaw?.isNotEmpty ?? false)
                                    ? '+${country.dialCode}${vm.phoneRaw}'
                                    : '',
                              );
                              if (vm.autoValidate) state.validate();
                            },
                          ),
                          if (state.hasError) ...[
                            const SizedBox(height: 6),
                            textWidget(
                              text: "    ${state.errorText!}",
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),
                AppInputField(
                  label: 'Email',
                  hint: 'Email',
                  controller: vm.emailCtrlSignUp,
                  keyboardType: TextInputType.emailAddress,
                  validator: vm.validateEmail,
                  onChanged: (_) {
                    if (vm.autoValidate) formKey.currentState?.validate();
                  },
                ),
                const SizedBox(height: 28),
                AppButton(
                  buttonBackgroundColor: const Color(0xFF002A86),
                  borderColor: const Color(0xFF002A86),
                  onTap: () async {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) {
                      vm.enableAutoValidate();
                      return;
                    }
                    await vm.submitSignUp(formKey: formKey, context: context);
                  },
                  text: 'Sign Up',
                ),

                AuthFormSwitchRow(
                  question: "Already have an account?",
                  actionText: "Sign In",
                  onTap: () {
                    vm.emailCtrlSignUp.clear();
                    vm.phoneCtrl.clear();
                    vm.fullNameCtrl.clear();

                    final stackString = context.router.stack.toString();
                    log('stack raw: $stackString');

                    final names = RegExp(r'\"([^\"]+)\"')
                        .allMatches(stackString)
                        .map((m) => m.group(1))
                        .whereType<String>()
                        .toList();

                    log('extracted route names: $names');

                    final hasSignIn = names.contains(ClientSignInRoute.name);
                    if (hasSignIn) {
                      context.router.replaceAll([
                        ClientSignInRoute(showBackButton: false),
                      ]);
                    } else {
                      context.pushRoute(
                        ClientSignInRoute(showBackButton: true),
                      );
                    }
                  },
                  actionColor: AppColors.authThemeLightColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
