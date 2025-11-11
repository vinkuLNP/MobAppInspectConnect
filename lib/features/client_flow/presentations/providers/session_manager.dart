import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  GlobalKey<NavigatorState>? navigatorKey;
  bool _isDialogVisible = false;

  Future<void> logout({String? reason}) async {
    debugPrint('🚪 [SessionManager] logout() called. Reason: $reason');
    if (_isDialogVisible) {
      debugPrint(
        '⚠️ [SessionManager] Logout dialog already visible — skipping duplicate.',
      );
      return;
    }
    _isDialogVisible = true;

    final navContext = navigatorKey?.currentContext;
    debugPrint(
      '🧭 [SessionManager] Navigator context: ${navContext != null ? "✅ Found" : "❌ Null"}',
    );

    if (navContext == null) {
      debugPrint(
        '⚠️ [SessionManager] Navigator context is null — performing silent logout.',
      );
      await _performLogoutSilently();
      _isDialogVisible = false;
      return;
    }

    try {
      debugPrint('🪟 [SessionManager] Showing logout dialog...');
      await showDialog(
        context: navContext,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Session Expired'),
          content: Text(
            '${reason ?? 'Your session has expired.'} Please log in again.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                debugPrint(
                  '👋 [SessionManager] OK pressed on dialog. Logging out silently...',
                );
                Navigator.of(navContext).pop();
                await _performLogoutSilently();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      debugPrint('🪟 [SessionManager] Dialog closed.');
    } catch (e, st) {
      debugPrint('❌ [SessionManager] Error showing dialog: $e\n$st');
    } finally {
      _isDialogVisible = false;
      debugPrint('🔚 [SessionManager] Dialog visibility reset.');
    }
  }

  Future<void> _performLogoutSilently() async {
    debugPrint('⚙️ [SessionManager] Performing silent logout...');
    try {
      if (!locator.isRegistered<UserProvider>()) {
        debugPrint('❌ [SessionManager] UserProvider not registered in GetIt.');
        return;
      }

      final userProvider = locator<UserProvider>();
      debugPrint('👤 [SessionManager] Clearing user session...');
      await userProvider.clearUser();
      debugPrint('✅ [SessionManager] User cleared successfully.');

      final navContext = navigatorKey?.currentContext;
      if (navContext != null && navContext.mounted) {
        debugPrint('🔁 [SessionManager] Navigating to OnBoardingRoute...');
        navContext.router.replaceAll([const OnBoardingRoute()]);
      } else {

        debugPrint(
          '⚠️ [SessionManager] Navigation context missing or unmounted.',
        );
      }
    } catch (e, st) {
      debugPrint('❌ [SessionManager] Logout failed: $e\n$st');
    }
  }
}
