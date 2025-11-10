import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/auth_user_provider.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/auth_form_switch_row.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/common_auth_bar.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ClientSignInView extends StatelessWidget {
  final bool showBackButton;
  const ClientSignInView({super.key, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        final provider = ctx.watch<ClientViewModelProvider>();

        return CommonAuthBar(
          title: 'Sign in',
          subtitle: 'Welcome Back',
          showBackButton: showBackButton,
          image: finalImage,
          rc: rc,
          form: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppInputField(
                  label: 'Email',
                  controller: provider.emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'example@gmail.com',
                  validator: provider.validateEmail,
                  onChanged: (_) {
                    if (provider.autoValidate) formKey.currentState?.validate();
                  },
                ),
                const SizedBox(height: 14),
                AppPasswordField(
                  label: 'Password',
                  controller: provider.passwordCtrl,
                  obscure: provider.obscure,
                  onToggle: provider.toggleObscure,
                  validator: provider.validatePassword,
                  onChanged: (_) {
                    if (provider.autoValidate) formKey.currentState?.validate();
                  },
                ),
                // const SizedBox(height: 2 ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.pushRoute(
                        ForgotpPasswordRoute(showBackButton: true),
                      );
                    },
                    child: textWidget(
                      text: 'Forget Password?',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.authThemeLightColor,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                AppButton(
                  text: provider.isSigningIn ? 'Signing In...' : 'Sign In',
                  buttonBackgroundColor: AppColors.authThemeColor,
                  borderColor: AppColors.authThemeColor,
                  isLoading: provider.isSigningIn,
                  isElevation: true,
                  isDisabled: provider.isSigningIn,
                  onTap: () {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) {
                      provider.enableAutoValidate();
                      return;
                    }
                    if (!provider.isSigningIn) {
                      provider.signIn(formKey: formKey, context: context);
                    }
                  },
                ),
                AuthFormSwitchRow(
                  question: "Don’t have an account? ",
                  actionText: "Sign Up",
                  onTap: () {
                    provider.passwordCtrl.clear();
                    provider.emailCtrl.clear();
                    final stackString = context.router.stack.toString();
                    log('stack raw: $stackString');

                    final names = RegExp(r'\"([^\"]+)\"')
                        .allMatches(stackString)
                        .map((m) => m.group(1))
                        .whereType<String>()
                        .toList();

                    log('extracted route names: $names');
                  
                    final authFlow = Provider.of<AuthFlowProvider>(
                      context,
                      listen: false,
                    );

                    if (authFlow.isClient) {
                      final hasSignIn = names.contains(ClientSignUpRoute.name);
                      if (hasSignIn) {
                        context.router.replaceAll([
                          ClientSignUpRoute(showBackButton: false),
                        ]);
                      } else {
                        context.pushRoute(
                          ClientSignUpRoute(showBackButton: true),
                        );
                      }
                    } else if (authFlow.isInspector) {
                      final hasSignIn = names.contains(
                        InspectorSignUpRoute.name,
                      );
                      if (hasSignIn) {
                        context.router.replaceAll([
                          InspectorSignUpRoute(showBackButton: false),
                        ]);
                      } else {
                        context.pushRoute(
                          InspectorSignUpRoute(showBackButton: false),
                        );
                      }
                    } else {
                      final hasSignIn = names.contains(ClientSignUpRoute.name);
                      if (hasSignIn) {
                        context.router.replaceAll([
                          ClientSignUpRoute(showBackButton: false),
                        ]);
                      } else {
                        context.pushRoute(
                          ClientSignUpRoute(showBackButton: true),
                        );
                      }
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
