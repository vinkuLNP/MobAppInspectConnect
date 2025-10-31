import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/app_flavor_helper/app_flavors_helper.dart';
import 'package:inspect_connect/core/utils/helpers/app_flavor_helper/environment_config.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/session_manager.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
Stripe.publishableKey = stripePublishableKey;
await dotenv.load(fileName: "assets/.env");
 await Stripe.instance.applySettings();
  // Initialize DI first
  await initAppComponentLocator();
  setupLocator();
  // Then configure the flavor
  final AppFlavorsHelper configService = locator<AppFlavorsHelper>();
  final ProductFlavor? _productFlavor = EnvironmentConfig.BUILD_VARIANT
      .toProductFlavor();
  // prodEnvironmentString
  configService.configure(productFlavor: _productFlavor);
  print(' BUILD_VARIANT = ${EnvironmentConfig.BUILD_VARIANT}');
  print(' Base URL = ${configService.baseUrl}');
    final rootNavigatorKey = GlobalKey<NavigatorState>();
 final appRouter = AppRouter(navigatorKey: rootNavigatorKey);
 SessionManager().navigatorKey = rootNavigatorKey;

  // runApp(const MyApp());
  //   final appRouter = AppRouter(rootNavigatorKey: rootNavigatorKey);
  // SessionManager().navigatorKey = rootNavigatorKey;

  runApp(MyApp(appRouter: appRouter));
  // runApp(MyApp());

}

class MyApp extends StatefulWidget {
    final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();
  final GlobalKey<NavigatorState> navigatorKey = 
  // SessionManager().navigatorKey;
  GlobalKey<NavigatorState>();
  // SessionManager().navigatorKey = navigatorKey;

  static const Color themeColor = Color(0xFF002A86);
  @override
  Widget build(BuildContext context) {
 return   MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
         ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
  // navigatorKey: SessionManager().navigatorKey,

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

// class MyApp extends StatelessWidget {
//   final AppRouter appRouter;
//   const MyApp({super.key, required this.appRouter});

//   static const Color themeColor = Color(0xff1a2c47);

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => locator<UserProvider>()),
//       ],
//       child: MaterialApp.router(
//         routerConfig: appRouter.config(),
//         navigatorKey: SessionManager().navigatorKey, 
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primaryColor: themeColor,
//           scaffoldBackgroundColor: Colors.white,
//           colorScheme: ColorScheme.fromSwatch().copyWith(
//             primary: themeColor,
//             secondary: themeColor,
//           ),
//         ),
//       ),
//     );
//   }
// }


