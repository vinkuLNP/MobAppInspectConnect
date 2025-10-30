// import 'package:flutter/material.dart';
// import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';
// import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
// import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
// import 'package:provider/provider.dart';
// import 'package:inspect_connect/core/utils/constants/app_colors.dart';

// class WalletScreen extends StatefulWidget {
//   const WalletScreen({super.key});

//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }

// class _WalletScreenState extends State<WalletScreen> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchWalletData();

//     _scrollController.addListener(() {
//       final provider = context.read<WalletProvider>();
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 100) {
//         provider.loadMorePayments(context);
//       }
//     });
//   }

//   Future<void> _fetchWalletData() async {
//     final provider = context.read<WalletProvider>();
//     await provider.refreshAll(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WalletProvider>(
//       builder: (context, provider, _) {
//         final wallet = provider.walletModel;
//         final payments = provider.payments;

//         return Scaffold(
//           backgroundColor: AppColors.whiteColor.withOpacity(0.9),
//           appBar: CommonAppBar(showBackButton: true, title: "My Wallet"),
//           body: RefreshIndicator(
//             onRefresh: _fetchWalletData,
//             child: ListView(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(16),
//               children: [
//                 _WalletBalanceCard(
//                   balance: wallet?.available ?? 0,
//                   pending: wallet?.pending ?? 0,
//                   onRechargeTap: () {},
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   "Transaction History",
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 if (payments.isEmpty)
//                   const Center(
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 50),
//                       child: Text(
//                         "No transactions yet",
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     ),
//                   )
//                 else
//                   ...payments.map(
//                     (txn) => _PaymentTile(
//                       txn: txn,
//                       // title: txn.billingReason,
//                       // subtitle: txn.type.toUpperCase(),
//                       // date: txn.createdAt != null
//                       //     ? "${txn.createdAt!.day}/${txn.createdAt!.month}/${txn.createdAt!.year}"
//                       //     : "N/A",
//                       // amount: txn.amount,
//                       // isCredit: txn.isAdded,
//                     ),
//                   ),

//                 if (provider.isFetching)
//                   const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     child: Center(child: CircularProgressIndicator()),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _WalletBalanceCard extends StatelessWidget {
//   final double balance;
//   final double pending;
//   final VoidCallback onRechargeTap;

//   const _WalletBalanceCard({
//     required this.balance,
//     required this.pending,
//     required this.onRechargeTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: AppColors.themeColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Available Balance",
//               style: TextStyle(color: Colors.white70, fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "\$${balance.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),

//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: onRechargeTap,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: AppColors.themeColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: const Icon(Icons.add_circle_outline),
//               label: const Text("Add Funds"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _PaymentTile extends StatelessWidget {
//   final PaymentEntity txn;

//   const _PaymentTile({required this.txn});

