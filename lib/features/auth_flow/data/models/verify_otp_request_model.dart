class VerifyOtpRequestDto {
  final String countryCode;
  final String phoneNumber;
  final String phoneOtp;

 VerifyOtpRequestDto({
    required this.countryCode,
    required this.phoneNumber,
    required this.phoneOtp,
  });


  Map<String, dynamic> toJson() => {
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
        "phoneOtp": phoneOtp,
      };
}