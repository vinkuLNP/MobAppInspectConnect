import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/wallet_model.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class GetUserWalletAmountParams extends Equatable {

  const GetUserWalletAmountParams();

  @override
  List<Object?> get props => [];
}

class GetUserWalletAmountUseCase extends BaseParamsUseCase<WalletModel, GetUserWalletAmountParams> {
  final ClientUserRepository _repo;
  GetUserWalletAmountUseCase(this._repo);

  @override
  Future<ApiResultModel<WalletModel>> call(GetUserWalletAmountParams? p) => _repo.getUserWalletAmount(
      );
}

