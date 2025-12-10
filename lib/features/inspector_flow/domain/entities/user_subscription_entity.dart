class UserSubscriptionEntity {
  final String id;
  final String userId;
  final String planId;
  final String stripeSubscriptionId;
  final String customerId;
  final String productId;
  final String priceId;
  final String stripeSubscriptionStatus;
  final String collectionMethod;
  final int startDate;
  final int currentPeriodStart;
  final int currentPeriodEnd;
  final int trialStart;
  final int trialEnd;
  final int amount;
  final String currency;
  final String interval;
  final int intervalCount;
  final String? latestInvoiceUrl;
  final String? latestInvoicePdf;
  final String? latestInvoiceId;
  final bool livemode;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserSubscriptionEntity({
    required this.id,
    required this.userId,
    required this.planId,
    required this.stripeSubscriptionId,
    required this.customerId,
    required this.productId,
    required this.priceId,
    required this.stripeSubscriptionStatus,
    required this.collectionMethod,
    required this.startDate,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.trialStart,
    required this.trialEnd,
    required this.amount,
    required this.currency,
    required this.interval,
    required this.intervalCount,
    this.latestInvoiceUrl,
    this.latestInvoicePdf,
    this.latestInvoiceId,
    required this.livemode,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
}
