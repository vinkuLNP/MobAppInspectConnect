import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';

@RoutePage()
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async{

    final user = await locator<AuthLocalDataSource>().getUser();

    if (user != null && user.token != null) {
      context.router.replace(const ClientDashboardRoute());
    } else {
      context.router.replace(const OnBoardingRoute());
    }

      // context.router.replace(const OnBoardingRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/app_logo.png', width: 150),
      ),
    );
  }
}


