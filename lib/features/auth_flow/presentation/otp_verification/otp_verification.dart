import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/auth_form_switch_row.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/common_auth_bar.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/otp_input_fields.dart';
import 'package:inspect_connect/features/auth_flow/utils/otp_enum.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/utils/text_editor_controller.dart';
import 'package:provider/provider.dart';

@RoutePage()
class OtpVerificationView extends StatefulWidget {
  final bool addShowButton;
  const OtpVerificationView({super.key, required this.addShowButton});

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
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        return CommonAuthBar(
          showBackButton: widget.addShowButton,
          title: verifyCode,
          subtitle: vm.otpPurpose == OtpPurpose.forgotPassword
              ? (vm.resetTargetLabel == null
                    ? enterTheCodeSent
                    : '$enterTheOtpSent ${vm.resetTargetLabel}')
              : enterTheCodeSentToPhone,
          image: finalImage,
          rc: rc,
          form: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PerDigitOtp(
                  length: 6,
                  controller: pinController,
                  boxSize: (rc.screenWidth * 0.08).clamp(44.0, 64.0).toDouble(),
                  boxGap: (rc.screenWidth * 0.03).clamp(6.0, 16.0).toDouble(),
                  themeColor: AppColors.authThemeColor,
                  textStyle: appTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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
                        color: AppColors.authThemeColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWidget(
                      text: didntReceiveOtp,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    const SizedBox(width: 4),

                    GestureDetector(
                      onTap: vm.canResend
                          ? () => vm.resend(context: context)
                          : null,
                      child: textWidget(
                        text: vm.canResend
                            ? resendCode
                            : "$resendIn ${vm.secondsLeft}s",
                        fontWeight: FontWeight.w600,
                        color: vm.canResend
                            ? AppColors.authThemeColor
                            : Colors.black38,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 28),

                AppButton(
                  text: verifyTxt,
                  buttonBackgroundColor: vm.canVerify
                      ? AppColors.authThemeColor
                      : Colors.grey,
                  borderColor: vm.canVerify
                      ? AppColors.authThemeColor
                      : Colors.grey,
                  isDisabled: !vm.canVerify,
                  onTap: () {
                    if (vm.canVerify) vm.verify(context: context);
                    if (!context.mounted) return;
                  },
                ),

                AuthFormSwitchRow(
                  question: alreadyHaveAccount,
                  actionText: signInTitle,
                  onTap: () {
                    context.router.replaceAll([
                      ClientSignInRoute(showBackButton: false),
                    ]);
                  },
                  actionColor: AppColors.authThemeLightColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
