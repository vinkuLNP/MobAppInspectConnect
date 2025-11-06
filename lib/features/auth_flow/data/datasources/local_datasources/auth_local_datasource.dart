import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/app_local_database.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthLocalDataSource {
  final AppLocalDatabase _database;

  AuthLocalDataSource(this._database);

  Future<void> saveUser(AuthUserLocalEntity user) async {
    final existingUsers = await _database.getAll<AuthUserLocalEntity>();

    if (existingUsers != null && existingUsers.isNotEmpty) {
      user.id = existingUsers.first.id;
    }

    _database.insert(user);
  }

  Future<AuthUserLocalEntity?> getUser() async {
    final users = await _database.getAll<AuthUserLocalEntity>();
    if (users != null && users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<void> clear() async {
    _database.clear<AuthUserLocalEntity>();
  }

  Future<void> clearAllData() async {
    _database.clear<AuthUserLocalEntity>();
    _database.clearAll<AuthUserLocalEntity>();
  }

  Future<String?> getUserToken() async {
    final user = await getUser();
    return user?.token;
  }
}
