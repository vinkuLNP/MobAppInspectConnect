import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/auth_form_switch_row.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/common_auth_bar.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/utils/otp_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// @RoutePage()
// class ResetPasswordView extends StatelessWidget {
//   const ResetPasswordView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final formKey = GlobalKey<FormState>();

//     return BaseResponsiveWidget(
//       initializeConfig: false,
//       buildWidget: (ctx, rc, app) => Scaffold(
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             child: Form(
//               key: formKey,
//               child: Consumer<ClientViewModelProvider>(
//                 builder: (_, vm, __) => Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const SizedBox(height: 24),
//                     appCommonLogoBar(height: rc.screenHeight * 0.2),
//                     Align(
//                       alignment: Alignment.center,
//                       child: textWidget(
//                         text: vm.otpPurpose == OtpPurpose.forgotPassword
//                             ? 'Reset Password'
//                             : 'Set Your Password',
//                         fontSize: 28,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),

//                     SizedBox(
//                       height: (rc.screenHeight * 0.05).clamp(24.0, 40.0),
//                     ),

//                     AppPasswordField(
//                       label: 'New Password',
//                       controller: vm.passwordCtrlSignUp,
//                       obscure: vm.obscurePassword,
//                       onToggle: vm.toggleObscurePassword,
//                       validator: vm.validatePassword,
//                       onChanged: (_) {
//                         if (vm.autoValidate) formKey.currentState?.validate();
//                       },
//                     ),
//                     const SizedBox(height: 20),

//                     AppPasswordField(
//                       label: 'Confirm New Password',
//                       controller: vm.confirmPasswordCtrl,
//                       obscure: vm.obscureConfirm,
//                       onToggle: vm.toggleObscureConfirm,
//                       validator: vm.validateConfirmPassword,
//                       onChanged: (_) {
//                         if (vm.autoValidate) formKey.currentState?.validate();
//                       },
//                     ),

//                     SizedBox(
//                       height: (rc.screenHeight * 0.08).clamp(40.0, 80.0),
//                     ),

//                     SizedBox(
//                       height: 54,
//                       child: AppButton(
//                         buttonBackgroundColor: AppColors.themeColor,
//                         onTap: () async{
//                           print('tapped');
//                           final isValid =
//                               formKey.currentState?.validate() ?? false;
//                           print('tapped 2');
                              
//                           if (!isValid) {
//                             vm.enableAutoValidate();
//                           print('tapped 3');

//                             return;
//                           }
//                           print('tapped 4');

//                           // vm.isResetting
//                           //     ? null
//                           //     :
//                             await   
//                             vm.resetPassword(
//                                   formKey: formKey,
//                                   context: context,
//                                 );
//                         },
//                         text: vm.isResetting
//                             ? 'Resetting...'
//                             : vm.otpPurpose == OtpPurpose.forgotPassword
//                             ? 'Reset Password'
//                             : 'Set Your Password',
//                       ),
//                     ),

//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         textWidget(text: "Already have an account?"),
//                         GestureDetector(
//                           onTap: () {
//                             context.pushRoute(const ClientSignInRoute());
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
//         ),
//       ),
//     );
//   }
// }


@RoutePage()
class ResetPasswordView extends StatelessWidget {
    final bool showBackButton;
  const ResetPasswordView({super.key,required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        final vm = ctx.watch<ClientViewModelProvider>();

        return CommonAuthBar(
           showBackButton: showBackButton,
          title: vm.otpPurpose == OtpPurpose.forgotPassword
              ? 'Reset Password'
              : 'Create Password',
          subtitle: vm.otpPurpose == OtpPurpose.forgotPassword
              ? 'Enter your new password'
              : 'Create your password to continue',
          image: finalImage,
          rc: rc,
          form: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppPasswordField(
                  label: 'New Password',
                  controller: vm.passwordCtrlSignUp,
                  obscure: vm.obscurePassword,
                  onToggle: vm.toggleObscurePassword,
                  validator: vm.validatePassword,
                  onChanged: (_) {
                    if (vm.autoValidate) formKey.currentState?.validate();
                  },
                ),
                const SizedBox(height: 14),

                AppPasswordField(
                  label: 'Confirm New Password',
                  controller: vm.confirmPasswordCtrl,
                  obscure: vm.obscureConfirm,
                  onToggle: vm.toggleObscureConfirm,
                  validator: vm.validateConfirmPassword,
                  onChanged: (_) {
                    if (vm.autoValidate) formKey.currentState?.validate();
                  },
                ),
                const SizedBox(height: 28),

                AppButton(
                  text: vm.isResetting
                      ? 'Resetting...'
                      : vm.otpPurpose == OtpPurpose.forgotPassword
                          ? 'Reset Password'
                          : 'Create Password',
                  buttonBackgroundColor: AppColors.authThemeColor,
                  borderColor: AppColors.authThemeColor,
                  isLoading: vm.isResetting,
                  isDisabled: vm.isResetting,
                  onTap: () async {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) {
                      vm.enableAutoValidate();
                      return;
                    }

                    await vm.resetPassword(formKey: formKey, context: context);
                  },
                ),

                AuthFormSwitchRow(
                  question: "Already have an account? ",
                  actionText: "Sign In",
                  onTap: () {
                    context.router.replaceAll([ ClientSignInRoute(showBackButton: false)]);
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
