import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  GlobalKey<NavigatorState>? navigatorKey;
  bool _isDialogVisible = false;

  Future<void> logout({String? reason}) async {
    log('🚪 [SessionManager] logout() called. Reason: $reason');
    if (_isDialogVisible) {
      log(
        '⚠️ [SessionManager] Logout dialog already visible — skipping duplicate.',
      );
      return;
    }
    _isDialogVisible = true;

    final navContext = navigatorKey?.currentContext;
    log(
      '🧭 [SessionManager] Navigator context: ${navContext != null ? "✅ Found" : "❌ Null"}',
    );

    if (navContext == null) {
      log(
        '⚠️ [SessionManager] Navigator context is null — performing silent logout.',
      );
      await _performLogoutSilently();
      _isDialogVisible = false;
      return;
    }

    try {
      log('🪟 [SessionManager] Showing logout dialog...');
      await showDialog(
        context: navContext,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: textWidget(text: sessionExpired),
          content: textWidget(
            text: '${reason ?? sessionExpiredMessage} $pleaseLogInAgain',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                log(
                  '👋 [SessionManager] OK pressed on dialog. Logging out silently...',
                );
                Navigator.of(navContext).pop();
                await _performLogoutSilently();
              },
              child: textWidget(text: okTxt),
            ),
          ],
        ),
      );
      log('🪟 [SessionManager] Dialog closed.');
    } catch (e, st) {
      log('❌ [SessionManager] Error showing dialog: $e\n$st');
    } finally {
      _isDialogVisible = false;
      log('🔚 [SessionManager] Dialog visibility reset.');
    }
  }

  Future<void> _performLogoutSilently() async {
    log('⚙️ [SessionManager] Performing silent logout...');
    try {
      if (!locator.isRegistered<UserProvider>()) {
        log('❌ [SessionManager] UserProvider not registered in GetIt.');
        return;
      }

      final userProvider = locator<UserProvider>();
      log('👤 [SessionManager] Clearing user session...');
      await userProvider.clearUser();
      log('✅ [SessionManager] User cleared successfully.');

      final navContext = navigatorKey?.currentContext;
      if (navContext != null && navContext.mounted) {
        log('🔁 [SessionManager] Navigating to OnBoardingRoute...');
        navContext.router.replaceAll([const OnBoardingRoute()]);
      } else {
        log('⚠️ [SessionManager] Navigation context missing or unmounted.');
      }
    } catch (e, st) {
      log('❌ [SessionManager] Logout failed: $e\n$st');
    }
  }
}
