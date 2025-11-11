import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';
import '../../providers/wallet_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<WalletProvider>().init(context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: CommonAppBar(
        showBackButton: true,
        title: "Wallet",
        showLogo: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.refreshAll(context),
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(WalletProvider provider) {
    switch (provider.walletState) {
      case WalletState.loading:
        return const Center(child: CircularProgressIndicator());
      case WalletState.error:
        return _ErrorView(
          message: provider.errorMessage ?? "Something went wrong",
          onRetry: () => provider.refreshAll(context),
        );
      case WalletState.loaded:
        return _WalletView(provider: provider, onAddMoney: _showAddMoneyDialog);
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _showAddMoneyDialog() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textWidget(
                text: "Add Money",
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "\$",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  hintText: "Enter amount (e.g. 50)",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppButton(
                text: "Proceed to Pay",
                onTap: () {
                  final amount = controller.text.trim();
                  if (amount.isEmpty ||
                      double.tryParse(amount) == null ||
                      double.tryParse(amount)! < 50.0 ||
                      double.tryParse(amount)! > 100000) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please enter a valid amount - min \$50 AND max -\$100000",
                        ),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  makePayment(amount);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      final intentResponse = await createPaymentIntent(amount, 'USD');
      final body = intentResponse['body'];
      final clientSecret = body?['clientSecret'];

      if (clientSecret == null) {
        throw Exception('Missing clientSecret in payment intent response.');
      }

      await _showCardPaymentSheet(context, clientSecret, amount);
    } catch (e, st) {
      log("❌ makePayment error: $e\n$st");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    }
  }

  Future<void> _showCardPaymentSheet(
    BuildContext parentCtx,
    String clientSecret,
    String amount,
  ) async {
    bool isProcessing = false;

    await showModalBottomSheet(
      context: parentCtx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
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
                    text: isProcessing
                        ? "Processing..."
                        : "Pay \$${amount.toString()}",

                    onTap: isProcessing
                        ? null
                        : () async {
                            setState(() => isProcessing = true);
                            try {
                              await Stripe.instance.confirmPayment(
                                paymentIntentClientSecret: clientSecret,
                                data: const PaymentMethodParams.card(
                                  paymentMethodData: PaymentMethodData(),
                                ),
                              );

                              Navigator.pop(context);
                              _showPaymentSuccess(parentCtx);
                            } on StripeException catch (e) {
                              log("⚠️ Stripe error: $e");
                              ScaffoldMessenger.of(parentCtx).showSnackBar(
                                const SnackBar(
                                  content: Text('Payment canceled'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(parentCtx).showSnackBar(
                                SnackBar(content: Text('Payment failed: $e')),
                              );
                            } finally {
                              setState(() => isProcessing = false);
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
              );
            },
          ),
        );
      },
    );
  }

  void _showPaymentSuccess(BuildContext context) {
    final walletContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _PaymentSuccessDialog(),
    ).then((_) {
      walletContext.read<WalletProvider>().refreshAll(walletContext);
    });
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 10),
              Text("Payment Successful!"),
            ],
          ),
        ),
      );
    } on StripeException catch (e) {
      log("⚠️ StripeException: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment canceled')));
    } catch (e, stackTrace) {
      log("❌ Unexpected error: $e");
      log("🧩 Stack Trace: $stackTrace");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      log("💰 Creating payment intent for amount: $amount $currency");
      final body = {
        'totalAmount': amount,
        'type': '0',
        'paymentType': 'payment-plain',
        'device': '1',
      };

      final url = Uri.parse('$devBaseUrl/payments/paymentIntent');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer ${user.authToken}'},
        body: body,
      );

      final decoded = json.decode(response.body);
      log("📩 Stripe Response: $decoded");
      return decoded;
    } catch (err, stackTrace) {
      log("❌ Error creating payment intent: $err");
      log("🧩 Stack Trace: $stackTrace");
      throw Exception(err.toString());
    }
  }
}

class _WalletView extends StatelessWidget {
  final WalletProvider provider;
  final VoidCallback onAddMoney;

  const _WalletView({required this.provider, required this.onAddMoney});

  @override
  Widget build(BuildContext context) {
    final wallet = provider.walletModel;
    final payments = provider.payments;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            _WalletHeaderCard(
              balance: wallet?.available ?? 0,
              pending: wallet?.pending ?? 0,
              onAddMoney: onAddMoney,
            ),
            const SizedBox(height: 24),
            _RecentTransactions(
              payments: payments,
              isFetching: provider.isFetching,
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletHeaderCard extends StatelessWidget {
  final double balance;
  final double pending;
  final VoidCallback onAddMoney;

  const _WalletHeaderCard({
    required this.balance,
    required this.pending,
    required this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.authThemeColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.themeColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
            text: "Available Balance",
            color: Colors.white70,
            fontSize: 13,
          ),
          const SizedBox(height: 6),
          textWidget(
            text: "\$${balance.toStringAsFixed(2)}",
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: "Add Money",
                  onTap: onAddMoney,
                  buttonBackgroundColor: AppColors.backgroundColor.withOpacity(
                    0.9,
                  ),
                  textColor: AppColors.authThemeColor,
                ),
              ),
            
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentTransactions extends StatefulWidget {
  final List<PaymentEntity> payments;
  final bool isFetching;

  const _RecentTransactions({required this.payments, required this.isFetching});

  @override
  State<_RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<_RecentTransactions> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final provider = context.read<WalletProvider>();
      if (!provider.isFetching) {
        provider.loadMorePayments(context);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();
    final payments = provider.payments;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
            text: "Recent Transactions",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 12),
          if (payments.isEmpty && !provider.isFetching)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  "No transactions yet",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.7,
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: payments.length + 1,
                itemBuilder: (context, index) {
                  if (index < payments.length) {
                    return _PaymentTile(txn: payments[index]);
                  } else if (provider.isFetching) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentEntity txn;
  const _PaymentTile({required this.txn});

  @override
  Widget build(BuildContext context) {
    final isCredit = txn.isAdded;
    final color = isCredit ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCredit ? Icons.south_west : Icons.north_east,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                  text: isCredit ? "Deposit" : "Withdrawal",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                const SizedBox(height: 2),
                Text(
                  txn.createdAt != null
                      ? "${txn.createdAt!.day}/${txn.createdAt!.month}/${txn.createdAt!.year}"
                      : "N/A",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          textWidget(
            text: "${isCredit ? '+' : '-'}\$${txn.amount.toStringAsFixed(2)}",
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

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

class _PaymentSuccessDialog extends StatefulWidget {
  const _PaymentSuccessDialog({super.key});

  @override
  State<_PaymentSuccessDialog> createState() => _PaymentSuccessDialogState();
}

class _PaymentSuccessDialogState extends State<_PaymentSuccessDialog> {
  bool showCheck = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => showCheck = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: showCheck ? 1.0 : 0.4,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: showCheck ? 1 : 0,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD1FADF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xAA4CAF50),
                        blurRadius: 18,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.green,
                    size: 55,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              "Payment Successful!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your wallet balance has been updated successfully.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const SizedBox(height: 26),
            AppButton(
              text: "Continue",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
