import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_documents_type.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';

class GetInspectorDocumentsTypeParams extends Equatable {
  const GetInspectorDocumentsTypeParams();

  @override
  List<Object?> get props => [];
}

class GetInspectorDocumentsTypeUseCase
    extends
        BaseParamsUseCase<
          List<InspectorDocumentsTypeEntity>,
          GetInspectorDocumentsTypeParams
        > {
  final AuthRepository _repo;
  GetInspectorDocumentsTypeUseCase(this._repo);

  @override
  Future<ApiResultModel<List<InspectorDocumentsTypeEntity>>> call(
    GetInspectorDocumentsTypeParams? p,
  ) => _repo.getIsnpectorDocumentsType();
}
