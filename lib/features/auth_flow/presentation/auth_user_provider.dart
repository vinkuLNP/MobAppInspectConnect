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

  void goBackToSignIN(BuildContext context) {
    if (isClient) {
      context.router.replaceAll([ClientSignInRoute(showBackButton: false)]);
    } else if (isInspector) {
      context.router.replaceAll([ClientSignInRoute(showBackButton: false)]);
    } else {
      context.router.pop();
    }
  }

  void handleBackNavigation(BuildContext context) {
    if (isClient) {
      context.replaceRoute(ClientSignInRoute(showBackButton: false));
    } else if (isInspector) {
      context.replaceRoute(ClientSignInRoute(showBackButton: false));
    } else {
      context.pop();
    }
  }

  void goBackToSignUp(BuildContext context) {
    if (isClient) {
      context.router.replaceAll([ClientSignUpRoute(showBackButton: false)]);
    } else if (isInspector) {
      context.router.replaceAll([InspectorSignUpRoute(showBackButton: false)]);
    } else {
      context.router.pop();
    }
  }

  void goToOtp(BuildContext context) {
    context.pushRoute(OtpVerificationRoute(addShowButton: true));
  }
}
