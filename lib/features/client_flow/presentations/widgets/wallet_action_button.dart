import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';

class WalletActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool enabled;
  final bool isLoading;
  final VoidCallback? onTap;
  final String? disabledMessage;

  const WalletActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.enabled,
    required this.onTap,
    this.isLoading = false,
    this.disabledMessage,
  });

  @override
  Widget build(BuildContext context) {
    final button = AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1 : 0.8,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: enabled ? Colors.white.withValues(alpha: 0.12) : Colors.grey,

          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    textWidget(
                      text: text,
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
        ),
      ),
    );
    if (enabled) {
      return GestureDetector(onTap: !isLoading ? onTap : null, child: button);
    }
    return Tooltip(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(16),
      message: disabledMessage ?? actionNotAvailable,
      triggerMode: TooltipTriggerMode.tap,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: appTextStyle(color: Colors.white, fontSize: 12),
      child: button,
    );
  }
}
