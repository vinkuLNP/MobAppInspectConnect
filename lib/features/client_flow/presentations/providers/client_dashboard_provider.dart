import 'package:flutter/material.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/change_password_usecases.dart';

class ChangePasswordViewModel extends BaseViewModel {
  final oldPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> changePassword(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading = true;
    notifyListeners();

    try {
      final useCase = locator<ChangePasswordUseCase>();

      final state = await executeParamsUseCase<AuthUser, ChangePasswordParams>(
        useCase: useCase,
        query: ChangePasswordParams(
          currentPassword: oldPasswordCtrl.text.trim(),
          newPassword: newPasswordCtrl.text.trim(),
        ),
        launchLoader: true,
      );

      state?.when(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully')),
          );
          Navigator.pop(context);
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Password update failed')),
          );
        },
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    oldPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  bool showOldPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  void toggleOldPasswordVisibility() {
    showOldPassword = !showOldPassword;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    showNewPassword = !showNewPassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    showConfirmPassword = !showConfirmPassword;
    notifyListeners();
  }


  bool _autoValidate = false;
  bool get autoValidate => _autoValidate;
  void enableAutoValidate() {
    _autoValidate = true;
    notifyListeners();
  }

  // ✅ Password validation like signup/reset
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (value.length < 6) return 'Minimum 6 characters required';
    final regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
    if (!regex.hasMatch(value)) {
      return 'Include upper, lower, number & symbol';
    }
    return null;
  }

}

