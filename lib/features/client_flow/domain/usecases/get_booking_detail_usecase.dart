import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class GetBookingDetailParams extends Equatable {
final String bookingId;

  const GetBookingDetailParams({required this.bookingId});

  @override
  List<Object?> get props => [bookingId,];
}

class GetBookingDetailUseCase extends BaseParamsUseCase<BookingDetailModel, GetBookingDetailParams> {
  final ClientUserRepository _repo;
  GetBookingDetailUseCase(this._repo);

  @override
  Future<ApiResultModel<BookingDetailModel>> call(GetBookingDetailParams? p) => _repo.getBookingDetail(
    p!.bookingId
      );
}

