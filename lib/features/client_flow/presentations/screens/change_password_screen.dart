import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
            title: 'Change Password',
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

                // 🔹 Old Password
                _fieldHeader("Old Password"),
                TextFormField(
                  controller: vm.oldPasswordCtrl,
                  obscureText: !vm.showOldPassword,
                  onChanged: (_) {
                    if (vm.autoValidate) vm.formKey.currentState?.validate();
                  },
                  decoration: _inputDecoration(
                    context,
                    isVisible: vm.showOldPassword,
                    onToggle: vm.toggleOldPasswordVisibility,
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),

                const SizedBox(height: 20),

                // 🔹 New Password
                _fieldHeader("New Password"),
                TextFormField(
                  controller: vm.newPasswordCtrl,
                  obscureText: !vm.showNewPassword,
                  onChanged: (_) {
                    if (vm.autoValidate) vm.formKey.currentState?.validate();
                  },
                  decoration: _inputDecoration(
                    context,
                    isVisible: vm.showNewPassword,
                    onToggle: vm.toggleNewPasswordVisibility,
                  ),
                  validator: vm.validatePassword,
                ),

                const SizedBox(height: 20),

                // 🔹 Confirm Password
                _fieldHeader("Confirm Password"),
                TextFormField(
                  controller: vm.confirmPasswordCtrl,
                  obscureText: !vm.showConfirmPassword,
                  onChanged: (_) {
                    if (vm.autoValidate) vm.formKey.currentState?.validate();
                  },
                  decoration: _inputDecoration(
                    context,
                    isVisible: vm.showConfirmPassword,
                    onToggle: vm.toggleConfirmPasswordVisibility,
                  ),
                  validator: (v) => v != vm.newPasswordCtrl.text
                      ? 'Passwords do not match'
                      : null,
                ),

                const SizedBox(height: 32),

                // 🔹 Update Button
                ElevatedButton.icon(
                  icon: vm.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.lock_outline),
                  label: Text(
                    vm.isLoading ? 'Updating...' : 'Update Password',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onPressed: vm.isLoading
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
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _fieldHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(
    BuildContext context, {
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          isVisible ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey[700],
        ),
        onPressed: onToggle,
      ),
    );
  }
}
