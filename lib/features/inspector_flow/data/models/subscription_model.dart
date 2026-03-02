import 'package:inspect_connect/features/inspector_flow/domain/entities/subscription_plan_entities.dart';

class SubscriptionFeatureModel extends SubscriptionFeatureEntity {
  const SubscriptionFeatureModel({
    required super.id,
    required super.name,
    required super.isApplied,
  });

  factory SubscriptionFeatureModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionFeatureModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      isApplied: json['isApplied'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'isApplied': isApplied,
      };
}

class SubscriptionPlanModel extends SubscriptionPlanEntity {
  const SubscriptionPlanModel({
    required super.id,
    required super.name,
    required super.description,
    required super.amount,
    required super.currency,
    required super.trialDays,
    required super.userType,
    required super.interval,
    required super.intervalCount,
    required super.status,
    required super.features,
    required super.isDeleted,
    required super.stripePriceId,
    required super.stripeProductId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
      trialDays: json['trialDays'] ?? 0,
      userType: json['userType'] ?? 0,
      interval: json['interval'] ?? '',
      intervalCount: json['intervalCount'] ?? 1,
      status: json['status'] ?? 0,
      features: (json['features'] as List<dynamic>? ?? [])
          .map((e) => SubscriptionFeatureModel.fromJson(e))
          .toList(),
      isDeleted: json['isDeleted'] ?? false,
      stripePriceId: json['stripePriceId'] ?? '',
      stripeProductId: json['stripeProductId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'description': description,
        'amount': amount,
        'currency': currency,
        'trialDays': trialDays,
        'userType': userType,
        'interval': interval,
        'intervalCount': intervalCount,
        'status': status,
        'features': features.map((f) {
          if (f is SubscriptionFeatureModel) {
            return f.toJson();
          }
          return {
            '_id': f.id,
            'name': f.name,
            'isApplied': f.isApplied,
          };
        }).toList(),
        'isDeleted': isDeleted,
        'stripePriceId': stripePriceId,
        'stripeProductId': stripeProductId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
 
}
