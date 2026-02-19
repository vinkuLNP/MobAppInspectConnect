import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/app_widgets/common_address_auto_complete_field.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/auth_form_switch_row.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/common_auth_bar.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/utils/otp_enum.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/utils/text_editor_controller.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ResetPasswordView extends StatelessWidget {
  final bool showBackButton;
  const ResetPasswordView({super.key, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        final vm = ctx.read<ClientViewModelProvider>();
        log('----vm-->${cltFullNameCtrl.text}');
        log('---vm--->${cltEmailCtrlSignUp.text}');
        log('---v--->${cltPhoneCtrl.text}');
        log('------>${cltCountryCodeCtrl.text}');

        return CommonAuthBar(
          showBackButton: showBackButton,
          title: vm.otpPurpose == OtpPurpose.forgotPassword
              ? resetPassword
              : createAccount,
          subtitle: vm.otpPurpose == OtpPurpose.forgotPassword
              ? enterYourNewPassword
              : enterPasswordAndAddressDetailToContinue,
          image: finalImage,
          rc: rc,
          form: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer<ClientViewModelProvider>(
                  builder: (_, vm, _) => AppPasswordField(
                    label: newPasswordLabel,
                    controller: cltPasswordCtrlSignUp,
                    obscure: vm.obscurePassword,
                    onToggle: vm.toggleObscurePassword,
                    validator: vm.validatePassword,
                    onChanged: (_) {
                      if (vm.autoValidate) formKey.currentState?.validate();
                    },
                  ),
                ),

                const SizedBox(height: 14),

                Consumer<ClientViewModelProvider>(
                  builder: (_, vm, _) => AppPasswordField(
                    label: confirmNewPasswordLabel,
                    controller: cltConfirmPasswordCtrl,
                    obscure: vm.obscureConfirm,
                    onToggle: vm.toggleObscureConfirm,
                    validator: vm.validateConfirmPassword,
                    onChanged: (_) {
                      if (vm.autoValidate) formKey.currentState?.validate();
                    },
                  ),
                ),

                const SizedBox(height: 14),

                AddressAutocompleteField(
                  label: addressLabel,
                  controller: cltAddressCtrl,
                  validator: vm.validateMailingAddress,
                  googleApiKey: dotenv.env['GOOGLE_API_KEY']!,
                  onAddressSelected: (prediction) {
                    log("Selected: ${prediction.fullText}");
                  },
                  onFullAddressFetched: (data) {
                    vm.setAddressData(data);
                  },
                ),

                const SizedBox(height: 28),

                Consumer<ClientViewModelProvider>(
                  builder: (_, vm, _) => AppButton(
                    text: vm.isResetting
                        ? resetting
                        : (vm.otpPurpose == OtpPurpose.forgotPassword
                              ? resetPassword
                              : submitTxt),
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
                      await vm.clientSignUp(formKey: formKey, context: context);
                    },
                  ),
                ),

                AuthFormSwitchRow(
                  question: alreadyHaveAccount,
                  actionText: signInTitle,
                  onTap: () {
                    context.router.replaceAll([
                      ClientSignInRoute(showBackButton: false),
                    ]);
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
