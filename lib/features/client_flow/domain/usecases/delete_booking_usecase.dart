import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class DeleteBookingDetailParams extends Equatable {
final String bookingId;

  const DeleteBookingDetailParams({required this.bookingId});

  @override
  List<Object?> get props => [bookingId,];
}

class DeleteBookingDetailUseCase extends BaseParamsUseCase<bool, DeleteBookingDetailParams> {
  final ClientUserRepository _repo;
  DeleteBookingDetailUseCase(this._repo);

  @override
  Future<ApiResultModel<bool>> call(DeleteBookingDetailParams? p) => _repo.deleteBooking(
    p!.bookingId
      );
}
