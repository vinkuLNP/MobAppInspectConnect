import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            textWidget(
              text: message,
              fontSize: 15,
              color: Colors.black87,
              alignment: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppButton(text: "Retry", onTap: onRetry),
          ],
        ),
      ),
    );
  }
}
