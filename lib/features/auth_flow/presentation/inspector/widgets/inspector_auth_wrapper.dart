import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class InspectorAuthAutoWrapperView extends StatelessWidget implements AutoRouteWrapper {
  const InspectorAuthAutoWrapperView({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InspectorViewModelProvider()..init(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) => const AutoRouter();
}
