import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/features/common_features/data/dto/upload_image_dto.dart';
import 'package:inspect_connect/features/common_features/domain/entities/upload_image_entity.dart';

abstract class CommonRepository {
  Future<ApiResultModel<UploadImageEntity>> uploadImage({
    required UploadImageDto uploadImageDto,
  });
}
