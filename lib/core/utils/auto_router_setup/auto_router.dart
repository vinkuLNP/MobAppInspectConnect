import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/view/forgot_password_screen.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/view/otp_verification.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/view/sign_in_screen.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/view/sign_up_screen.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/widgets/auth_wrapper.dart';
import 'package:clean_architecture/features/onboarding_flow/presentation/view/onboarding_screen.dart';
part 'auto_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: OnBoardingRoute.page, initial: true),
     AutoRoute(
      page: ClientAuthAutoWrapperRoute.page,
      children: [
        AutoRoute(page: ClientSignInRoute.page, initial: true),

         AutoRoute(page: ClientSignUpRoute.page),
    AutoRoute(page: ClientOtpVerificationRoute.page),
    AutoRoute(page: ClientForgotpPasswordRoute.page),
      ],
    ),
   
  ];
}
