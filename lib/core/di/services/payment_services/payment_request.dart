import 'package:inspect_connect/core/di/services/payment_services/payment_purpose.dart';

class PaymentRequest {
  final PaymentPurpose purpose;
  final String amount;
  final String? priceId;
  final String? subscriptionId;
  final String? totalAmount;
  final int type;
  final String device;

  PaymentRequest({
    required this.purpose,
    required this.amount,
    this.priceId,
    this.subscriptionId,
    this.totalAmount,
    this.type = 0,
    this.device = '1',
  });
}
