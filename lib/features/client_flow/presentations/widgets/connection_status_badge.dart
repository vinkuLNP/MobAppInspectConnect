import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ConnectionStatusBadge extends StatelessWidget {
  const ConnectionStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final isConnected = provider.isConnected;
    final isLoading = provider.isLoading;
    final isDisabledByAdmin = provider.userDisabledByAdmin;

    final statusColor = isConnected
        ? AppColors.successColor
        : AppColors.errorColor;

    String tooltipMessage;

    if (isDisabledByAdmin) {
      tooltipMessage = accountDisabled;
    } else if (isConnected) {
      tooltipMessage = tapToGoOffline;
    } else {
      tooltipMessage = tapToGoOnline;
    }

    return Tooltip(
      message: tooltipMessage,
      preferBelow: true,
      child: GestureDetector(
        onTap: (isDisabledByAdmin || isLoading)
            ? null
            : () async {
                final bool? confirm = await _showConfirmDialog(
                  context,
                  isConnected,
                );
                if (confirm == true) {
                  final newStatus = isConnected ? 0 : 1;
                  await provider.updateInspectorStatus(context, newStatus);
                }
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDisabledByAdmin ? Colors.grey : statusColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (isDisabledByAdmin ? Colors.grey : statusColor)
                    .withValues(alpha: 0.4),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                const CircleAvatar(radius: 4, backgroundColor: Colors.white),
              const SizedBox(width: 6),
              textWidget(
                text: isConnected ? connected : disconnected,
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, bool isConnected) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: textWidget(
            text: isConnected ? goOfflineQues : goOnlineQues,
            fontWeight: FontWeight.w600,
          ),

          content: textWidget(text: isConnected ? goOfflineMsg : goOnlineMsg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: textWidget(text: cancelTxt),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnected
                    ? AppColors.errorColor
                    : AppColors.successColor,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: textWidget(
                text: isConnected ? goOffline : goOnline,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
