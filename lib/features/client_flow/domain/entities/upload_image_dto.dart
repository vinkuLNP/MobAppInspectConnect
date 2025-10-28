class UploadImageDto {
  final String filePath;

 UploadImageDto({
    required this.filePath,

  });


  Map<String, dynamic> toJson() => {
        "filePath": filePath,
      };
}