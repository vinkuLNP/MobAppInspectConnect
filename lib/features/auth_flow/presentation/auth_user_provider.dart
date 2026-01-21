import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/features/auth_flow/enum/auth_user_enum.dart';

class AuthFlowProvider extends ChangeNotifier {
  AuthUserType? _currentFlow;

  AuthUserType? get currentFlow => _currentFlow;

  void setUserType(AuthUserType flow) {
    _currentFlow = flow;
    notifyListeners();
  }

  bool get isClient => _currentFlow == AuthUserType.client;
  bool get isInspector => _currentFlow == AuthUserType.inspector;
}
