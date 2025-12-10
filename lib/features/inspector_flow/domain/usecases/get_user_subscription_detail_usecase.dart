import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/user_subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/user_subscription_by_id.dart';
import 'package:inspect_connect/features/inspector_flow/domain/repositories/inspector_repository.dart';

class GetUserSubscriptionDetailParams extends Equatable {
  final UserSubscriptionByIdDto userSubscriptionByIdDto;

  const GetUserSubscriptionDetailParams({
    required this.userSubscriptionByIdDto,
  });

  @override
  List<Object?> get props => [userSubscriptionByIdDto];
}

class GetUserSubscriptionDetailUseCase
    extends
        BaseParamsUseCase<
          UserSubscriptionModel,
          GetUserSubscriptionDetailParams
        > {
  final InspectorRepository _repo;
  GetUserSubscriptionDetailUseCase(this._repo);

  @override
  Future<ApiResultModel<UserSubscriptionModel>> call(
    GetUserSubscriptionDetailParams? p,
  ) => _repo.getUserSubscriptionModel(
    userSubscriptionById: p!.userSubscriptionByIdDto,
  );
}
