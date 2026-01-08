class CreatePaymentIntentDto {
  final String paymentType;
  final String priceId;
  final String subscriptionId;
  final String totalAmount;
  final int type;
  final String device;

  final String? transferToId;
  final String? bookingId;

  CreatePaymentIntentDto({
    required this.paymentType,
    required this.priceId,
    required this.subscriptionId,
    required this.totalAmount,
    required this.type,
    required this.device,
    this.transferToId,
    this.bookingId,
  });

  Map<String, dynamic> toJson() => {
    "paymentType": paymentType,
    "priceId": priceId,
    "subscriptionId": subscriptionId,
    "totalAmount": totalAmount,
    "type": type,
    "device": device,
    if (transferToId != null) "transferToId": transferToId,
    if (bookingId != null) "bookingId": bookingId,
  };
}
