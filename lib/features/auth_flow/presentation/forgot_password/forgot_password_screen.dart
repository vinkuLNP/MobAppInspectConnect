import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/auth_form_switch_row.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/common_auth_bar.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// @RoutePage()
// class ForgotpPasswordView extends StatelessWidget {
//   const ForgotpPasswordView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final formKey = GlobalKey<FormState>();
//     return BaseResponsiveWidget(
//       initializeConfig: false,
//       buildWidget: (ctx, rc, app) {

//         return Scaffold(
//           body: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Form(
//               key: formKey,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20.0,
//                   vertical: 20.0,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 24),
//                     appCommonLogoBar(height: rc.screenHeight * 0.2),
//                     Align(
//                       alignment: Alignment.center,
//                       child: textWidget(
//                         text: 'Forgot Password?',
//                         fontSize: 30,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Align(
//                       alignment: Alignment.center,
//                       child: textWidget(
//                         text: 'Enter your email to receive a reset code',
//                         fontSize: 16,
//                         colour: Colors.black54,
//                       ),
//                     ),
//                     SizedBox(
//                       height: (rc.screenHeight * 0.05).clamp(24.0, 40.0),
//                     ),

//                     // Email
//                     Consumer<ClientViewModelProvider>(
//                       builder: (_, provider, _) => AppInputField(
//                         label: 'Email ',
//                         hint: 'Email',
//                         controller: provider.resetEmailCtrl,
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (_) => provider.validateEmailOrIntlPhone(),
//                          onChanged: (_) {
//                         if (provider.autoValidate) formKey.currentState?.validate();
//                       },
//                       ),
//                     ),
//                     SizedBox(
//                       height: (rc.screenHeight * 0.08).clamp(40.0, 80.0),
//                     ),
//                     Consumer<ClientViewModelProvider>(
//                       builder: (_, provider, _) => AppButton(
//                         buttonBackgroundColor: AppColors.themeColor,
//                         onTap: () async {
//                           final isValid =
//                               formKey.currentState?.validate() ?? false;
//                           if (!isValid) {
//                             provider.enableAutoValidate();
//                             return;
//                           }
//                           provider.isSendingReset
//                               ? null
//                               : provider.requestPasswordReset(
//                                   formKey: formKey,
//                                   context: context,
//                                 );
//                         },
//                         text: provider.isSendingReset
//                             ? 'Sending...'
//                             : 'Send Verification Code',
//                       ),
//                     ),

//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         textWidget(text: "Already have an account?"),
//                         GestureDetector(
//                           onTap: () {
//                             context.router.pop();
//                           },
//                           child: textWidget(
//                             text: 'Sign In',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 18,
//                             colour: AppColors.themeColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

@RoutePage()
class ForgotpPasswordView extends StatelessWidget {
  final bool showBackButton;
  const ForgotpPasswordView({super.key, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        final provider = ctx.watch<ClientViewModelProvider>();

        return CommonAuthBar(
          title: 'Forgot Password?',
          showBackButton: showBackButton,
          subtitle: 'Enter your email \nto receive a reset code',
          image: finalImage,
          rc: rc,
          form: Form(
            key: formKey,
            autovalidateMode: provider.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppInputField(
                  label: 'Email',
                  hint: 'example@gmail.com',
                  controller: provider.resetEmailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (_) => provider.validateEmailOrIntlPhone(),
                  onChanged: (_) {
                    if (provider.autoValidate) formKey.currentState?.validate();
                  },
                ),

                const SizedBox(height: 28),

                AppButton(
                  buttonBackgroundColor: AppColors.authThemeColor,
                  borderColor: AppColors.authThemeColor,
                  text: provider.isSendingReset
                      ? 'Sending...'
                      : 'Send Verification Code',
                  onTap: () async {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) {
                      provider.enableAutoValidate();
                      return;
                    }
                    if (!provider.isSendingReset) {
                      await provider.requestPasswordReset(
                        formKey: formKey,
                        context: context,
                      );
                    }
                  },
                ),

                AuthFormSwitchRow(
                  question: "Remember your password? ",
                  actionText: "Sign In",
                  onTap: () {
                    context.router.pop();
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
