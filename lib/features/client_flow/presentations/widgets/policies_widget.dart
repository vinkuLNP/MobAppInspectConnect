import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/features/client_flow/presentations/constants/booking_policy_text.dart';
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
      padding: EdgeInsetsGeometry.only(top: 8, left: 10, right: 10),
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
                BookingPoliciesText.acknowledgmentText,
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
          title: const Text(BookingPoliciesText.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: BookingPoliciesText.sections.map((section) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: section.highlight
                              ? Colors.red
                              : AppColors.authThemeColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...section.bullets.map(
                        (bullet) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            "• ${bullet.text}",
                            style: TextStyle(
                              color: bullet.highlight
                                  ? Colors.red
                                  : Colors.black,
                              fontWeight: bullet.highlight
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
