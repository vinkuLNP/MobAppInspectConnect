import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/jurisdiction_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';

class GetJurisdictionParams extends Equatable {
  const GetJurisdictionParams();

  @override
  List<Object?> get props => [];
}

class GetJurisdictionCitiesUseCase
    extends BaseParamsUseCase<List<JurisdictionEntity>, GetJurisdictionParams> {
  final AuthRepository _repo;
  GetJurisdictionCitiesUseCase(this._repo);

  @override
  Future<ApiResultModel<List<JurisdictionEntity>>> call(
    GetJurisdictionParams? p,
  ) => _repo.getJurisdictionCities();
}
