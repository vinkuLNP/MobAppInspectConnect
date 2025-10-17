import 'package:clean_architecture/core/basecomponents/base_view_model.dart';
import 'package:flutter/material.dart';

class ClientViewModelProvider extends BaseViewModel {
 void init() {
  }

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool get obscure => _obscure;

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  Future<void> signIn({required GlobalKey<FormState> formKey}) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
  }




  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrlSignUp = TextEditingController();
  final addressCtrl = TextEditingController();
  final passwordCtrlSignUp = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  void toggleObscurePassword() { _obscurePassword = !_obscurePassword; notifyListeners(); }

  bool _obscureConfirm = true;
  bool get obscureConfirm => _obscureConfirm;
  void toggleObscureConfirm() { _obscureConfirm = !_obscureConfirm; notifyListeners(); }

  bool agreeTnC = false;
  bool isTruthful = false;
  void setAgreeTnC(bool? v) { agreeTnC = v ?? false; notifyListeners(); }
  void setIsTruthful(bool? v) { isTruthful = v ?? false; notifyListeners(); }

  String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email';
  }

  String? validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone is required';
    return v.trim().length < 7 ? 'Enter a valid phone' : null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'At least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'Confirm your password';
    if (v != passwordCtrlSignUp.text) return 'Passwords do not match';
    return null;
  }

  Future<void> submitSignUp({required GlobalKey<FormState> formKey}) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!agreeTnC || !isTruthful) {
      // Show message via snackbar/dialog to accept checkboxes
      return;
    }
    // TODO: call sign-up use case
  }


  @override
  void dispose() {
    // sign-in ctrls
    emailCtrl.dispose();
    passwordCtrl.dispose();
    // sign-up ctrls
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrlSignUp.dispose();
    addressCtrl.dispose();
    passwordCtrlSignUp.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

}