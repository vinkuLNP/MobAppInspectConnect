import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_logo_bar.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class InspectorSignInView extends StatelessWidget {
  const InspectorSignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BaseResponsiveWidget(
      initializeConfig: false,
      buildWidget: (ctx, rc, app) {
        final provider = ctx.watch<InspectorViewModelProvider>();

        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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

                    AppInputField(
                      label: 'Email',
                      controller: provider.emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      hint: 'example@gmail.com',
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Email is required';
                        final ok = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(v.trim());
                        return ok ? null : 'Enter a valid email';
                      },
                    ),

                    const SizedBox(height: 28),

                    AppPasswordField(
                      label: 'Password',
                      controller: provider.passwordCtrl,
                      obscure: provider.obscure,
                      onToggle: provider.toggleObscure,
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Password is required';
                        if (v.length < 6) return 'At least 6 characters';
                        return null;
                      },
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

                    AppButton(
                      text: 'Sign In',
                      onTap: () => provider.signIn(formKey: formKey),
                    ),

                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textWidget(text: "Don’t have an account? "),
                        GestureDetector(
                          onTap: () {
                            context.pushRoute(const InspectorSignUpRoute());
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
