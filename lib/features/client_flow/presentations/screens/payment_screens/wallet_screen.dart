import 'package:flutter/material.dart';

class WalletRechargeScreen extends StatelessWidget {
  final double minAmount;
  final double maxAmount;

  const WalletRechargeScreen({
    super.key,
    required this.minAmount,
    required this.maxAmount,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Recharge Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter amount to add (Min: \$${minAmount.toInt()}, Max: \$${maxAmount.toInt()})',
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountController.text);
                  if (amount == null ||
                      amount < minAmount ||
                      amount > maxAmount) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Please enter an amount between \$${minAmount.toInt()} and \$${maxAmount.toInt()}'),
                      ),
                    );
                    return;
                  }

                  // TODO: Call your recharge API here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Wallet recharged with \$${amount.toInt()}')),
                  );

                  Navigator.pop(context);
                },
                child: const Text('Add Funds'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
