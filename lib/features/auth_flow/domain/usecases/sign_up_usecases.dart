import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignUpParams extends Equatable {
  final int role;
  final String email;
  final String name;
  final String phoneNumber;
  final String countryCode;
  final String password;
  final String deviceToken;
  final String deviceType;
  final String mailingAddress;
  final bool agreedToTerms;
  final bool isTruthfully;
  final Map<String, dynamic> location;

  const SignUpParams({
    required this.role,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.countryCode,
    required this.password,
    required this.deviceToken,
    required this.deviceType,
    required this.mailingAddress,
    required this.agreedToTerms,
    required this.isTruthfully,
    required this.location,
  });

  @override
  List<Object?> get props => [
        role,
        email,
        name,
        phoneNumber,
        countryCode,
        password,
        deviceToken,
        deviceType,
        mailingAddress,
        agreedToTerms,
        isTruthfully,
        location,
      ];
}

class SignUpUseCase extends BaseParamsUseCase<AuthUser, SignUpParams> {
  final AuthRepository _repo;
  SignUpUseCase(this._repo);

  @override
  Future<ApiResultModel<AuthUser>> call(SignUpParams? params) {
    return _repo.signUp(
      role: params!.role,
      email: params.email,
      name: params.name,
      phoneNumber: params.phoneNumber,
      countryCode: params.countryCode,
      password: params.password,
      deviceToken: params.deviceToken,
      deviceType: params.deviceType,
      mailingAddress: params.mailingAddress,
      agreedToTerms: params.agreedToTerms,
      isTruthfully: params.isTruthfully,
      location: params.location,
    );
  }
}


