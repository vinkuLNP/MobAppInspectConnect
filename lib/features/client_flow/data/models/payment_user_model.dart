import 'package:inspect_connect/features/client_flow/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.email, required super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'email': email, 'name': name};
}
