import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class UpdateBookingStatusParams extends Equatable {
  final String bookingId;
  final int status;

  const UpdateBookingStatusParams({
    required this.bookingId,
    required this.status,
  });

  @override
  List<Object?> get props => [bookingId, status];
}

class UpdateBookingStatusUseCase
    extends BaseParamsUseCase<BookingData, UpdateBookingStatusParams> {
  final ClientUserRepository _repo;
  UpdateBookingStatusUseCase(this._repo);

  @override
  Future<ApiResultModel<BookingData>> call(UpdateBookingStatusParams? p) =>
      _repo.updateBookingStatus(p!.bookingId, p.status);
}
