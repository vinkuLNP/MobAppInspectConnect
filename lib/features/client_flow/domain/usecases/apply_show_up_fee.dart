import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class ShowUpFeeStatusParams extends Equatable {
  final String bookingId;
  final bool showUpFeeApplied;

  const ShowUpFeeStatusParams({
    required this.bookingId,
    required this.showUpFeeApplied,
  });

  @override
  List<Object?> get props => [bookingId, showUpFeeApplied];
}

class ShowUpFeeStatusUseCase
    extends BaseParamsUseCase<BookingData, ShowUpFeeStatusParams> {
  final ClientUserRepository _repo;
  ShowUpFeeStatusUseCase(this._repo);

  @override
  Future<ApiResultModel<BookingData>> call(ShowUpFeeStatusParams? p) =>
      _repo.showUpFeeStatus(p!.bookingId, p.showUpFeeApplied);
}
