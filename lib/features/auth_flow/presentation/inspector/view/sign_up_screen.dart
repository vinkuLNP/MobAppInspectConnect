import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_logo_bar.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

@RoutePage()
class InspectorSignUpView extends StatefulWidget {
  const InspectorSignUpView({super.key});

  @override
  State<InspectorSignUpView> createState() => _InspectorSignUpViewState();
}

class _InspectorSignUpViewState extends State<InspectorSignUpView> {
   final _personalKey = GlobalKey<FormState>();
  final _professionalKey = GlobalKey<FormState>();
  final _serviceAreaKey = GlobalKey<FormState>();
  final _additionalKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InspectorViewModelProvider>();
      final steps = [
      _StepMeta('Personal Details', buildPersonal(vm), _personalKey),
      _StepMeta('Professional Details', buildProfessional(vm), _professionalKey),
      _StepMeta('Service Area', buildServiceArea(vm), _serviceAreaKey),
      _StepMeta('Additional Details', buildAdditional(vm), _additionalKey),
    ];

    return BaseResponsiveWidget(
      initializeConfig: false,
      buildWidget: (ctx, rc, app) => Scaffold(
        body: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: 
              Column(
                children: [
                     appCommonLogoBar(height: rc.screenHeight * 0.06,alignment: MainAxisAlignment.start,),
                      const SizedBox(height: 8),
                    Text(
                      'Please fill in the details below to sign up',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    StepperHeader(
                      current: vm.currentStep,
                      labels: const [
                        'Personal\nDetails',
                        'Professional\nDetails',
                        'Service\nArea',
                        'Additional\nDetails'
                      ],
                      onTap: (i) {
                        if (i <= vm.currentStep) vm.goTo(i);
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: steps[vm.currentStep].formKey,
                            child: SingleChildScrollView(
                              child: steps[vm.currentStep].content,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(isBorder: true,
                          
                            buttonBackgroundColor: Colors.white,
                            borderColor: Colors.grey,
                            textColor: AppColors.themeColor,
                            onTap:()=> vm.currentStep == 0 ? null : vm.goPrevious(),
                            text:  'Previous',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child:  AppButton(
                            onTap: () async {
                              final key = steps[vm.currentStep].formKey;
                              if (key.currentState?.validate() ?? false) {
                                key.currentState?.save();
                                if (vm.currentStep < steps.length - 1) {
                                  vm.goNext();
                                } else {
                                  // Submit
                                  await vm.submit();
                                  if (mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Success'),
                                        content: const Text(
                                          'Your account details have been captured.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            text: vm.currentStep < 3 ? 'Next' : 'Submit'),
                        ),
                      ],
                    ),
                 
                ],
              )
         ),
          ),
        ),
      ),
    );
  }

    Widget buildPersonal(InspectorViewModelProvider p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Personal Details'),
        const SizedBox(height: 8),
      
                  Consumer<InspectorViewModelProvider>(
                    builder: (_, vm, _) => AppInputField(
                      label: 'Full Name',
                      controller: vm.fullNameCtrl,
                      validator: vm.validateRequired,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Phone Number',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),

                  IntlPhoneField(
                    controller: p.phoneCtrl,
                    initialCountryCode: 'IN',
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      counterText: '',
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
                          color: AppColors.themeColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    flagsButtonPadding: const EdgeInsets.only(left: 8),
                    dropdownIconPosition: IconPosition.trailing,
                    disableLengthCheck: true,

                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    // validator: (p) {
                    //   if (p == null || p.number.isEmpty) return 'Phone is required';
                    //   if (p.number.length < 6) return 'Enter a valid phone';
                    //   return null;
                    // },
                    onChanged: (phone) {
                      p.setPhoneParts(
                        iso: phone.countryISOCode,
                        dial: phone.countryCode,
                        number: phone.number,
                        e164: phone.completeNumber,
                      );
                    },
                    onCountryChanged: (country) {
                      p.setPhoneParts(
                        iso: country.code,
                        dial: '+${country.dialCode}',
                        number: p.phoneRaw ?? '',
                        e164: (p.phoneRaw?.isNotEmpty ?? false)
                            ? '+${country.dialCode}${p.phoneRaw}'
                            : '',
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  Consumer<InspectorViewModelProvider>(
                    builder: (_, vm, _) => AppInputField(
                      label: 'Email',
                      controller: vm.emailCtrlSignUp,
                      keyboardType: TextInputType.emailAddress,
                      validator: vm.validateEmail,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<InspectorViewModelProvider>(
                    builder: (_, vm, _) => AppPasswordField(
                      label: 'Password',
                      controller: vm.passwordCtrlSignUp,
                      obscure: vm.obscurePassword,
                      onToggle: vm.toggleObscurePassword,
                      validator: vm.validatePassword,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Consumer<InspectorViewModelProvider>(
                    builder: (_, vm, _) => AppPasswordField(
                      label: 'Confirm Password',
                      controller: vm.confirmPasswordCtrl,
                      obscure: vm.obscureConfirm,
                      onToggle: vm.toggleObscureConfirm,
                      validator: vm.validateConfirmPassword,
                    ),
                  ),

       
      ],
    );
  }

  // Widget buildProfessional(InspectorViewModelProvider p) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SectionTitle('Professional Details'),
  //       const SizedBox(height: 8),
  //       TextFormField(
  //         initialValue: p.professional.company,
  //         decoration: const InputDecoration(labelText: 'Company'),
  //         onSaved: (v) => p.professional.company = v?.trim() ?? '',
  //       ),
  //       const SizedBox(height: 12),
  //       TextFormField(
  //         initialValue: p.professional.designation,
  //         decoration: const InputDecoration(labelText: 'Designation'),
  //         onSaved: (v) => p.professional.designation = v?.trim() ?? '',
  //       ),
  //       const SizedBox(height: 12),
  //       TextFormField(
  //         initialValue: p.professional.experienceYears.toString(),
  //         keyboardType: TextInputType.number,
  //         decoration:
  //             const InputDecoration(labelText: 'Years of Experience'),
  //         validator: (v) {
  //           if (v == null || v.isEmpty) return null;
  //           final n = int.tryParse(v);
  //           return (n == null || n < 0) ? 'Enter a valid number' : null;
  //         },
  //         onSaved: (v) =>
  //             p.professional.experienceYears = int.tryParse(v ?? '0') ?? 0,
  //       ),
  //     ],
  //   );
  // }

Widget buildProfessional(InspectorViewModelProvider p) {
  final theme = Theme.of(context);

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle('Professional Details'),
      const SizedBox(height: 12),

      // --- Certification Type (required) ---
      DropdownButtonFormField<String>(
        value: p.certificationType,
        items: p.certAuthorityByType.keys
            .map((k) => DropdownMenuItem(value: k, child: Text(k)))
            .toList(),
        onChanged: p.setCertificationType,
        validator: p.validateCertType,
        decoration: const InputDecoration(
          labelText: 'Certification Type *',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 12),

      // --- Certifying (auto-filled, non-editable) ---
      TextFormField(
        enabled: false,
        initialValue: p.certifyingBody ?? '',
        decoration: InputDecoration(
          labelText: 'Certifying Rigmaroles (Auto-filled)',
          hintText: 'Please select a certification type first',
          border: const OutlineInputBorder(),
          disabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      const SizedBox(height: 12),

      // --- Expiration Date (calendar) ---
      FormField<String>(
        validator: p.validateExpiry,
        builder: (state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: p.expirationDate == null ? '' : _fmt(p.expirationDate!),
              ),
              decoration: InputDecoration(
                labelText: 'Expiration Date',
                suffixIcon: const Icon(Icons.calendar_today_rounded),
                border: const OutlineInputBorder(),
              ),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: p.expirationDate ?? now,
                  firstDate: now,
                  lastDate: DateTime(now.year + 10),
                );
                if (picked != null) {
                  p.setExpirationDate(
                    DateTime(picked.year, picked.month, picked.day),
                  );
                  // revalidate this FormField
                  state.didChange('set');
                }
              },
            ),
            if (state.hasError) ...[
              const SizedBox(height: 6),
              Text(state.errorText!,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 12,
                  )),
            ]
          ],
        ),
      ),
      const SizedBox(height: 16),

      // --- Upload Certification Documents (required) ---
      FormField<bool>(
        validator: (_) =>
            p.uploadedCount == 0 ? 'Please upload at least one document' : null,
        builder: (state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.upload_rounded),
              label: const Text('Upload Certification Documents'),
              onPressed: () async {
                await p.pickCertificationFiles();
                state.didChange(true); // triggers validation refresh
              },
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${p.uploadedCount} file(s) uploaded',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            if (state.hasError) ...[
              const SizedBox(height: 6),
              Text(state.errorText!,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 12,
                  )),
            ]
          ],
        ),
      ),

      // (Optional) keep your older fields if needed:
      // const SizedBox(height: 16),
      // TextFormField( ... Company ... ),
      // ...
    ],
  );
}

  Widget buildServiceArea(InspectorViewModelProvider p) {
    final controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Service Area'),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: p.serviceArea.city,
          decoration: const InputDecoration(labelText: 'Base City'),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'City is required' : null,
          onSaved: (v) => p.setCity(v ?? ''),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Add Area (e.g., suburb or zip)',
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () {
                p.addServiceArea(controller.text);
                  controller.clear();
              },
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
    Consumer<InspectorViewModelProvider>(
        builder: (_, p, __) =>    Wrap(
          spacing: 8,
          runSpacing: 8,
          children: p.serviceArea.serviceAreas
              .map(
                (s) => Chip(
                  label: Text(s),
                   onDeleted: () => p.removeServiceArea(s),
                ),
              )
              .toList(),
        ),),
      ],
    );
  }

  /// --- Step 4: Additional --- ///
  Widget buildAdditional(InspectorViewModelProvider p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Additional Details'),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('I accept the Terms & Conditions'),
          value: p.additional.termsAccepted,
           onChanged: p.setTermsAccepted,
        ),
        const SizedBox(height: 12),
        TextFormField(
          maxLines: 4,
          initialValue: p.additional.notes,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            alignLabelWithHint: true,
          ),
          onSaved: (v) => p.additional.notes = v?.trim() ?? '',
        ),
        const SizedBox(height: 12),
        if (!p.additional.termsAccepted)
        const Text(
          'Please accept the Terms & Conditions to continue.',
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }


}

class _StepMeta {
  final String title;
  final Widget content;
  final GlobalKey<FormState> formKey;
  _StepMeta(this.title, this.content, this.formKey);
}

