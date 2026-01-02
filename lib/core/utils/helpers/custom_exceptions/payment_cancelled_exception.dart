class PaymentCancelledException implements Exception {}

class PaymentFailedException implements Exception {
  final String message;
  PaymentFailedException(this.message);
}
