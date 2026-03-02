import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class CardPaymentSheet extends StatefulWidget {
  final String amount;
  final Future<void> Function() onPay;

  const CardPaymentSheet({
    super.key,
    required this.amount,
    required this.onPay,
  });

  @override
  State<CardPaymentSheet> createState() => _CardPaymentSheetState();
}

class _CardPaymentSheetState extends State<CardPaymentSheet> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          textWidget(
            text: "Pay with Card",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),

          const SizedBox(height: 16),

          CardField(
            enablePostalCode: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            style: const TextStyle(fontSize: 16),
            onCardChanged: (card) {
              log('Card changed: $card');
            },
          ),

          const SizedBox(height: 20),

          AppButton(
            isLoading: isProcessing,
            text: isProcessing ? "Processing..." : "Pay \$${widget.amount}",
            onTap: isProcessing
                ? null
                : () async {
                    setState(() => isProcessing = true);
                    try {
                      await widget.onPay();
                    } finally {
                      if (mounted) {
                        setState(() => isProcessing = false);
                      }
                    }
                  },
          ),

          const SizedBox(height: 12),

          Center(
            child: GestureDetector(
              onTap: isProcessing ? null : () => Navigator.pop(context),
              child: textWidget(
                text: "Cancel",
                color: Colors.grey[600]!,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
