import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';

class InspectorSignUpParams extends Equatable {
  final InspectorSignUpLocalEntity inspectorSignUpLocalEntity;
  const InspectorSignUpParams({
    required this.inspectorSignUpLocalEntity,
  });

  @override
  List<Object?> get props => [
    inspectorSignUpLocalEntity,
  ];
}

class InspectorSignUpUseCase
    extends BaseParamsUseCase<AuthUser, InspectorSignUpParams> {
  final AuthRepository _repo;

  InspectorSignUpUseCase(this._repo);

  @override
  Future<ApiResultModel<AuthUser>> call(InspectorSignUpParams? params) {
    return _repo.inspectorSignUp(
      inspectorSignUpLocalEntity: params!.inspectorSignUpLocalEntity,
    );
  }
}
