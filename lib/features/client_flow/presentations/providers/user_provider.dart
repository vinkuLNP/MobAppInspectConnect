
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';

class UserProvider extends ChangeNotifier {
  AuthUserLocalEntity? _user;

  AuthUserLocalEntity? get user => _user;

  bool get isLoggedIn => _user != null && _user?.token != null;

  final AuthLocalDataSource _local = locator<AuthLocalDataSource>();

  Future<void> updateUserName(String name) async {
    if (_user == null) return;


    _user = _user!.copyWith(name: name); 
    notifyListeners();

    await locator<AuthLocalDataSource>().saveUser(_user!);
  }

  Future<void> loadUser() async {
    _user = await _local.getUser();
    notifyListeners();
  }

  Future<void> setUser(AuthUserLocalEntity newUser) async {
    await _local.saveUser(newUser);
    _user = newUser;
    notifyListeners();
  }

  Future<void> clearUser() async {
    await _local.clearAllData();
    _user = null;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    final fresh = await _local.getUser();
    if (fresh?.token != _user?.token) {
      _user = fresh;
      notifyListeners();
    }
  }
}
