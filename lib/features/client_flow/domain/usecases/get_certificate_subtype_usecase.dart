import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class GetCertificateSubTypesParams extends Equatable {


  const GetCertificateSubTypesParams();

  @override
  List<Object?> get props => [];
}

class GetCertificateSubTypesUseCase extends BaseParamsUseCase<List<CertificateSubTypeEntity>, GetCertificateSubTypesParams> {
  final ClientUserRepository _repo;
  GetCertificateSubTypesUseCase(this._repo);

  @override
  Future<ApiResultModel<List<CertificateSubTypeEntity>>> call(GetCertificateSubTypesParams? p) => _repo.getCertificateSubTypes();
}
