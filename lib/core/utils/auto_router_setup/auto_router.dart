import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/presentation/forgot_password/forgot_password_screen.dart';
import 'package:inspect_connect/features/auth_flow/presentation/otp_verification/otp_verification.dart';
import 'package:inspect_connect/features/auth_flow/presentation/reset_password/reset_new_password_screen.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/view/sign_in_screen.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/view/sign_up_screen.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/client_auth_wrapper.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_in_screen.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_screen.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/inspector_auth_wrapper.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/dashboard_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/account_settings_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/change_password_screen.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/dashboard_screen.dart';
import 'package:inspect_connect/features/onboarding_flow/presentation/view/onboarding_screen.dart';
import 'package:inspect_connect/features/splash_screen.dart';
part 'auto_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});
  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnBoardingRoute.page),
    AutoRoute(page: OtpVerificationRoute.page),
    AutoRoute(page: ForgotpPasswordRoute.page),
    AutoRoute(page: ResetPasswordRoute.page),
    AutoRoute(
      page: ClientAuthAutoWrapperRoute.page,
      children: [
        AutoRoute(page: ClientSignInRoute.page, initial: true),

        AutoRoute(page: ClientSignUpRoute.page),
      ],
    ),
    AutoRoute(page: InspectorSignUpRoute.page),

    // AutoRoute(
    //   page: InspectorAuthAutoWrapperRoute.page,
    //   children: [
    //     AutoRoute(page: InspectorSignInRoute.page, initial: true),

    //     AutoRoute(page: InspectorSignUpRoute.page),
    //   ],
    // ),
    AutoRoute(page: ClientDashboardRoute.page),
    AutoRoute(page: InspectorDashboardRoute.page),

    AutoRoute(page: AccountSettingsRoute.page),
    AutoRoute(page: ChangePasswordRoute.page),
  ];
}
