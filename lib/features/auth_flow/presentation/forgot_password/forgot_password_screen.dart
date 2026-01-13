import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/auth_form_switch_row.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/common_auth_bar.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/utils/text_editor_controller.dart';
import 'package:provider/provider.dart';

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
          title: forgotPassword,
          showBackButton: showBackButton,
          subtitle: forgotPasswordSubtitle,
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
                  label: emailLabel,
                  hint: emailHint,
                  controller: cltResetEmailCtrl,
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
                      ? sendingText
                      : sendVerificationCode,
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
                  question: rememberPasswordText,
                  actionText: signInTitle,
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
