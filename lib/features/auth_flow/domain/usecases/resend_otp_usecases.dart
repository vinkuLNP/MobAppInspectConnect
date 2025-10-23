import 'package:clean_architecture/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:clean_architecture/core/commondomain/usecases/base_params_usecase.dart';
import 'package:clean_architecture/features/auth_flow/domain/entities/auth_user.dart';
import 'package:clean_architecture/features/auth_flow/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class ResendOtpParams extends Equatable {
  final String phoneNumber;
  final String countryCode;


  const ResendOtpParams({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [ phoneNumber, countryCode,];
}

class ResendOtpUseCase extends BaseParamsUseCase<AuthUser, ResendOtpParams> {
  final AuthRepository _repo;
  ResendOtpUseCase(this._repo);

  @override
  Future<ApiResultModel<AuthUser>> call(ResendOtpParams? p) => _repo.resendOtp(
        phoneNumber: p!.phoneNumber,
        countryCode: p.countryCode,
      );
}
