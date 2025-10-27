class UploadImageResponseModel {
  final String fileUrl;

  const UploadImageResponseModel({required this.fileUrl});

  factory UploadImageResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadImageResponseModel(
      fileUrl: json['fileUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'fileUrl': fileUrl,
      };
}
