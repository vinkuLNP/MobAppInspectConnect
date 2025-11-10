import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/inspector_flow/domain/enum/inspector_status.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/screens/inspector_main_dashboard.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/review_screen.dart';
import 'package:inspect_connect/features/inspector_flow/providers/inspector_main_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class InspectorDashboardView extends StatelessWidget {
  const InspectorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InspectorDashboardProvider()..initializeUserState(context),
      child: Consumer<InspectorDashboardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          switch (provider.status) {
            case InspectorStatus.unverified:
              return const Scaffold(
                body: Center(
                  child: Text('Please verify your phone number to continue.'),
                ),
              );

            case InspectorStatus.needsSubscription:
            // return SubscriptionScreen(provider: provider);

            case InspectorStatus.underReview:
            case InspectorStatus.rejected:
              final user = context.read<UserProvider>().user;
              if (user == null) {
                return const Scaffold(
                  body: Center(child: Text('User data unavailable')),
                );
              }
              return ApprovalStatusScreen(user: user.toDomainEntity());

            case InspectorStatus.approved:
              return const InspectorMainDashboard();
          }
        },
      ),
    );
  }
}
