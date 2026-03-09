import 'package:inspect_connect/features/client_flow/data/models/payment_data_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/payment_body_entity.dart';

class PaymentsBodyModel extends PaymentsBodyEntity {
  PaymentsBodyModel({
    required super.payments,
    required super.totalCount,
    required super.totalPages,
    required super.currentPage,
    required super.perPageLimit,
  });

  factory PaymentsBodyModel.fromJson(Map<String, dynamic> json) {
    return PaymentsBodyModel(
      payments: (json['payments'] as List? ?? [])
          .map((e) => PaymentModel.fromJson(e))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      perPageLimit: json['perPageLimit'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'payments': payments.map((e) => (e as PaymentModel).toJson()).toList(),
    'totalCount': totalCount,
    'totalPages': totalPages,
    'currentPage': currentPage,
    'perPageLimit': perPageLimit,
  };
}