//   @override
//   Widget build(BuildContext context) {
//     final isCredit = txn.isAdded;
//     final color = txn.statusColor;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: color.withOpacity(0.15),
//           child: Icon(
//             isCredit ? Icons.arrow_downward : Icons.arrow_upward,
//             color: color,
//           ),
//         ),
//         title: Text(
//           txn.billingReason.isEmpty ? "Payment" : txn.billingReason,
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         subtitle: Text("${txn.statusLabel} • ${txn.createdAt != null
//             ? "${txn.createdAt!.day}/${txn.createdAt!.month}/${txn.createdAt!.year}"
//             : "N/A"}"),
//         trailing: Text(
//           "${isCredit ? '+' : '-'}\$${txn.amount.toStringAsFixed(2)}",
//           style: TextStyle(
//             color: color,
//             fontWeight: FontWeight.w700,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';
import 'package:inspect_connect/features/client_flow/data/models/wallet_model.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';

// class WalletScreen extends StatefulWidget {
//   const WalletScreen({super.key});

//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }

// class _WalletScreenState extends State<WalletScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(
//       () => context.read<WalletProvider>().init(context: context),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor.withOpacity(0.95),
//       body: Consumer<WalletProvider>(
//         builder: (context, provider, _) {
//           switch (provider.walletState) {
//             case WalletState.loading:
//               return const Center(child: CircularProgressIndicator());

//             case WalletState.error:
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       color: Colors.red,
//                       size: 40,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(provider.errorMessage ?? "Something went wrong"),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       onPressed: () => provider.refreshAll(context),
//                       child: const Text("Retry"),
//                     ),
//                   ],
//                 ),
//               );

//             case WalletState.loaded:
//               final wallet = provider.walletModel;
//               final payments = provider.payments;

//               return RefreshIndicator(
//                 onRefresh: () => provider.refreshAll(context),
//                 child: CustomScrollView(
//                   slivers: [
//                     SliverAppBar(
//                       backgroundColor: AppColors.themeColor,
//                       pinned: true,
//                       expandedHeight: 200,
//                       flexibleSpace: FlexibleSpaceBar(
//                         title: const Text(
//                           "My Wallet",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         background: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 AppColors.themeColor,
//                                 AppColors.themeColor.withOpacity(0.8),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                           ),
//                           child: wallet == null
//                               ? const Center(
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               : _WalletHeader(wallet: wallet),
//                         ),
//                       ),
//                     ),
//                     SliverPadding(
//                       padding: const EdgeInsets.all(16),
//                       sliver: SliverList(
//                         delegate: SliverChildListDelegate([
//                           const SizedBox(height: 8),
//                           Text(
//                             "Transaction History",
//                             style: Theme.of(context).textTheme.titleMedium
//                                 ?.copyWith(fontWeight: FontWeight.w700),
//                           ),
//                           const SizedBox(height: 8),
//                           if (payments.isEmpty)
//                             const Padding(
//                               padding: EdgeInsets.only(top: 50),
//                               child: Center(
//                                 child: Text(
//                                   "No transactions yet",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           else
//                             ...payments
//                                 .map((txn) => _PaymentTile(txn: txn))
//                                 .toList(),
//                           if (provider.isFetching)
//                             const Padding(
//                               padding: EdgeInsets.symmetric(vertical: 16),
//                               child: Center(child: CircularProgressIndicator()),
//                             ),
//                         ]),
//                       ),
//                     ),
//                   ],
//                 ),
//               );

//             default:
//               return const SizedBox();
//           }
//         },
//       ),
//     );
//   }
// }

// class _WalletHeader extends StatelessWidget {
//   final WalletModel wallet;
//   const _WalletHeader({required this.wallet});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Available Balance",
//             style: TextStyle(color: Colors.white70, fontSize: 16),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "\$${wallet.available.toStringAsFixed(2)}",
//             style: const TextStyle(
//               fontSize: 36,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: AppColors.themeColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 icon: const Icon(Icons.add_circle_outline),
//                 label: const Text("Add Funds"),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 "Pending: \$${wallet.pending.toStringAsFixed(2)}",
//                 style: const TextStyle(color: Colors.white70, fontSize: 14),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PaymentTile extends StatelessWidget {
//   final PaymentEntity txn;
//   const _PaymentTile({required this.txn});

//   @override
//   Widget build(BuildContext context) {
//     final color = txn.statusColor;
//     final isCredit = txn.isAdded;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 6,
//             spreadRadius: 1,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: color.withOpacity(0.15),
//           child: Icon(
//             isCredit ? Icons.arrow_downward : Icons.arrow_upward,
//             color: color,
//           ),
//         ),
//         title: Text(
//           txn.billingReason.isEmpty ? "Payment" : txn.billingReason,
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         subtitle: Text(
//           "${txn.statusLabel} • ${txn.createdAt != null ? "${txn.createdAt!.day}/${txn.createdAt!.month}/${txn.createdAt!.year}" : "N/A"}",
//           style: TextStyle(color: txn.statusColor.withOpacity(0.7)),
//         ),
//         trailing: Text(
//           "${isCredit ? '+' : '-'}\$${txn.amount.toStringAsFixed(2)}",
//           style: TextStyle(
//             color: color,
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }

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
  
    return Scaffold(
      backgroundColor: AppColors.whiteColor.withOpacity(0.98),
      body: Consumer<WalletProvider>(
        builder: (context, provider, _) {
          switch (provider.walletState) {
            case WalletState.loading:
              return const Center(child: CircularProgressIndicator());

            case WalletState.error:
              return _ErrorView(
                message: provider.errorMessage ?? "Something went wrong",
                onRetry: () => provider.refreshAll(context),
              );

            case WalletState.loaded:
              final wallet = provider.walletModel;
              final payments = provider.payments;

              return RefreshIndicator(
                onRefresh: () => provider.refreshAll(context),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 220,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: AppColors.themeColor,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(28),
                        ),
                      ),
                      flexibleSpace:  FlexibleSpaceBar(
                        titlePadding: EdgeInsetsDirectional.only(
                          start: 20,
                          bottom: 12,
                        ),
                        // title: Text("Wallet", style: TextStyle(color: Colors.white)),
                        background: _WalletHeader(onAddMoney:()=>  makePayment()),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Recent Transactions",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (payments.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    child: Center(
                                      child: Text(
                                        "No transactions yet",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  ...payments.map(
                                    (txn) => _PaymentTile(txn: txn),
                                  ),
                                if (provider.isFetching)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );

            default:
              return const SizedBox();
          }
        },
      ),
    );
    
  }

  // Future<void> makePayment() async {
  //   try {
  //      paymentIntent = await createPaymentIntent('100', 'USD');

  //     //STEP 2: Initialize Payment Sheet
  //     await Stripe.instance
  //         .initPaymentSheet(
  //           paymentSheetParameters: SetupPaymentSheetParameters(
  //             paymentIntentClientSecret:
  //                 paymentIntent!['client_secret'], //Gotten from payment intent
  //             style: ThemeMode.dark,
  //             merchantDisplayName: 'Ikay',
  //           ),
  //         )
  //         .then((value) {});

  //     //STEP 3: Display Payment sheet
  //     displayPaymentSheet();
  //   } catch (err) {
  //     throw Exception(err);
  //   }
  // }

  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance
  //         .presentPaymentSheet()
  //         .then((value) {
  //           showDialog(
  //             context: context,
  //             builder: (_) => AlertDialog(
  //               content: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Icon(Icons.check_circle, color: Colors.green, size: 100.0),
  //                   SizedBox(height: 10.0),
  //                   Text("Payment Successful!"),
  //                 ],
  //               ),
  //             ),
  //           );

  //           paymentIntent = null;
  //         })
  //         .onError((error, stackTrace) {
  //           throw Exception(error);
  //         });
  //   } on StripeException catch (e) {
  //     log('Error is:---> $e');
  //     AlertDialog(
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             children: const [
  //               Icon(Icons.cancel, color: Colors.red),
  //               Text("Payment Failed"),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   } catch (e) {
  //     print('$e');
  //   }
  // }

  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     //Request body
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //     };

  //     //Make post request to Stripe
  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //       body: body,
  //     );
  //     return json.decode(response.body);
  //   } catch (err) {
  //     throw Exception(err.toString());
  //   }
  // }

  // calculateAmount(String amount) {
  //   final calculatedAmout = (int.parse(amount)) * 100;
  //   return calculatedAmout.toString();
  // }
  Future<void> makePayment() async {
  try {
    log("🔹 Step 1: Creating Payment Intent...");
    paymentIntent = await createPaymentIntent('100', 'USD');
    log("✅ Payment Intent created successfully: $paymentIntent");

    log("🔹 Step 2: Initializing Payment Sheet...");
    await Stripe.instance
        .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret:
                paymentIntent!['client_secret'], 
            style: ThemeMode.dark,
            merchantDisplayName: 'Ikay',
          ),
        )
        .then((value) {
      log("✅ Payment sheet initialized.");
    });

    log("🔹 Step 3: Displaying Payment Sheet...");
    displayPaymentSheet();
  } catch (err, stackTrace) {
    log("❌ makePayment() error: $err");
    log("🧩 Stack Trace: $stackTrace");
    throw Exception(err);
  }
}

