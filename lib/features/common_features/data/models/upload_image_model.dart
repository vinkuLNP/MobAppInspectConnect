import 'package:inspect_connect/features/common_features/domain/entities/upload_image_entity.dart';

class UploadImageResponseModel {
  final String fileUrl;

  const UploadImageResponseModel({required this.fileUrl});

  factory UploadImageResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadImageResponseModel(fileUrl: json['fileUrl'] ?? '');
  }

  Map<String, dynamic> toJson() => {'fileUrl': fileUrl};
  UploadImageEntity toEntity() => UploadImageEntity(fileUrl: fileUrl);
}
