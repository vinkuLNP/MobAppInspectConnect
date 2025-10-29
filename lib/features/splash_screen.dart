// import 'package:auto_route/auto_route.dart';
// import 'package:inspect_connect/core/di/app_component/app_component.dart';
// import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
// import 'package:flutter/material.dart';
// import 'package:inspect_connect/core/utils/constants/app_colors.dart';
// import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
// import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
// import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
// import 'package:provider/provider.dart';

// @RoutePage()
// class SplashView extends StatefulWidget {
//   const SplashView({super.key});

//   @override
//   State<SplashView> createState() => _SplashViewState();
// }

// class _SplashViewState extends State<SplashView> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 2), () async{

//     final user = await locator<AuthLocalDataSource>().getUser();

//        final userProvider = context.read<UserProvider>();
//         final bookingProvider = context.read<BookingProvider>();
//        if(user != null){
//     userProvider.setUser(user);

//        }

//     await userProvider.loadUser();

//     if (userProvider.isLoggedIn) {
//         await bookingProvider.fetchBookingsList();
//       context.router.replace(const ClientDashboardRoute());
//     } else {
//       context.router.replace(const OnBoardingRoute());
//     }
//   });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           children: [
//             Image.asset('assets/images/app_logo.png', width: 150),
//             Text("Inspect Connect",style: TextStyle(color: AppColors.themeColor,fontSize: 20),),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';

@RoutePage()
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

// class _SplashViewState extends State<SplashView>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     log('SplashView init');

//     // Animation controller
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     );

//     // Smooth scale-in logo animation
//     _scaleAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutBack,
//     );

//     // Smooth fade-in for text
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
//       ),
//     );

//     _controller.forward();

//     // Run login/navigation logic after a few seconds
//     Future.delayed(const Duration(seconds: 3), () async {
//       final user = await locator<AuthLocalDataSource>().getUser();
//       final userProvider = context.read<UserProvider>();
//       final bookingProvider = context.read<BookingProvider>();

//       if (user != null) userProvider.setUser(user);
//       await userProvider.loadUser();

//       if (userProvider.isLoggedIn) {
//         await bookingProvider.fetchBookingsList();
//         context.router.replace(const ClientDashboardRoute());
//       } else {
//         context.router.replace(const OnBoardingRoute());
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Animated logo
//             ScaleTransition(
//               scale: _scaleAnimation,
//               child: Image.asset(
//                 'assets/images/app_logo.png',
//                 color: AppColors.whiteColor,
//                 width: size.width * 0.35,
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Animated text
//             FadeTransition(
//               opacity: _fadeAnimation,
//               child: Text(
//                 "Inspect Connect",
//                 style: TextStyle(
//                   fontSize: 24,
//                   color: AppColors.whiteColor,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _logoBounceAnimation;
  late Animation<Offset> _textBounceAnimation;

  @override
  void initState() {
    super.initState();
    log('SplashView init');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Smooth scale-in logo
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    // Fade-in text
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    // Jumping/bouncing logo effect
    _logoBounceAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween(begin: Offset(0, 0), end: Offset(0, -0.05))
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: Offset(0, -0.05), end: Offset(0, 0))
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
    ]).animate(_controller);

    // Text subtle jump
    _textBounceAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween(begin: Offset(0, 0.2), end: Offset(0, 0))
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: Offset(0, 0), end: Offset(0, 0.05))
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
    ]).animate(_controller);

    _controller.forward();

    // Navigation after delay
    Future.delayed(const Duration(seconds: 3), () async {
      final user = await locator<AuthLocalDataSource>().getUser();
      final userProvider = context.read<UserProvider>();
      final bookingProvider = context.read<BookingProvider>();

      if (user != null) userProvider.setUser(user);
      await userProvider.loadUser();

      if (userProvider.isLoggedIn) {
        await bookingProvider.fetchBookingsList();
        context.router.replace(const ClientDashboardRoute());
      } else {
        context.router.replace(const OnBoardingRoute());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _logoBounceAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/app_logo.png',
                  color: AppColors.whiteColor,
                  width: size.width * 0.2,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SlideTransition(
              position: _textBounceAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "Inspect Connect",
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
