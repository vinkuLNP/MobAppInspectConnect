import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class OnboardingParams extends Equatable {
  const OnboardingParams();

  @override
  List<Object?> get props => [];
}

class OnboardingUsecase extends BaseParamsUseCase<String, OnboardingParams> {
  final ClientUserRepository _repo;
  OnboardingUsecase(this._repo);

  @override
  Future<ApiResultModel<String>> call(OnboardingParams? p) =>
      _repo.onBoardingUser();
}
