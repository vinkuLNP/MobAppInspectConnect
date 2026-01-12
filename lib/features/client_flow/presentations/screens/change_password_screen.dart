import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/utils/text_editor_controller.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/client_dashboard_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordViewModel(),
      child: Consumer<ChangePasswordViewModel>(
        builder: (context, vm, _) => Scaffold(
          appBar: const CommonAppBar(
            title: changePassword,
            showLogo: false,
            showBackButton: true,
          ),
          body: Form(
            key: vm.formKey,
            autovalidateMode: vm.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 8),

                AppPasswordField(
                  label: oldPassword,
                  controller: oldPasswordCtrl,
                  obscure: !vm.showOldPassword,
                  onToggle: vm.toggleOldPasswordVisibility,
                  validator: vm.validatePassword,
                ),
                const SizedBox(height: 8),

                AppPasswordField(
                  label: newPasswordLabel,
                  controller: newPasswordCtrl,
                  obscure: !vm.showNewPassword,
                  onToggle: vm.toggleNewPasswordVisibility,
                  validator: vm.validatePassword,
                ),
                const SizedBox(height: 8),

                AppPasswordField(
                  label: confirmPassword,
                  controller: confirmPasswordCtrl,
                  obscure: !vm.showConfirmPassword,
                  onToggle: vm.toggleConfirmPasswordVisibility,
                  validator: vm.validateConfirmPassword,
                ),

                const SizedBox(height: 32),

                AppButton(
                  isLoading: vm.isLoading,

                  text: vm.isLoading ? updating : updatePassword,
                  onTap: vm.isLoading
                      ? null
                      : () async {
                          final isValid =
                              vm.formKey.currentState?.validate() ?? false;
                          if (!isValid) {
                            vm.enableAutoValidate();
                            return;
                          }
                          await vm.changePassword(context);
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
