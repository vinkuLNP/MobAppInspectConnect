import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/basecomponents/base_responsive_widget.dart';
import 'package:clean_architecture/core/utils/auto_router_setup/auto_router.dart';
import 'package:clean_architecture/core/utils/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_button.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_logo_bar.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_text_widget.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ClientSignUpView extends StatefulWidget {
  const ClientSignUpView({super.key});

  @override
  State<ClientSignUpView> createState() => _ClientSignUpViewState();
}

class _ClientSignUpViewState extends State<ClientSignUpView> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final vm = context.watch<ClientViewModelProvider>();
    final vm = context.read<ClientViewModelProvider>();

    return BaseResponsiveWidget(
      initializeConfig: false,
      buildWidget: (ctx, rc, app) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  appCommonLogoBar(height: rc.screenHeight * 0.2),
                  Align(
                    alignment: Alignment.center,
                    child: textWidget(
                      text: 'Sign Up',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: textWidget(
                      text: 'Please fill in the details below to sign up',
                      fontSize: 16,

                      colour: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Consumer<ClientViewModelProvider>(
                    builder: (_, vm, _) => AppInputField(
                      label: 'Full Name',
                      hint: 'Full Name',
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
                    controller: vm.phoneCtrl,
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
                      vm.setPhoneParts(
                        iso: phone.countryISOCode,
                        dial: phone.countryCode,
                        number: phone.number,
                        e164: phone.completeNumber,
                      );
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
                    },
                  ),

                  const SizedBox(height: 10),

                  Consumer<ClientViewModelProvider>(
                    builder: (_, vm, _) => AppInputField(
                      label: 'Email',
                      hint: 'Email ',

                      controller: vm.emailCtrlSignUp,
                      keyboardType: TextInputType.emailAddress,
                      validator: vm.validateEmail,
                    ),
                  ),

                  // const SizedBox(height: 16),

                  // AppInputField(
                  //   label: 'Mailing Address',
                  //   controller: vm.addressCtrl,
                  //   validator: vm.validateRequired,
                  // ),
                  // const SizedBox(height: 10),
                  // Consumer<ClientViewModelProvider>(
                  //   builder: (_, vm, _) => AppPasswordField(
                  //     label: 'Password',
                  //     controller: vm.passwordCtrlSignUp,
                  //     obscure: vm.obscurePassword,
                  //     onToggle: vm.toggleObscurePassword,
                  //     validator: vm.validatePassword,
                  //   ),
                  // ),

                  // const SizedBox(height: 10),

                  // Consumer<ClientViewModelProvider>(
                  //   builder: (_, vm, _) => AppPasswordField(
                  //     label: 'Confirm Password',
                  //     controller: vm.confirmPasswordCtrl,
                  //     obscure: vm.obscureConfirm,
                  //     onToggle: vm.toggleObscureConfirm,
                  //     validator: vm.validateConfirmPassword,
                  //   ),
                  // ),

                  // const SizedBox(height: 20),

                  // CheckboxListTile(
                  //   value: vm.agreeTnC,
                  //   onChanged: vm.setAgreeTnC,
                  //   contentPadding: EdgeInsets.zero,
                  //   title: const Text('I agree to the Terms and Conditions.'),
                  //   controlAffinity: ListTileControlAffinity.leading,
                  // ),
                  // CheckboxListTile(
                  //   value: vm.isTruthful,
                  //   onChanged: vm.setIsTruthful,
                  //   contentPadding: EdgeInsets.zero,
                  //   title: const Text('I confirm all information is truthful.'),
                  //   controlAffinity: ListTileControlAffinity.leading,
                  // ),
                  // const SizedBox(height: 20),
                       SizedBox(height: (rc.screenHeight* 0.08).clamp(40.0, 80.0)),

                  // Consumer<ClientViewModelProvider>(
                  //   builder: (_, vm, _) =>
                  SizedBox(
                    height: 54,
                    child: AppButton(
                      buttonBackgroundColor: AppColors.themeColor,
                      // vm.isTruthful && vm.agreeTnC
                      //     ? AppColors.themeColor
                      //     : Colors.grey,
                      onTap: () =>
                          vm.submitSignUp(formKey: formKey, context: context),
                      text: 'Sign Up',
                    ),
                  ),
                  // ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(text: "Already have an account?"),
                      GestureDetector(
                        onTap: () {
                          context.pushRoute(const ClientSignInRoute());
                        },
                        child: textWidget(
                          text: 'Sign In',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          colour: AppColors.themeColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



