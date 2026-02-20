import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/features/common_features/data/datasources/remote_datasources/common_remote_data_source.dart';
import 'package:inspect_connect/features/common_features/data/dto/upload_image_dto.dart';
import 'package:inspect_connect/features/common_features/domain/entities/upload_image_entity.dart';
import 'package:inspect_connect/features/common_features/domain/repositories/common_repository.dart';

class CommonRepositoryImpl implements CommonRepository {
  final CommonRemoteDataSource _remote;
  CommonRepositoryImpl(this._remote);
  @override
  Future<ApiResultModel<UploadImageEntity>> uploadImage({
    required UploadImageDto uploadImageDto,
  }) async {
    final result = await _remote.uploadImage(uploadImageDto: uploadImageDto);

    return result.when(
      success: (model) {
        final entity = model.toEntity();
        return ApiResultModel<UploadImageEntity>.success(data: entity);
      },
      failure: (e) =>
          ApiResultModel<UploadImageEntity>.failure(errorResultEntity: e),
    );
  }
}
