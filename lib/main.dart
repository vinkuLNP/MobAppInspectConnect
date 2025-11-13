import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/app_flavor_helper/app_flavors_helper.dart';
import 'package:inspect_connect/core/utils/helpers/app_flavor_helper/environment_config.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/presentation/auth_user_provider.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/session_manager.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/inspector_flow/providers/inspector_main_provider.dart';
import 'package:provider/provider.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final appRouter = AppRouter(navigatorKey: rootNavigatorKey);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;

  await Stripe.instance.applySettings();
  await initAppComponentLocator();
  setupLocator();
  final AppFlavorsHelper configService = locator<AppFlavorsHelper>();
  final ProductFlavor? _productFlavor = EnvironmentConfig.BUILD_VARIANT
      .toProductFlavor();
  configService.configure(productFlavor: _productFlavor);
  print(' BUILD_VARIANT = ${EnvironmentConfig.BUILD_VARIANT}');
  print(' Base URL = ${configService.baseUrl}');

  SessionManager().navigatorKey = rootNavigatorKey;

  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatefulWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const Color themeColor = Color(0xFF002A86);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AuthFlowProvider()),
        ChangeNotifierProvider(create: (_) => ClientViewModelProvider()),
        ChangeNotifierProvider(create: (_) => InspectorDashboardProvider()),


        
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.config(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: themeColor,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: themeColor,
            secondary: themeColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: themeColor,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
