
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class ChangePasswordParams extends Equatable {
  final String newPassword;
  final String currentPassword;



  const ChangePasswordParams({
    required this.newPassword,
    required this.currentPassword,
  });

  @override
  List<Object?> get props => [newPassword, currentPassword];
}

class ChangePasswordUseCase extends BaseParamsUseCase<AuthUser, ChangePasswordParams> {
  final AuthRepository _repo;
  ChangePasswordUseCase(this._repo);

  @override
  Future<ApiResultModel<AuthUser>> call(ChangePasswordParams? p) => _repo.changePassword(
        newPassword: p!.newPassword,
        currentPassword : p.currentPassword,
      );
}
