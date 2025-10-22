import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ClientAuthAutoWrapperView extends StatelessWidget implements AutoRouteWrapper {
  const ClientAuthAutoWrapperView({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientViewModelProvider()..init(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) => const AutoRouter();
}
