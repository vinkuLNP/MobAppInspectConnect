class ResendOtpRequestDto {
  final String countryCode;
  final String phoneNumber;

 ResendOtpRequestDto({
    required this.countryCode,
    required this.phoneNumber,
  });


  Map<String, dynamic> toJson() => {
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
      };
}