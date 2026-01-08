import 'package:inspect_connect/features/inspector_flow/domain/entities/response_payment_intent_entity.dart';

class PaymentIntentModel extends PaymentIntentEntity {
  const PaymentIntentModel({
    required super.paymentIntent,
    required super.ephemeralKey,
    required super.customer,
    required super.publishableKey,
    required super.transactionId,
    required super.created,
    required super.clientSecret,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      paymentIntent: json['paymentIntent'] ?? '',
      ephemeralKey: json['ephemeralKey'] ?? '',
      customer: json['customer'] ?? '',
      publishableKey: json['publishableKey'] ?? '',
      transactionId: json['transactionId'] ?? '',
      created: json['created'] ?? 0,
      clientSecret: json['clientSecret'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'paymentIntent': paymentIntent,
    'ephemeralKey': ephemeralKey,
    'customer': customer,
    'publishableKey': publishableKey,
    'transactionId': transactionId,
    'created': created,
    'clientSecret': clientSecret,
  };
}
