class PayoutModel {
  final String id;
  final int amount;
  final String currency;
  final int created;
  final int arrivalDate;
  final String status;
  final String method;
  final String type;
  final bool automatic;
  final String sourceType;
  final MetadataModel metadata;
  final TraceIdModel traceId;

  const PayoutModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.created,
    required this.arrivalDate,
    required this.status,
    required this.method,
    required this.type,
    required this.automatic,
    required this.sourceType,
    required this.metadata,
    required this.traceId,
  });

  factory PayoutModel.fromJson(Map<String, dynamic> json) {
    return PayoutModel(
      id: json['id'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
      created: json['created'] ?? 0,
      arrivalDate: json['arrival_date'] ?? 0,
      status: json['status'] ?? '',
      method: json['method'] ?? '',
      type: json['type'] ?? '',
      automatic: json['automatic'] ?? false,
      sourceType: json['source_type'] ?? '',
      metadata: MetadataModel.fromJson(json['metadata'] ?? {}),
      traceId: TraceIdModel.fromJson(json['trace_id'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'currency': currency,
    'created': created,
    'arrival_date': arrivalDate,
    'status': status,
    'method': method,
    'type': type,
    'automatic': automatic,
    'source_type': sourceType,
    'metadata': metadata.toJson(),
    'trace_id': traceId.toJson(),
  };
}

class MetadataModel {
  final String reason;
  final String stripeAccountId;
  final String userId;

  const MetadataModel({
    required this.reason,
    required this.stripeAccountId,
    required this.userId,
  });

  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return MetadataModel(
      reason: json['reason'] ?? '',
      stripeAccountId: json['stripeAccountId'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'reason': reason,
    'stripeAccountId': stripeAccountId,
    'userId': userId,
  };
}

class TraceIdModel {
  final String status;
  final String? value;

  const TraceIdModel({required this.status, this.value});

  factory TraceIdModel.fromJson(Map<String, dynamic> json) {
    return TraceIdModel(status: json['status'] ?? '', value: json['value']);
  }

  Map<String, dynamic> toJson() => {'status': status, 'value': value};
}

class WithdrawMoneyModel {
  final bool success;
  final String message;
  final PayoutModel body;

  const WithdrawMoneyModel({
    required this.success,
    required this.message,
    required this.body,
  });

  factory WithdrawMoneyModel.fromJson(Map<String, dynamic> json) {
    return WithdrawMoneyModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      body: PayoutModel.fromJson(json['body'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'body': body.toJson(),
  };
}
