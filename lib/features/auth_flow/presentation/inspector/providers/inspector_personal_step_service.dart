import 'package:inspect_connect/core/utils/helpers/device_helper/device_helper.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_widgets.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/auth_flow/utils/text_editor_controller.dart';

class InspectorPersonalStepService {
  final InspectorViewModelProvider provider;
  InspectorPersonalStepService(this.provider);

  String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email';
  }

  String? validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone is required';
    return v.trim().length < 10 ? 'Enter a valid phone' : null;
  }

  String? validatePassword(String? v) {
    RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$',
    );
    if (v == null || v.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(v)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void setPhoneParts({
    required String iso,
    required String dial,
    required String number,
    required String e164,
  }) {
    provider.phoneIso = iso;
    provider.phoneDial = dial;
    provider.phoneRaw = number;
    provider.phoneE164 = e164;
  }

  Future<void> savePersonalStep() async {
    provider.setProcessing(true);
    if (provider.selectedCertificateTypeId != null) {
      await provider.fetchCertificateTypes(
        savedId: provider.selectedCertificateTypeId,
      );
    } else {
      provider.fetchCertificateTypes();
    }

    final deviceToken = await DeviceInfoHelper.getDeviceToken();
    final deviceType = await DeviceInfoHelper.getDeviceType();
    final existing = await provider.localDs.getFullData();
    await provider.localDs.updateFields({
      'role': 2,
      'deviceType': deviceType,
      'deviceToken': deviceToken,
      'name': inspFullNameCtrl.text.trim(),
      'phoneNumber': inspPhoneCtrl.text.trim(),
      'countryCode':
          provider.phoneE164 != null && provider.phoneE164!.startsWith('+')
          ? provider.phoneE164!.substring(
              0,
              provider.phoneE164!.length - (inspPhoneCtrl.text.length),
            )
          : provider.phoneDial ??
                (await provider.localDs.getFullData())?.countryCode ??
                '+91',
      'email': inspEmailCtrlSignUp.text.trim(),
      'password': inspPasswordCtrlSignUp.text,
      'isoCode':
          provider.phoneIso != "" ||
              provider.phoneIso != null ||
              provider.phoneIso!.isNotEmpty
          ? provider.phoneIso
          : (await provider.localDs.getFullData())?.isoCode ?? 'IN',
    });
    provider.setProcessing(false);
  }
}
