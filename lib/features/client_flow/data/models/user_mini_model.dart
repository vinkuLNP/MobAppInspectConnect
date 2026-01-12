import 'package:inspect_connect/features/client_flow/domain/entities/user_mini_entity.dart';

class UserMiniModel {
  final String id;
  final String email;
  final String name;
  UserMiniModel({required this.id, required this.email, required this.name});

  factory UserMiniModel.fromJson(Map<String, dynamic> json) {
    return UserMiniModel(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
    );
  }

  UserMiniEntity toEntity() {
    return UserMiniEntity(id: id, email: email, name: name);
  }
}
