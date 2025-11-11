import 'package:equatable/equatable.dart';

class SubscriptionFeatureEntity extends Equatable {
  final String id;
  final String name;
  final bool isApplied;

  const SubscriptionFeatureEntity({
    required this.id,
    required this.name,
    required this.isApplied,
  });

  @override
  List<Object?> get props => [id, name, isApplied];
}

class SubscriptionPlanEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double amount;
  final String currency;
  final int trialDays;
  final int userType;
  final String interval;
  final int intervalCount;
  final int status;
  final List<SubscriptionFeatureEntity> features;
  final bool isDeleted;
  final String stripePriceId;
  final String stripeProductId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubscriptionPlanEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.currency,
    required this.trialDays,
    required this.userType,
    required this.interval,
    required this.intervalCount,
    required this.status,
    required this.features,
    required this.isDeleted,
    required this.stripePriceId,
    required this.stripeProductId,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayPrice => '\$$amount / ${interval.toLowerCase()}';

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        amount,
        currency,
        trialDays,
        userType,
        interval,
        intervalCount,
        status,
        features,
        isDeleted,
        stripePriceId,
        stripeProductId,
        createdAt,
        updatedAt,
      ];
}
