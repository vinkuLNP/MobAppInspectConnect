import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/domain/repositories/inspector_repository.dart';

class GetSubscriptionPlansParams extends Equatable {
  const GetSubscriptionPlansParams();

  @override
  List<Object?> get props => [];
}

class GetSubscriptionPlansUseCase
    extends
        BaseParamsUseCase<
          List<SubscriptionPlanModel>,
          GetSubscriptionPlansParams
        > {
  final InspectorRepository _repo;
  GetSubscriptionPlansUseCase(this._repo);

  @override
  Future<ApiResultModel<List<SubscriptionPlanModel>>> call(
    GetSubscriptionPlansParams? p,
  ) => _repo.fetchSubscriptionPlans();
}
