import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class LateCancellationParams extends Equatable {
  final String bookingId;
  final int status;
  final String clientId;
  final bool lateCancellation;

  const LateCancellationParams({
    required this.bookingId,
    required this.status,
    required this.clientId,
    required this.lateCancellation,
  });

  @override
  List<Object?> get props => [bookingId, status, clientId, lateCancellation];
}

class LateCancellationUseCase
    extends BaseParamsUseCase<BookingData, LateCancellationParams> {
  final ClientUserRepository _repo;
  LateCancellationUseCase(this._repo);

  @override
  Future<ApiResultModel<BookingData>> call(LateCancellationParams? p) => _repo
      .lateCancellation(p!.bookingId, p.status, p.clientId, p.lateCancellation);
}
