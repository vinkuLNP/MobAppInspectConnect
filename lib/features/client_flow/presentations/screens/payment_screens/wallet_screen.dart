import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/services/payment_services/payment_purpose.dart';
import 'package:inspect_connect/core/di/services/payment_services/payment_request.dart';
import 'package:inspect_connect/core/utils/app_widgets/card_payment_sheet.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/domain/enums/wallet_state_enum.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/payment_screens/wallet_view_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/error_view_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with WidgetsBindingObserver {
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      if (mounted) context.read<WalletProvider>().init(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<WalletProvider>().refreshUserFromServer(context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: CommonAppBar(
        showBackButton: true,
        title: wallet,
        showLogo: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.refreshAll(context),
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(WalletProvider provider) {
    switch (provider.state) {
      case WalletState.loading:
        return const Center(child: CircularProgressIndicator());
      case WalletState.error:
        return ErrorView(
          message: provider.error ?? somethingWentWrong,
          onRetry: () => provider.refreshAll(context),
        );
      case WalletState.loaded:
        return WalletView(
          provider: provider,
          onWithdraw: () =>
              showWithdrawDialog(context: context, provider: provider),
          onAddMoney: () => handleAddMoney(context, provider),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> showWithdrawDialog({
    required BuildContext context,
    required WalletProvider provider,
  }) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textWidget(
                text: 'withdrawMoney',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              const SizedBox(height: 12),

              textWidget(
                text:
                    "Available: \$${provider.wallet?.available.toStringAsFixed(2)}",
                color: Colors.grey,
              ),

              const SizedBox(height: 12),

              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: "Enter withdrawal amount",
                ),
              ),

              const SizedBox(height: 20),

              AppButton(
                text: 'withdrawMoney',
                onTap: () {
                  final amount = double.tryParse(controller.text.trim());

                  if (amount == null || amount < 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Minimum withdrawal amount is \$10"),
                      ),
                    );
                    return;
                  }

                  if (amount > (provider.wallet?.available ?? 0)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Insufficient balance")),
                    );
                    return;
                  }

                  Navigator.pop(context);

                  provider.withdrawMoney(amount.toStringAsFixed(2));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleAddMoney(BuildContext context, WalletProvider provider) {
    if (!provider.isStripeReady) {
      provider.startStripeOnboarding(context);
      return;
    }

    showAddMoneyDialog();
  }

  Future<void> showAddMoneyDialog() async {
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
                text: addMoney,
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
                    child: textWidget(
                      text: "\$",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]!,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  hintText: enterAmountHint,
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
                text: proceedToPay,
                onTap: () {
                  final amount = controller.text.trim();
                  if (amount.isEmpty ||
                      double.tryParse(amount) == null ||
                      double.tryParse(amount)! < 50.0 ||
                      double.tryParse(amount)! > 100000) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: textWidget(
                          text: pleaseEnterValidAmount,
                          color: Colors.white,
                        ),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  showCardPaymentSheet(
                    context: context,
                    provider: context.read<WalletProvider>(),
                    request: PaymentRequest(
                      purpose: PaymentPurpose.addMoneyToWallet,
                      amount: amount,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
