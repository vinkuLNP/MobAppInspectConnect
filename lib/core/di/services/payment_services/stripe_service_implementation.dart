import 'dart:developer';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:inspect_connect/core/di/services/payment_services/stripe_service.dart';
import 'package:inspect_connect/core/utils/helpers/custom_exceptions/payment_cancelled_exception.dart';

class StripeServiceImpl implements StripeService {
  @override
  Future<void> confirmCardPayment({required String clientSecret}) async {
    try {
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      log(
        'Stripe Payment Success → '
        'status: ${paymentIntent.status}, '
        'id: ${paymentIntent.id}',
        name: 'StripeService',
      );

      if (paymentIntent.status != PaymentIntentsStatus.Succeeded) {
        throw Exception('Payment failed');
      }
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        throw PaymentCancelledException();
      }
      throw PaymentFailedException(e.error.message ?? 'Stripe payment failed');
    }
  }
}
