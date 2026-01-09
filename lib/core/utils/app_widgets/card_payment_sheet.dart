import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/services/payment_services/payment_request.dart';
import 'package:inspect_connect/core/utils/app_widgets/card_widget.dart';
import 'package:inspect_connect/core/utils/helpers/custom_exceptions/payment_cancelled_exception.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/payment_success_widget.dart';

Future<void> showCardPaymentSheet({
  required BuildContext context,
  required WalletProvider provider,
  required PaymentRequest request,
}) async {
  late String clientSecret;
  try {
    clientSecret = await provider.createPaymentIntent(request);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: textWidget(
            text: 'Unable to start payment',
            color: Colors.white,
          ),
        ),
      );
    }
    return;
  }
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => CardPaymentSheet(
      amount: request.amount,
      onPay: () async {
        try {
          await provider.confirmPayment(clientSecret);

          if (context.mounted) Navigator.pop(context);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const PaymentSuccessDialog(),
          );

          provider.refreshAll(context);
        } on PaymentCancelledException {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: 'Payment cancelled',
                  color: Colors.white,
                ),
              ),
            );
          }
        } on PaymentFailedException catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(text: e.message, color: Colors.white),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: 'Payment failed. Please try again.',
                  color: Colors.white,
                ),
              ),
            );
          }
        }
      },
    ),
  );
}
