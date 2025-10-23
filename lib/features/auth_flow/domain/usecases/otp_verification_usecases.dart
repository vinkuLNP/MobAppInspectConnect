
import 'package:clean_architecture/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:clean_architecture/core/commondomain/usecases/base_params_usecase.dart';
import 'package:clean_architecture/features/auth_flow/domain/entities/auth_user.dart';
import 'package:clean_architecture/features/auth_flow/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class OtpVerificationParams extends Equatable {
  final String phoneOtp;
  final String phoneNumber;
  final String countryCode;


  const OtpVerificationParams({
    required this.phoneOtp,
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [phoneOtp, phoneNumber, countryCode,];
}

class OtpVerificarionUseCase extends BaseParamsUseCase<AuthUser, OtpVerificationParams> {
  final AuthRepository _repo;
  OtpVerificarionUseCase(this._repo);

  @override
  Future<ApiResultModel<AuthUser>> call(OtpVerificationParams? p) => _repo.verifyOtp(
        phoneOtp: p!.phoneOtp,
        phoneNumber: p.phoneNumber,
        countryCode: p.countryCode,
      );
}
