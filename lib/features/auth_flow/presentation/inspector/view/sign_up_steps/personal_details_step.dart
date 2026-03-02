import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
import 'package:inspect_connect/features/auth_flow/utils/text_editor_controller.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PersonalDetailsStep extends StatelessWidget {
  final InspectorViewModelProvider vm;
  final GlobalKey<FormState> formKey;
  final bool isAccountScreen;
  const PersonalDetailsStep(
    this.vm,
    this.formKey, {
    super.key,
    this.isAccountScreen = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(personalDetails),
        const SizedBox(height: 8),
        AppInputField(
          label: fullNameLabel,
          hint: fullNameHint,
          controller: inspFullNameCtrl,
          validator: vm.validateRequired,
          onChanged: (_) {
            if (vm.autoValidate) formKey.currentState?.validate();
          },
        ),
        const SizedBox(height: 10),
        textWidget(text: phoneNumberLabel, fontWeight: FontWeight.w400),
        const SizedBox(height: 8),

        Consumer<InspectorViewModelProvider>(
          builder: (_, vm, _) => FormField<String>(
            validator: (_) {
              final p = vm.phoneRaw ?? '';
              if ((vm.phoneE164 ?? '').isEmpty) return phoneRequiredError;
              if (p.length < 10) return phoneInvalidError;
              return null;
            },
            builder: (fieldState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntlPhoneField(
                  style: appTextStyle(fontSize: 12),
                  controller: inspPhoneCtrl,
                  initialCountryCode: 'IN',
                  readOnly: isAccountScreen,
                  enabled: !isAccountScreen,
                  decoration: InputDecoration(
                    hintText: phoneNumberLabel,
                    fillColor: isAccountScreen
                        ? Colors.grey.shade300
                        : Colors.white,
                    filled: isAccountScreen,
                    errorText: fieldState.errorText,
                    counterText: '',
                    hintStyle: appTextStyle(fontSize: 12, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: AppColors.authThemeColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  showDropdownIcon: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  flagsButtonPadding: const EdgeInsets.only(left: 8),
                  dropdownIconPosition: IconPosition.trailing,
                  disableLengthCheck: true,
                  validator: (_) => null,
                  onChanged: (phone) {
                    vm.setPhoneParts(
                      iso: phone.countryISOCode,
                      dial: phone.countryCode,
                      number: phone.number,
                      e164: phone.completeNumber,
                    );

                    fieldState.didChange(phone.completeNumber);

                    if (vm.autoValidate) formKey.currentState?.validate();
                  },
                  onCountryChanged: (country) {
                    vm.setPhoneParts(
                      iso: country.code,
                      dial: '+${country.dialCode}',
                      number: vm.phoneRaw ?? '',
                      e164: (vm.phoneRaw?.isNotEmpty ?? false)
                          ? '+${country.dialCode}${vm.phoneRaw}'
                          : '',
                    );

                    fieldState.didChange(vm.phoneE164 ?? '');
                    if (vm.autoValidate) formKey.currentState?.validate();
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),
        AppInputField(
          label: emailLabel,
          hint: emailHint,
          controller: inspEmailCtrlSignUp,
          readOnly: isAccountScreen,
          keyboardType: TextInputType.emailAddress,
          validator: vm.validateEmail,
          onChanged: (_) {
            if (vm.autoValidate) formKey.currentState?.validate();
          },
        ),
        if (!isAccountScreen) ...[
          const SizedBox(height: 10),
          AppPasswordField(
            label: passwordLabel,
            controller: inspPasswordCtrlSignUp,
            obscure: vm.obscurePassword,
            onToggle: vm.toggleObscurePassword,
            validator: vm.validatePassword,
            onChanged: (_) {
              if (vm.autoValidate) formKey.currentState?.validate();
            },
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}
