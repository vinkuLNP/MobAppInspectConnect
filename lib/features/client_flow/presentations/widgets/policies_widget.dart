
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class PolicyAgreementRow extends StatefulWidget {
  const PolicyAgreementRow({super.key});

  @override
  State<PolicyAgreementRow> createState() => _PolicyAgreementRowState();
}

class _PolicyAgreementRowState extends State<PolicyAgreementRow> {
  bool hasOpenedDialog = false; 

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookingProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: hasOpenedDialog
                ? null
                : () async {
                    await _showPoliciesDialog(context, prov);

                    setState(() {
                      hasOpenedDialog = true;
                    });
                  },
            child: Checkbox(
              value: prov.agreedToPolicies,
              onChanged: hasOpenedDialog
                  ? (v) => prov.setAgreePolicy(v ?? false)
                  : null, 
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: GestureDetector(
              onTap: () async {
                await _showPoliciesDialog(context, prov);

                setState(() {
                  hasOpenedDialog = true;
                });
              },
              child: Text(
                "I acknowledge and agree to the Show-Up Fee and Cancellation Policy",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  color: AppColors.authThemeColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPoliciesDialog(
    BuildContext context,
    BookingProvider prov,
  ) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Important Policies"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Show-Up Fee Policy",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "• A show-up fee will be charged if the inspector arrives but cannot perform the inspection due to unavailability or unpreparedness.",
                ),
                Text("• Covers the inspector’s time & travel expenses."),
                Text(
                  "• This fee will be automatically invoiced to your account.",
                ),

                SizedBox(height: 16),

                Text(
                  "Cancellation Policy",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "• Free cancellation up to 8 hours before scheduled inspection.",
                ),
                Text(
                  "• Cancellations made less than 8 hours before will incur a cancellation fee.",
                ),
                Text("• The cancellation fee will be automatically invoiced."),
                Text(
                  "• No refund for no-show or same-day cancellations.",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("I AGREE"),
              onPressed: () {
                prov.setAgreePolicy(true);
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }
}
