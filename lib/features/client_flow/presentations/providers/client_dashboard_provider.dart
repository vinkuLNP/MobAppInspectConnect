import 'package:flutter/material.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/change_password_usecases.dart';
import 'package:inspect_connect/features/auth_flow/utils/text_editor_controller.dart';

class ChangePasswordViewModel extends BaseViewModel {
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
            SnackBar(
              content: textWidget(
                text: passwordUpdatedSuccessfully,
                color: Colors.white,
              ),
            ),
          );
          Navigator.pop(context);
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: textWidget(
                text: e.message ?? passwordUpdateFailed,
                color: Colors.white,
              ),
            ),
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
    oldPasswordCtrl.clear();
    newPasswordCtrl.clear();
    confirmPasswordCtrl.clear();
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return requiredTxt;
    if (value.length < 6) return minimumSixCharactersRequired;
    final regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$',
    );
    if (!regex.hasMatch(value)) {
      return includeUpperLowerNumberSymbol;
    }
    return null;
  }

  String? validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return confirmYourPassword;
    if (v != newPasswordCtrl.text) return passwordsDoNotMatch;
    return null;
  }
}
