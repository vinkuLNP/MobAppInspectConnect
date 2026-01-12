import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class DeductTransferWalletParams extends Equatable {
  final String bookingId;
  final String transferToId;

  const DeductTransferWalletParams({
    required this.bookingId,
    required this.transferToId,
  });

  @override
  List<Object?> get props => [bookingId, transferToId];
}

class DeductTransferWalletUsecase
    extends BaseParamsUseCase<String, DeductTransferWalletParams> {
  final ClientUserRepository _repo;
  DeductTransferWalletUsecase(this._repo);

  @override
  Future<ApiResultModel<String>> call(DeductTransferWalletParams? p) =>
      _repo.deductTransferWallet(p!.bookingId, p.transferToId);
}
