import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_agency_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';

class GetAgencyTypesParams extends Equatable {


  const GetAgencyTypesParams();

  @override
  List<Object?> get props => [];
}

class GetAgencyUseCase extends BaseParamsUseCase<List<AgencyEntity>, GetAgencyTypesParams> {
  final AuthRepository _repo;
  GetAgencyUseCase(this._repo);

  @override
  Future<ApiResultModel<List<AgencyEntity>>> call(GetAgencyTypesParams? p) => _repo.getCertificateAgency();
}
