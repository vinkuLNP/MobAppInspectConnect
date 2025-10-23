class DeviceDto {
  final String? deviceToken;
  final String? deviceType;
  DeviceDto({this.deviceToken, this.deviceType});

  factory DeviceDto.fromJson(Map<String, dynamic> j) => DeviceDto(
        deviceToken: j['deviceToken'] as String?,
        deviceType: j['deviceType'] as String?,
      );
}
