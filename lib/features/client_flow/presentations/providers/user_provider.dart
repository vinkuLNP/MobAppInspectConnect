import 'package:flutter/material.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/update_profile_usecase.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:provider/provider.dart';

class UserProvider extends BaseViewModel {
  AuthUserLocalEntity? _user;

  AuthUserLocalEntity? get user => _user;

  bool get isLoggedIn =>
      _user != null &&
      _user?.authToken != null &&
      _user?.phoneOtpVerified == true;

  bool get isUserClient => _user != null && _user?.role == 1;
  bool get isConnected =>
      _user != null &&
      _user?.status == 1 &&
      _user?.statusUpdatedByAdmin == false;

  bool get isDisConnected =>
      _user != null &&
      (_user?.status == 0 || _user?.statusUpdatedByAdmin == true);

  bool get userDisabledByAdmin =>
      _user != null && _user?.statusUpdatedByAdmin == true;

  bool get isUserInspector => _user != null && _user?.role == 2;

  final AuthLocalDataSource _local = locator<AuthLocalDataSource>();

  Future<AuthUserLocalEntity?> refreshUserFromServer(
    BuildContext context,
  ) async {
    final vm = context.read<ClientViewModelProvider>();

    final localUser = user!.toDomainEntity();

    await vm.fetchUserDetail(context: context, user: localUser);

    _user = await locator<AuthLocalDataSource>().getUser();
    notifyListeners();

    return _user;
  }

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
          _user = _user!.copyWith(name: name, userId: user!.userId);
          notifyListeners();

          await locator<AuthLocalDataSource>().saveUser(_user!);
        },
        error: (e) {},
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateInspectorStatus(BuildContext context, int status) async {
    isLoading = true;
    notifyListeners();

    try {
      final useCase = locator<UpdateProfileUseCase>();

      final state = await executeParamsUseCase<AuthUser, UpdateProfileParams>(
        useCase: useCase,
        query: UpdateProfileParams(status: status),
        launchLoader: true,
      );

      state?.when(
        data: (response) async {
          _user = _user!.copyWith(
            status: status,
            userId: response.userId,
            statusUpdatedByAdmin: response.statusUpdatedByAdmin,
          );
          print("API returned status: ${response.status}");

          await locator<AuthLocalDataSource>().saveUser(_user!);
          await refreshUserFromServer(context);

          notifyListeners();
        },
        error: (e) {},
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
    if (fresh?.authToken != _user?.authToken) {
      _user = fresh;
      notifyListeners();
    }
  }
}
