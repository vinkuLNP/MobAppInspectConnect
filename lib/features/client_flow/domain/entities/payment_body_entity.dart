import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';

class PaymentsBodyEntity {
  final List<PaymentEntity> payments;
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final int perPageLimit;

  PaymentsBodyEntity({
    required this.payments,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.perPageLimit,
  });
}
