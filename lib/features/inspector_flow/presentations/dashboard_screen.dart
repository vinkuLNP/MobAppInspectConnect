import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/inspector_flow/domain/enum/inspector_status.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/screens/inspector_main_dashboard.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/screens/subscription_screen.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/review_screen.dart';
import 'package:inspect_connect/features/inspector_flow/providers/inspector_main_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class InspectorDashboardView extends StatelessWidget {
  const InspectorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    log('📍 [InspectorDashboard] build() called');

    return Consumer<InspectorDashboardProvider>(
      builder: (context, provider, _) {
        log(
          '🔁 [InspectorDashboard] status=${provider.status}, '
          'isLoading=${provider.isLoading}',
        );

        Widget content = const InspectorMainDashboard();

        switch (provider.status) {
          case InspectorStatus.initial:
            log('🟡 [InspectorDashboard] Status: INITIAL');
            content = const Scaffold();
            break;

          case InspectorStatus.unverified:
            log('🔴 [InspectorDashboard] Status: UNVERIFIED');
            content = Scaffold(
              body: Center(
                child: textWidget(
                  text: 'Please verify your phone number to continue.',
                ),
              ),
            );
            break;

          case InspectorStatus.needsSubscription:
            log('💳 [InspectorDashboard] Status: NEEDS_SUBSCRIPTION');
            content = SubscriptionScreen(provider: provider);
            break;

          case InspectorStatus.underReview:
            log('🟠 [InspectorDashboard] Status: UNDER_REVIEW');
            final user = context.read<UserProvider>().user;

            if (user == null) {
              log('❌ [InspectorDashboard] UserProvider returned null user');
              content = Scaffold(
                body: Center(child: textWidget(text: 'User data unavailable')),
              );
            } else {
              log(
                '👤 [InspectorDashboard] User loaded → '
                'ID=${user.id}, Status=UNDER_REVIEW',
              );
              content = ApprovalStatusScreen();
            }
            break;

          case InspectorStatus.rejected:
            log('❌ [InspectorDashboard] Status: REJECTED');
            final user = context.read<UserProvider>().user;

            if (user == null) {
              log('❌ [InspectorDashboard] UserProvider returned null user');
              content = Scaffold(
                body: Center(child: textWidget(text: 'User data unavailable')),
              );
            } else {
              log(
                '👤 [InspectorDashboard] User loaded → '
                'ID=${user.id}, Status=REJECTED',
              );
              content = ApprovalStatusScreen();
            }
            break;

          case InspectorStatus.approved:
            log('✅ [InspectorDashboard] Status: APPROVED');
            content = const InspectorMainDashboard();
            break;
        }
        log('⏳ [InspectorDashboard] Showing loader');

        return Stack(
          children: [
            content,
            if (provider.isLoading) ...[
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
