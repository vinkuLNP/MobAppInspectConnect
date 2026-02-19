import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/withdraw_response_model.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class WithdrawMoneyParams extends Equatable {
  const WithdrawMoneyParams({required this.amount});
  final int amount;

  @override
  List<Object?> get props => [amount];
}

class WithdrawMoneyUsecase
    extends BaseParamsUseCase<WithdrawMoneyModel, WithdrawMoneyParams> {
  final ClientUserRepository _repo;
  WithdrawMoneyUsecase(this._repo);

  @override
  Future<ApiResultModel<WithdrawMoneyModel>> call(WithdrawMoneyParams? p) =>
      _repo.withdrawMoney(amount: p!.amount);
}
