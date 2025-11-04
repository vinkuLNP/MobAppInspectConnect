
import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';

class UpdateProfileParams extends Equatable {
  final String name;



  const UpdateProfileParams({
    required this.name,
  });

  @override
  List<Object?> get props => [name, ];
}

class UpdateProfileUseCase extends BaseParamsUseCase<AuthUser, UpdateProfileParams> {
  final AuthRepository _repo;
  UpdateProfileUseCase(this._repo);

  @override
  Future<ApiResultModel<AuthUser>> call(UpdateProfileParams? p) => _repo.updateProfile(
        name: p!.name,
      );
}
