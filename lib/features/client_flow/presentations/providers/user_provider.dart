import 'package:flutter/material.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/update_profile_usecase.dart';

class UserProvider extends BaseViewModel {
  AuthUserLocalEntity? _user;

  AuthUserLocalEntity? get user => _user;

  bool get isLoggedIn => _user != null && _user?.token != null;

  final AuthLocalDataSource _local = locator<AuthLocalDataSource>();

  // Future<void> updateUserName(String name) async {
  //   if (_user == null) return;

  //   _user = _user!.copyWith(name: name);
  //   notifyListeners();

  //   await locator<AuthLocalDataSource>().saveUser(_user!);
  // }

  bool isLoading = false;
  Future<void> updateUserName(BuildContext context, String name) async {
    isLoading = true;
    notifyListeners();

    try {
      final useCase = locator<UpdateProfileUseCase>();

      final state = await executeParamsUseCase<AuthUser, UpdateProfileParams>(
        useCase: useCase,
        query: UpdateProfileParams(name: name),
        launchLoader: true,
      );

      state?.when(
        data: (_) async {
          _user = _user!.copyWith(name: name);
          notifyListeners();

          await locator<AuthLocalDataSource>().saveUser(_user!);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Profile updated successfully')),
          // );
          // // Navigator.pop(context);
        },
        error: (e) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(e.message ?? 'Profile update failed')),
          // );
        },
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
