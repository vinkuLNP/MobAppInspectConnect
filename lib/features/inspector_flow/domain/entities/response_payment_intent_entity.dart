class PaymentIntentEntity {
  final String paymentIntent;
  final String ephemeralKey;
  final String customer;
  final String publishableKey;
  final String transactionId;
  final int created;
  final String clientSecret;

  const PaymentIntentEntity({
    required this.paymentIntent,
    required this.ephemeralKey,
    required this.customer,
    required this.publishableKey,
    required this.transactionId,
    required this.created,
    required this.clientSecret,
  });
}
