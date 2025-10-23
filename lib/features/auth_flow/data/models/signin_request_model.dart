class SignInRequestDto {
  final String email;
  final String password;
  final String deviceToken;
  final String deviceType;

  SignInRequestDto({
    required this.email,
    required this.password,
    required this.deviceToken,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "deviceToken": deviceToken,
        "deviceType": deviceType,
      };
}