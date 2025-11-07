import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_assets_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/inspector_flow/data/subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/subscription_widget.dart';

@RoutePage()
class InspectorDashboardView extends StatefulWidget {
  const InspectorDashboardView({super.key});

  @override
  State<InspectorDashboardView> createState() => _InspectorDashboardViewState();
}

class _InspectorDashboardViewState extends State<InspectorDashboardView> {
  final List<SubscriptionPlan> demoPlans = [
    SubscriptionPlan(
      id: "68ef918a5fc74a4bfe67093f",
      name: "Monthly Plan",
      description: "7 days trial period",
      amount: 49.99,
      currency: "USD",
      trialDays: 8,
      interval: "month",
      intervalCount: 1,
      features: [
        SubscriptionFeature(
          name: "Accept inspection requests instantly",
          isApplied: true,
        ),
        SubscriptionFeature(
          name: "Access full inspector dashboard",
          isApplied: true,
        ),
        SubscriptionFeature(
          name: "Basic job analytics (completed vs. pending)",
          isApplied: true,
        ),
        SubscriptionFeature(name: "Email support", isApplied: true),
        SubscriptionFeature(name: "Secure client payments", isApplied: true),
        SubscriptionFeature(name: "No priority support", isApplied: false),
        SubscriptionFeature(name: "No advanced analytics", isApplied: false),
        SubscriptionFeature(name: "No custom integrations", isApplied: false),
      ],
    ),
    SubscriptionPlan(
      id: "68ef921a5fc74a4bfe670980",
      name: "6-Month Plan",
      description: "7 days trial period",
      amount: 249.99,
      currency: "USD",
      trialDays: 7,
      interval: "month",
      intervalCount: 1,
      features: [
        SubscriptionFeature(name: "All Monthly Plan features", isApplied: true),
        SubscriptionFeature(
          name: "Priority job notifications (get requests first)",
          isApplied: true,
        ),
        SubscriptionFeature(
          name: "Advanced analytics (earnings reports, job trends)",
          isApplied: true,
        ),
        SubscriptionFeature(name: "Phone & email support", isApplied: true),
        SubscriptionFeature(
          name: "Cost savings — pay once, save more",
          isApplied: true,
        ),
        SubscriptionFeature(name: "No custom integrations", isApplied: false),
      ],
    ),
    SubscriptionPlan(
      id: "68ef927b5fc74a4bfe670997",
      name: "Yearly Plan",
      description: "7 days trial period",
      amount: 449.99,
      currency: "USD",
      trialDays: 7,
      interval: "month",
      intervalCount: 1,
      features: [
        SubscriptionFeature(name: "All features unlocked", isApplied: true),
        SubscriptionFeature(
          name: "Highest priority job matching",
          isApplied: true,
        ),
        SubscriptionFeature(
          name: "Advanced job analytics & income reports",
          isApplied: true,
        ),
        SubscriptionFeature(
          name: "Phone, email & dedicated account support",
          isApplied: true,
        ),
        SubscriptionFeature(
          name: "Custom integration options (sync calendars, export reports)",
          isApplied: true,
        ),
        SubscriptionFeature(
          name: "Maximum savings with annual billing",
          isApplied: true,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        // final provider = ctx.watch<ClientViewModelProvider>();

        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: Stack(
            children: [
              SizedBox(height: rc.screenHeight),
              SizedBox(
                width: rc.screenWidth,
                height: rc.screenHeight * 0.35,
                child: imageAsset(
                  image: finalImage,
                  width: rc.screenWidth,
                  height: rc.screenHeight * 0.5,
                  boxFit: BoxFit.cover,
                ),
              ),

              Container(
                width: rc.screenWidth,
                height: rc.screenHeight * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  ),
                ),
              ),

              Positioned(
                left: 24,
                right: 24,
                top: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    textWidget(
                      text: 'Choose Your Subscription Plan',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textWidget(
                      text: "Subscription Plans",
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),

                    SubscriptionCarousel(
                      plans: demoPlans,
                      onSubscribe: (plan) {
                        print('User selected plan: ${plan.id}');
                        makePayment(plan.amount.toString(),plan.id!);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> makePayment(String amount,String priceId,) async {
    try {
      final intentResponse = await createPaymentIntent(amount,priceId, 'USD');
      final body = intentResponse['body'];
      final clientSecret = body?['clientSecret'];

      if (clientSecret == null) {
        throw Exception('Missing clientSecret in payment intent response.');
      }

      // ✅ Open your custom card entry modal
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

                  // Stripe card input field
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _PaymentSuccessDialog(),
    );
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
    String priceId,

    String currency,
  ) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }

      log("💰 Creating payment intent for amount: $amount $currency");
      final body = {
        'totalAmount': amount,
        'type': '0',
        'paymentType': 'subscription',
        'device': '1',
      };

      final url = Uri.parse('$devBaseUrl/payments/paymentIntent');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5MGRlZmU2YWFiZTQ4NzM4MGVhZDBmZiIsImVtYWlsIjoiVGVzcmVlcmV3cmVydHcxMnRAeW9wbWFpbC5jb20iLCJpYXQiOjE3NjI1MjEwNjMsImV4cCI6MTc2MzEyNTg2M30.H9kQgrb_i8YnxARn3eXkcndaOC1QV1XBZZQc2D7zXp8',},
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
    // Delay the checkmark animation safely
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
