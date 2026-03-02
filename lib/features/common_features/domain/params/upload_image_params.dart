import 'package:equatable/equatable.dart';
import 'package:inspect_connect/features/common_features/data/dto/upload_image_dto.dart';

class UploadImageParams extends Equatable {
  final UploadImageDto uploadImageDto;

  const UploadImageParams({required this.uploadImageDto});

  @override
  List<Object?> get props => [uploadImageDto];
}
