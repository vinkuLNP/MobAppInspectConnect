import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
class PersonalDetailsStep extends StatelessWidget {
  final InspectorViewModelProvider vm;
  final GlobalKey<FormState> formKey;
  const PersonalDetailsStep(this.vm, this.formKey, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Personal Details'),
        const SizedBox(height: 8),
        AppInputField(
          label: 'Full Name',
          hint: 'Full Name',
          controller: vm.fullNameCtrl,
          validator: vm.validateRequired,
          onChanged: (_) {
            if (vm.autoValidate) formKey.currentState?.validate();
          },
        ),
        const SizedBox(height: 10),
        textWidget(text: 'Phone Number', fontWeight: FontWeight.w400),
        const SizedBox(height: 8),
        Consumer<InspectorViewModelProvider>(
          builder: (_, vm, _) => FormField<String>(
            validator: (_) {
              final p = vm.phoneRaw ?? '';
              if (!vm.autoValidate) return null;
              if ((vm.phoneE164 ?? '').isEmpty) return 'Phone is required';
              if (p.length < 10) return 'Enter a valid phone';
              return null;
            },
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntlPhoneField(
                  style: appTextStyle(fontSize: 12),
                  controller: vm.phoneCtrl,
                  initialCountryCode: 'IN',
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    counterText: '',
                    errorStyle: appTextStyle(fontSize: 12, color: Colors.red),
                    hintStyle: appTextStyle(fontSize: 12, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
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
                    if (vm.autoValidate) {
                     formKey.currentState?.validate();
                    }
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
                    if (vm.autoValidate) formKey.currentState?.validate();
                  },
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: textWidget(
                      text: "    ${state.errorText!}",
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        AppInputField(
          label: 'Email',
          hint: 'Email',
          controller: vm.emailCtrlSignUp,
          keyboardType: TextInputType.emailAddress,
          validator: vm.validateEmail,
          onChanged: (_) {
            if (vm.autoValidate) formKey.currentState?.validate();
          },
        ),
        const SizedBox(height: 10),
        AppPasswordField(
          label: 'Password',
          controller: vm.passwordCtrlSignUp,
          obscure: vm.obscurePassword,
          onToggle: vm.toggleObscurePassword,
          validator: vm.validatePassword,
          onChanged: (_) {
            if (vm.autoValidate) formKey.currentState?.validate();
          },
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
