import 'dart:convert';

import 'package:inspect_connect/features/client_flow/domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    required super.id,
    required super.userId,
    required super.available,
    required super.pending,
    required super.isDeleted,
    required super.createdAt,
    required super.updatedAt,
    required super.totalAmount,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      available: (json['available'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      pending: (json['pending'] ?? 0).toDouble(),
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'userId': userId,
    'available': available,
    'totalAmount': totalAmount,
    'pending': pending,
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class WalletResponseModel {
  final WalletModel body;

  WalletResponseModel({required this.body});

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletResponseModel(body: WalletModel.fromJson(json['body'] ?? {}));
  }

  Map<String, dynamic> toJson() => {'body': body.toJson()};
}

WalletResponseModel walletResponseFromJson(String str) =>
    WalletResponseModel.fromJson(json.decode(str));

String walletResponseToJson(WalletResponseModel data) =>
    json.encode(data.toJson());
