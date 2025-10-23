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
class ClientSignInView extends StatelessWidget {
  const ClientSignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
   
        return BaseResponsiveWidget(
          initializeConfig: false,
          buildWidget: (ctx, rc, app) {
            final provider = ctx.watch<ClientViewModelProvider>();

            return Scaffold(
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        appCommonLogoBar(height: rc.screenHeight * 0.2),
                        Align(
                          alignment: Alignment.center,
                          child: textWidget(
                            text: 'Sign In',
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.center,
                          child: textWidget(
                            text: 'Hi, Welcome back',
                            fontSize: 20,

                            colour: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 40),

                        Consumer<ClientViewModelProvider>(
                          builder: (_, vm, _) => AppInputField(
                            label: 'Email',
                            controller: provider.emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            hint: 'example@gmail.com',
                            onChanged: (_) {
                              if (provider.autoValidate) {
                                formKey.currentState?.validate();
                              }
                            },
                            validator: provider.validateEmail,
                          ),
                        ),

                        const SizedBox(height: 28),

                        Consumer<ClientViewModelProvider>(
                          builder: (_, vm, _) => AppPasswordField(
                            label: 'Password',
                            controller: provider.passwordCtrl,
                            obscure: provider.obscure,
                            onToggle: provider.toggleObscure,
                            validator: provider.validatePassword,
                            onChanged: (_) {
                              if (provider.autoValidate) {
                                formKey.currentState?.validate();
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.pushRoute(const ForgotpPasswordRoute());
                            },
                            child: textWidget(
                              text: 'Forget Password?',
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              colour: AppColors.themeColor,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // AppButton(
                        //   text: 'Sign In',
                        //   onTap: () => provider.signIn(formKey: formKey,context: context),
                        // ),
                        Consumer<ClientViewModelProvider>(
                          builder: (_, vm, __) => AppButton(
                            text: vm.isSigningIn ? 'Signing In...' : 'Sign In',
                            onTap: () {
                              print('tapped');
                              final isValid =
                                  formKey.currentState?.validate() ?? false;
                              if (!isValid) {
                                vm.enableAutoValidate();
                                return;
                              }
                              vm.isSigningIn
                                  ? null
                                  :  vm.signIn(
                                      formKey: formKey,
                                      context: context,
                                    );
                            },
                            isLoading: vm.isSigningIn, // ⏳ shows spinner
                            isDisabled:
                                vm.isSigningIn, // disables tap + fades opacity
                          ),
                        ),

                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textWidget(text: "Don’t have an account? "),
                            GestureDetector(
                              onTap: () {
                                provider.passwordCtrl.clear();
                                provider.emailCtrl.clear();
                                context.pushRoute(const ClientSignUpRoute());
                              },
                              child: textWidget(
                                text: 'Sign Up',
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                colour: AppColors.themeColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
 
  }
}