Future<void> displayPaymentSheet() async {
  try {
    log("💳 Presenting payment sheet...");
    await Stripe.instance.presentPaymentSheet().then((value) {
      log("✅ Payment successful!");

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 100.0),
              SizedBox(height: 10.0),
              Text("Payment Successful!"),
            ],
          ),
        ),
      );

      paymentIntent = null;
    }).onError((error, stackTrace) {
      log("❌ Error presenting payment sheet: $error");
      log("🧩 Stack Trace: $stackTrace");
      throw Exception(error);
    });
  } on StripeException catch (e) {
    log("⚠️ StripeException caught: $e");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 10),
            Text("Payment Failed"),
          ],
        ),
      ),
    );
  } catch (e, stackTrace) {
    log("❌ Unexpected error in displayPaymentSheet(): $e");
    log("🧩 Stack Trace: $stackTrace");
  }
}

Future<Map<String, dynamic>> createPaymentIntent(
    String amount, String currency) async {
  try {
    log("💰 Creating payment intent for amount: $amount $currency");
    Map<String, dynamic> body = {
      'amount': calculateAmount(amount),
      'currency': currency,
    };
    log("📦 Request body: $body");

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    log("📩 Stripe Response Status: ${response.statusCode}");
    log("📄 Stripe Response Body: ${response.body}");

    return json.decode(response.body);
  } catch (err, stackTrace) {
    log("❌ Error creating payment intent: $err");
    log("🧩 Stack Trace: $stackTrace");
    throw Exception(err.toString());
  }
}

String calculateAmount(String amount) {
  final calculatedAmount = (int.parse(amount)) * 100;
  log("💲 Calculated Stripe amount (in cents): $calculatedAmount");
  return calculatedAmount.toString();
}



}

class _WalletHeader extends StatelessWidget {
    final VoidCallback onAddMoney; 
  const _WalletHeader({required this.onAddMoney});

  @override
  Widget build(BuildContext context) {
    final wallet = context.read<WalletProvider>().walletModel;
    final available = wallet?.available ?? 0;
    final pending = wallet?.pending ?? 0;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.themeColor,
                AppColors.themeColor.withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          right: -40,
          top: -20,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
        ),
        Positioned(
          right: 30,
          top: 35,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          const Text(
                            "Wallet Balance",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "\$${available.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onAddMoney,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.themeColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text("Add Money"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white.withOpacity(0.14),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.35),
                                  ),
                                ),
                              ),
                              child: const Text("Withdraw"),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentEntity txn;
  const _PaymentTile({required this.txn});

  @override
  Widget build(BuildContext context) {
    final isCredit = txn.isAdded;
    final color = isCredit ? const Color(0xFF11A75C) : const Color(0xFFE23B3B);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCredit ? Icons.south_west : Icons.north_east,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCredit ? "Deposit" : "Withdrawal",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  txn.createdAt != null
                      ? "${txn.createdAt!.day}/${txn.createdAt!.month}/${txn.createdAt!.year}"
                      : "N/A",
                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            "${isCredit ? '+' : '-'}\$${txn.amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: color,
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}

