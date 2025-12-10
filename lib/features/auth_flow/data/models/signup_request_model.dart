class SignUpRequestDto {
  final int role;
  final String email;
  final String name;
  final String phoneNumber;
  final String countryCode;
  final String password;
  final String deviceToken;
  final String deviceType;
  final String mailingAddress;
  final String zip;
  final bool agreedToTerms;
  final bool isTruthfully;
  final Map<String, dynamic> location;

  SignUpRequestDto({
    required this.role,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.countryCode,
    required this.password,
    required this.deviceToken,
    required this.deviceType,
    required this.mailingAddress,
    required this.zip,
    required this.agreedToTerms,
    required this.isTruthfully,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        "role": role,
        "email": email,
        "name": name,
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
        "password": password,
        "deviceToken": deviceToken,
        "deviceType": deviceType,
        "mailingAddress": mailingAddress,
        "zip":zip,
        "agreedToTerms": agreedToTerms,
        "isTruthfully": isTruthfully,
        "location": location,
      };
}
