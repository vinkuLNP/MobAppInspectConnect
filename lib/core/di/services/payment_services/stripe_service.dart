abstract class StripeService {
  Future<void> confirmCardPayment({required String clientSecret});
}
