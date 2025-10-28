import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class UpdateBookingDetailParams extends Equatable {
final String bookingId;
final BookingEntity bookingEntity;

  const UpdateBookingDetailParams({required this.bookingId,required this.bookingEntity});

  @override
  List<Object?> get props => [bookingId,bookingEntity,];
}

class UpdateBookingDetailUseCase extends BaseParamsUseCase<BookingDetailModel, UpdateBookingDetailParams> {
  final ClientUserRepository _repo;
  UpdateBookingDetailUseCase(this._repo);

  @override
  Future<ApiResultModel<BookingDetailModel>> call(UpdateBookingDetailParams? p) => _repo.updateBooking(
    p!.bookingId,p.bookingEntity,
      );
}

