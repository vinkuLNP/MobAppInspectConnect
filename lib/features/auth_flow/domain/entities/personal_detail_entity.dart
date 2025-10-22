
class PersonalDetails {
  String fullName = '';
  String countryCode = '+1';
  String phone = '';
  String email = '';
  String address = '';
  String password = '';
  String confirmPassword = '';

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'countryCode': countryCode,
        'phone': phone,
        'email': email,
        'address': address,
        'password': password,
      };
}