import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class UploadImageParams extends Equatable {
  final UploadImageDto filePath;

  const UploadImageParams({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class UploadImageUseCase extends BaseParamsUseCase<UploadImageResponseModel, UploadImageParams> {
  final ClientUserRepository _repo;
  UploadImageUseCase(this._repo);

  @override
  Future<ApiResultModel<UploadImageResponseModel>> call(UploadImageParams? p) =>
      _repo.uploadImage(filePath: p!.filePath);
}
