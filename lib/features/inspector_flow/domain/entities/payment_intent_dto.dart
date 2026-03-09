class CreatePaymentIntentDto {
  final String paymentType;
  final String? priceId;
  final String? subscriptionId;
  final String totalAmount;
  final int? type;
  final int device;

  final String? transferToId;
  final String? bookingId;

  CreatePaymentIntentDto({
    required this.paymentType,
    this.priceId,
    this.subscriptionId,
    required this.totalAmount,
    this.type,
    required this.device,
    this.transferToId,
    this.bookingId,
  });

  Map<String, dynamic> toJson() => {
    "paymentType": paymentType,
    if (priceId != null) "priceId": priceId,
    if (subscriptionId != null) "subscriptionId": subscriptionId,
    "totalAmount": totalAmount,
    "type": type,
    "device": device,
    if (transferToId != null) "transferToId": transferToId,
    if (bookingId != null) "bookingId": bookingId,
  };
}
