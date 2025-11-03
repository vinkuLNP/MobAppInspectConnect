class UserDetail {
  final String id;
  final String fullName;
  final String email;
  final int? status;
  final String? phoneNumber;
  final String? countryCode;
  final String? mailingAddress;

  const UserDetail({
    required this.id,
    required this.fullName,
    required this.email,
    this.status,
    this.phoneNumber,
    this.countryCode,
    this.mailingAddress,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    final body = json['body'] ?? json; 
    return UserDetail(
      id: body['_id'] ?? '',
      fullName: body['name'] ?? '',
      email: body['email'] ?? '',
      status: body['status'],
      phoneNumber: body['phoneNumber'],
      countryCode: body['countryCode'],
      mailingAddress: body['mailingAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': fullName,
      'email': email,
      'status': status,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'mailingAddress': mailingAddress,
    };
  }

}
