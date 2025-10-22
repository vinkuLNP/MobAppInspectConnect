import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/basecomponents/base_responsive_widget.dart';
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
class ForgotpPasswordView extends StatelessWidget {
  const ForgotpPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BaseResponsiveWidget(
      initializeConfig: false,
      buildWidget: (ctx, rc, app) {
        final provider = ctx.watch<ClientViewModelProvider>();

        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    appCommonLogoBar(height: rc.screenHeight * 0.2),
                    Align(
                      alignment: Alignment.center,
                      child: textWidget(
                        text: 'Forgot Password?',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: textWidget(
                        text:
                            'Enter your email or phone to receive a reset code',
                        fontSize: 16,
                        colour: Colors.black54,
                      ),
                    ),
                    SizedBox(height: (rc.screenHeight * 0.05).clamp(24.0, 40.0)),

                    // Email
                    Consumer<ClientViewModelProvider>(
                      builder: (_, vm, __) => AppInputField(
                        label: 'Email ',
                        controller: vm.resetEmailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (_) => vm.validateEmailOrIntlPhone(),
                      ),
                    ),
                        SizedBox(height: (rc.screenHeight* 0.08).clamp(40.0, 80.0)),

                    // Phone
                    // textWidget(
                    //   text: 'Phone Number (optional)',
                    //   fontSize: 18,
                    //   fontWeight: FontWeight.w500,
                    // ),
                    // const SizedBox(height: 8),
                    // Consumer<ClientViewModelProvider>(
                    //   builder: (_, vm, __) => IntlPhoneField(
                    //     controller: vm.resetPhoneCtrl,
                    //     initialCountryCode: 'IN',
                    //     decoration: InputDecoration(
                    //       hintText: 'Phone Number',
                    //       counterText: '',
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //         borderSide: const BorderSide(color: Colors.grey),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //         borderSide: const BorderSide(
                    //           color: AppColors.themeColor,
                    //           width: 2,
                    //         ),
                    //       ),
                    //       contentPadding: const EdgeInsets.symmetric(
                    //         horizontal: 16,
                    //         vertical: 14,
                    //       ),
                    //     ),
                    //     inputFormatters: [
                    //       FilteringTextInputFormatter.digitsOnly,
                    //       LengthLimitingTextInputFormatter(10),
                    //     ],
                    //     flagsButtonPadding: const EdgeInsets.only(left: 8),
                    //     dropdownIconPosition: IconPosition.trailing,
                    //     disableLengthCheck: true,
                    //     autovalidateMode: AutovalidateMode.onUserInteraction,
                    //     onChanged: (phone) {
                    //       vm.setPhoneParts(
                    //         iso: phone.countryISOCode,
                    //         dial: phone.countryCode,
                    //         number: phone.number,
                    //         e164: phone.completeNumber,
                    //       );
                    //     },
                    //     onCountryChanged: (country) {
                    //       vm.setPhoneParts(
                    //         iso: country.code,
                    //         dial: '+${country.dialCode}',
                    //         number: vm.phoneRaw ?? '',
                    //         e164: (vm.phoneRaw?.isNotEmpty ?? false)
                    //             ? '+${country.dialCode}${vm.phoneRaw}'
                    //             : '',
                    //       );
                    //     },
                    //   ),
                    // ),

                    // const SizedBox(height: 20),

                    Consumer<ClientViewModelProvider>(
                      builder: (_, vm, __) => AppButton(
                        buttonBackgroundColor: AppColors.themeColor,
                        onTap: () {
                          vm.isSendingReset
                              ? null
                              : vm.requestPasswordReset(
                                  formKey: formKey,
                                  context: context,
                                );
                        },
                        text: vm.isSendingReset
                            ? 'Sending...'
                            : 'Send Verification Code',
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textWidget(text: "Already have an account?"),
                        GestureDetector(
                          onTap: () {
                            context.router.pop();
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
        );
      },
    );
  }
}
