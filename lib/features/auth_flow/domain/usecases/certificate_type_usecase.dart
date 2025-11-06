import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_type_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';

class GetCertificateInspectorTypesParams extends Equatable {


  const GetCertificateInspectorTypesParams();

  @override
  List<Object?> get props => [];
}

class GetCertificateTypeUseCase extends BaseParamsUseCase<List<CertificateInspectorTypeEntity>, GetCertificateInspectorTypesParams> {
  final AuthRepository _repo;
  GetCertificateTypeUseCase(this._repo);

  @override
  Future<ApiResultModel<List<CertificateInspectorTypeEntity>>> call(GetCertificateInspectorTypesParams? p) => _repo.getCertificateTypes();
}
