class UploadImageDto {
  final String filePath;
  final String? privateTempId;
  final String? fileType;

  UploadImageDto({required this.filePath, this.privateTempId, this.fileType});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'file': filePath};

    if (privateTempId != null && privateTempId!.isNotEmpty) {
      map['tempId'] = privateTempId;

      map['type'] = fileType ?? 'sensitive';
    }

    return map;
  }
}
