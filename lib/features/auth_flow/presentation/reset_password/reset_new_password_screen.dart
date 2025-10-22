import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/basecomponents/base_responsive_widget.dart';
import 'package:clean_architecture/core/utils/auto_router_setup/auto_router.dart';
import 'package:clean_architecture/core/utils/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_button.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_logo_bar.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_text_widget.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:clean_architecture/features/auth_flow/utils/otp_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


@RoutePage()
class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
//     return const Placeholder();
//   }
// }

// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// @RoutePage()
// class ClientResetPasswordView extends StatefulWidget {
//   const ClientResetPasswordView({super.key});

//   @override
//   State<ClientResetPasswordView> createState() => _ClientResetPasswordViewState();
// }

// class _ClientResetPasswordViewState extends State<ClientResetPasswordView> {
//   final formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     // ensure cooldown is running if user deep-linked here
//     final vm = context.read<ClientViewModelProvider>();
//     vm.verifyInit();
//   }

//   @override
//   Widget build(BuildContext context) {
    return BaseResponsiveWidget(
      initializeConfig: false,
      buildWidget: (ctx, rc, app) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: formKey,
              child: Consumer<ClientViewModelProvider>(
                builder: (_, vm, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                       const SizedBox(height: 24),
                    appCommonLogoBar(height: rc.screenHeight * 0.2),
                    Align(
                      alignment: Alignment.center,
                      child: textWidget(
                        text:  vm.otpPurpose == OtpPurpose.forgotPassword ?  'Reset Password' : 'Set Your Password',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
               

                  SizedBox(height: (rc.screenHeight * 0.05).clamp(24.0, 40.0)),

                    AppPasswordField(
                      label: 'New Password',
                      controller: vm.passwordCtrlSignUp,
                      obscure: vm.obscurePassword,
                      onToggle: vm.toggleObscurePassword,
                      validator: vm.validatePassword,
                    ),
                    const SizedBox(height: 20),

                    AppPasswordField(
                      label: 'Confirm New Password',
                      controller: vm.confirmPasswordCtrl,
                      obscure: vm.obscureConfirm,
                      onToggle: vm.toggleObscureConfirm,
                      validator: vm.validateConfirmPassword,
                    ),



                     SizedBox(height: (rc.screenHeight* 0.08).clamp(40.0, 80.0)),

                    SizedBox(
                      height: 54,
                      child: AppButton(
                        buttonBackgroundColor: AppColors.themeColor,
                        onTap: (){
                             vm.isResetting
                            ? null
                            :  vm.resetPassword(formKey: formKey, context: context);
                       
                        }
                        ,
                      text: vm.isResetting ? 'Resetting...' :   vm.otpPurpose == OtpPurpose.forgotPassword ?  'Reset Password' : 'Set Your Password',
                      ),
                    ),

                    const SizedBox(height: 20),
                        Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(text: "Already have an account?"),
                      GestureDetector(
                        onTap: () {
                          context.pushRoute(const ClientSignInRoute());
                        },
                        child: textWidget(
                          text: 'Sign In',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          colour: AppColors.themeColor,
                        ),
                      ),
                    ],
                  ),
               
                  
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
