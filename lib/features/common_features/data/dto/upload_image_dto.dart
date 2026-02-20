class UploadImageDto {
  final String filePath;

  UploadImageDto({required this.filePath});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'file': filePath};

    return map;
  }
}
