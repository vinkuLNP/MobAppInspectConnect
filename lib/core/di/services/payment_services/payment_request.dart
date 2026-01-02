import 'package:inspect_connect/core/di/services/payment_services/payment_purpose.dart';

class PaymentRequest {
  final PaymentPurpose purpose;
  final String amount;
  final String? referenceId;

  PaymentRequest({
    required this.purpose,
    required this.amount,
    this.referenceId,
  });
}
