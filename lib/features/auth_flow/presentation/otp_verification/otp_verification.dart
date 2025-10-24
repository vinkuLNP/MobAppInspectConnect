import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_logo_bar.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/otp_input_fields.dart';
import 'package:inspect_connect/features/auth_flow/utils/otp_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final formKey = GlobalKey<FormState>();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final vm = context.read<ClientViewModelProvider>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.verifyInit();
        vm.focusNode.requestFocus();
      });
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClientViewModelProvider>();

    return BaseResponsiveWidget(
      initializeConfig: false,
      buildWidget: (ctx, rc, app) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: formKey,
              child: Builder(
                builder: (context) {
                  final h = rc.screenHeight;

                  final double titleGap = (h * 0.015).clamp(8.0, 16.0);
                  final double pinputGap = (h * 0.05).clamp(24.0, 40.0);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      appCommonLogoBar(height: rc.screenHeight * 0.2),
                      Align(
                        alignment: Alignment.center,
                        child: textWidget(
                          text: 'Verify Code',
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: titleGap),
                      vm.otpPurpose == OtpPurpose.forgotPassword
                          ? Align(
                              alignment: Alignment.center,
                              child: textWidget(
                                text: vm.resetTargetLabel == null
                                    ? 'Enter the code sent to your email/phone'
                                    : 'Enter the OTP sent to ${vm.resetTargetLabel}',
                                fontSize: 16,
                                colour: Colors.black54,
                              ),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: textWidget(
                                text:
                                    'Please enter the OTP sent to your phone number.',
                                fontSize: 16,
                                colour: Colors.black54,
                              ),
                            ),
                      SizedBox(height: pinputGap),

                      //                       Pinput(
                      //   controller: vm.pinController,
                      //   focusNode: vm.focusNode,
                      //   length: 6,
                      //   defaultPinTheme: basePinTheme,
                      //   focusedPinTheme: focusedPinTheme,
                      //   submittedPinTheme: submittedPinTheme,
                      //   onTap: () => vm.focusNode.requestFocus(),
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly, FixedLengthOverwriteFormatter(6),
                      //   ],
                      //   showCursor: true,
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   separatorBuilder: (_) => SizedBox(width: pinGap),
                      //   autofillHints: const [AutofillHints.oneTimeCode],
                      //   onCompleted: (_) => vm.verify(),
                      //   // Optional: tame paste behaviour (see Note below)
                      //   // onClipboardFound: (clip) {
                      //   //   // Allow full-code paste, or ignore: return;
                      //   // },
                      // ),
                      PerDigitOtp(
                        length: 6,
                        controller: vm.pinController,
                        boxSize: (rc.screenWidth * 0.08)
                            .clamp(44.0, 64.0)
                            .toDouble(),
                        boxGap: (rc.screenWidth * 0.04)
                            .clamp(8.0, 16.0)
                            .toDouble(),
                        themeColor: AppColors.themeColor,
                        // onCompleted:()=> vm.verify(context: context),
                        decorationBuilder: (focused, filled) => InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.themeColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: pinputGap),

                      Center(
                        child: Text(
                          "Didn’t receive OTP?",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: GestureDetector(
                          onTap: vm.canResend
                              ? () => vm.resend(context: context)
                              : null,
                          child: Text(
                            vm.canResend
                                ? "Resend code"
                                : "Resend in ${vm.secondsLeft}s",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: vm.canResend
                                      ? AppColors.themeColor
                                      : Colors.black38,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: (rc.screenHeight * 0.08).clamp(40.0, 80.0),
                      ),

                      AppButton(
                        buttonBackgroundColor: vm.canVerify
                            ? AppColors.themeColor
                            : Colors.grey,
                        onTap: () =>
                            vm.canVerify ? vm.verify(context: context) : null,
                        text: 'Verify',
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textWidget(text: "Already have an account?"),
                          GestureDetector(
                            onTap: () =>
                                context.replaceRoute(const ClientSignInRoute()),
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
