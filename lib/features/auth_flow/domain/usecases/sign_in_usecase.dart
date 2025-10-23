import 'package:clean_architecture/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:clean_architecture/core/commondomain/usecases/base_params_usecase.dart';
import 'package:clean_architecture/features/auth_flow/domain/entities/auth_user.dart';
import 'package:clean_architecture/features/auth_flow/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignInParams extends Equatable {
  final String email;
  final String password;
  final String deviceToken;
  final String deviceType;

  const SignInParams({
    required this.email,
    required this.password,
    required this.deviceToken,
    required this.deviceType,
  });

  @override
  List<Object?> get props => [email, password, deviceToken, deviceType];
}

class SignInUseCase extends BaseParamsUseCase<AuthUser, SignInParams> {
  final AuthRepository _repo;
  SignInUseCase(this._repo);

  @override
  Future<ApiResultModel<AuthUser>> call(SignInParams? p) => _repo.signIn(
        email: p!.email,
        password: p.password,
        deviceToken: p.deviceToken,
        deviceType: p.deviceType,
      );
}
