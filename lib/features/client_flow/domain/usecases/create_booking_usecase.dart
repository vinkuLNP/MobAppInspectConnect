import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';


class CreateBookingParams extends Equatable {
  final BookingEntity bookingEntity;


  const CreateBookingParams({
    required this.bookingEntity,
  });

  @override
  List<Object?> get props => [bookingEntity,];
}

class CreateBookingUseCase extends BaseParamsUseCase<CreateBookingResponseModel, CreateBookingParams> {
  final ClientUserRepository _repo;
  CreateBookingUseCase(this._repo);

  @override
  Future<ApiResultModel<CreateBookingResponseModel>> call(CreateBookingParams? p) => _repo.createBooking(
        booking: p!.bookingEntity
      );
}


