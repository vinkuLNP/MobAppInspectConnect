import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/basecomponents/base_responsive_widget.dart';
import 'package:clean_architecture/core/utils/auto_router_setup/auto_router.dart';
import 'package:clean_architecture/core/utils/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_button.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_logo_bar.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_text_widget.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ClientSignUpView extends StatelessWidget {
  const ClientSignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final vm = context.watch<ClientViewModelProvider>();

    return BaseResponsiveWidget(
      initializeConfig: false,
      buildWidget: (ctx, rc, app) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  appCommonLogoBar(height: rc.screenHeight * 0.1),
                  Align(
                    alignment: Alignment.center,
                    child: textWidget(
                      text: 'Sign Up',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: textWidget(
                      text: 'Please fill in the details below to sign up',
                      fontSize: 16,

                      colour: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 28),

                  AppInputField(
                    label: 'Full Name',
                    controller: vm.fullNameCtrl,
                    validator: vm.validateRequired,
                  ),
                  const SizedBox(height: 16),

                  AppInputField(
                    label: 'Phone Number',
                    controller: vm.phoneCtrl,
                    keyboardType: TextInputType.phone,
                    validator: vm.validatePhone,
                  ),
                  const SizedBox(height: 16),

                  AppInputField(
                    label: 'Email',
                    controller: vm.emailCtrlSignUp,
                    keyboardType: TextInputType.emailAddress,
                    validator: vm.validateEmail,
                  ),

                  const SizedBox(height: 16),

                  AppInputField(
                    label: 'Mailing Address',
                    controller: vm.addressCtrl,
                    validator: vm.validateRequired,
                  ),

                  const SizedBox(height: 16),
                  AppPasswordField(
                    label: 'Password',
                    controller: vm.passwordCtrlSignUp,
                    obscure: vm.obscurePassword,
                    onToggle: vm.toggleObscurePassword,
                    validator: vm.validatePassword,
                  ),

                  const SizedBox(height: 16),

                  AppPasswordField(
                    label: 'Confirm Password',
                    controller: vm.confirmPasswordCtrl,
                    obscure: vm.obscureConfirm,
                    onToggle: vm.toggleObscureConfirm,
                    validator: vm.validateConfirmPassword,
                  ),

                  const SizedBox(height: 20),

                  CheckboxListTile(
                    value: vm.agreeTnC,
                    onChanged: vm.setAgreeTnC,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('I agree to the Terms and Conditions.'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    value: vm.isTruthful,
                    onChanged: vm.setIsTruthful,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('I confirm all information is truthful.'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 20),

                  // Submit
                  SizedBox(
                    height: 54,
                    child: AppButton(
                      onTap: () => vm.submitSignUp(formKey: formKey),
                      text: 'Sign Up',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(text: "Already have an account?"),
                      GestureDetector(
                        onTap: () {
                          context.pushRoute(const ClientSignUpRoute());
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
    );
  }

}
