import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class UpdateBookingTimerParams extends Equatable {
  final String bookingId;
  final String action;

  const UpdateBookingTimerParams({
    required this.bookingId,
    required this.action,
  });

  @override
  List<Object?> get props => [bookingId,action];
}

class UpdateBookingTimerUseCase
    extends BaseParamsUseCase<BookingData, UpdateBookingTimerParams> {
  final ClientUserRepository _repo;
  UpdateBookingTimerUseCase(this._repo);

  @override
  Future<ApiResultModel<BookingData>> call(UpdateBookingTimerParams? p) =>
      _repo.updateBookingTimer(p!.bookingId, p.action);
}
