import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/inspector_sign_up_content.dart';
import 'package:provider/provider.dart';

@RoutePage()
class InspectorSignUpView extends StatelessWidget {
  final bool showBackButton;
  const InspectorSignUpView({super.key, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    return InspectorSignUpContent(showBackButton: showBackButton);
    //  ChangeNotifierProvider(
    //   create: (_) => InspectorViewModelProvider(),
    //   child: InspectorSignUpContent(showBackButton: showBackButton),
    // );
  }
}
