// import 'package:auto_route/auto_route.dart';
// import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
// import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
// import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
// import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
// import 'package:inspect_connect/core/utils/presentation/app_common_logo_bar.dart';
// import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
// import 'package:inspect_connect/features/onboarding_flow/presentation/onboarding_view_model.dart';
// import 'package:inspect_connect/features/onboarding_flow/presentation/widgets/onboarding_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// @RoutePage()
// class OnBoardingPage extends StatelessWidget {
//   const OnBoardingPage({super.key});

//   List<String> get subs => const [
//     "Join a Network that Connects You to Quality Projects.\n\nWe've built the most comprehensive platform for connecting quality inspections with quality projects.",
//     "Submit your project inspection request.\n\nGet matched with certified inspectors near you.\n\nTrack and communicate in real-time.\n\nPay securely after inspection is complete.",
//     "Apply with your certifications (ICC, ACI, etc.).\n\nChoose your service areas.\n\nReceive job alerts & accept requests.\n\nGet paid instantly after completing inspections.",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => OnBoardingProvider()..init(),
//       child: BaseResponsiveWidget(
//         initializeConfig: true,
//         buildWidget: (ctx, rc, app) {
//           final provider = ctx.watch<OnBoardingProvider>();

//           return DefaultTabController(
//             length: 3,
//             initialIndex: provider.currentPage,
//             child: Builder(
//               builder: (ctx) {
//                 final tabController = DefaultTabController.of(ctx);
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   if (
//                       tabController.index != provider.currentPage) {
//                     tabController.index = provider.currentPage;
//                   }
//                 });

//                 return Scaffold(
//                   body: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(top: 20),
//                           child: appCommonLogoBar(
//                             height: rc.screenHeight * 0.08,
//                             alignment: MainAxisAlignment.start,
//                           ),
//                         ),

//                         SizedBox(
//                           height: 500,
//                           child: PageView(
//                             controller: provider.pageController,
//                             onPageChanged: provider.onPageChanged,
//                             physics: const BouncingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             children: [
//                               OnBoardingWidget(
//                                 image: onboardingFirstImg,
//                                 title: "Welcome to Inspect Connect",
//                                 subTitle: subs[0],
//                               ),
//                               OnBoardingWidget(
//                                 image: onboardingSecondImg,
//                                 title: "How it works? — Client",
//                                 subTitle: subs[1],
//                               ),
//                               OnBoardingWidget(
//                                 image: onboardingThirdImg,
//                                 title: "How it works? — Inspector",
//                                 subTitle: subs[2],
//                               ),
//                             ],
//                           ),
//                         ),

//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 24),
//                           child: Column(
//                             children: [
//                               const SizedBox(height: 10),

//                               TabPageSelector(
//                                 controller: DefaultTabController.of(ctx),
//                                 selectedColor: app.appTheme.primaryColor,
//                               ),

//                               const SizedBox(height: 20),

//                               textWidget(
//                                 text: "Sign In As",
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),

//                               const SizedBox(height: 20),

//                               AppButton(
//                                 text: "CLIENT",
//                                 onTap: () {
//                                   context.replaceRoute(
//                                     const ClientSignInRoute(),
//                                   );
//                                 },
//                               ),
//                               const SizedBox(height: 12),

//                               AppButton(
//                                 text: "INSPECTOR",
//                                 onTap: () {
//                                   context.replaceRoute(
//                                     const ClientSignInRoute(),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

@RoutePage()
class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoController;
  bool? _isClient;
  bool _showSignInText = false;

  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _loadVideo('assets/videos/onboarding_video.mp4');
  }

  Future<void> _loadVideo(String assetPath) async {
    _videoController = VideoPlayerController.asset(assetPath);
    await _videoController.initialize();
    _videoController
      ..setLooping(true)
      ..setVolume(0)
      ..play();
    if (mounted) setState(() {});
    _fadeController.forward();
  }

  Future<void> _switchVideo(bool? client) async {
    _fadeController.reverse();
    await Future.delayed(const Duration(milliseconds: 300));

    String newVideo = 'assets/videos/onboarding_video.mp4';
    if (client == true) newVideo = 'assets/videos/onboarding_video.mp4';
    if (client == false) newVideo = 'assets/videos/onboarding_video.mp4';

    await _videoController.pause();
    await _loadVideo(newVideo);
  }

  @override
  void dispose() {
    _videoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Widget _buildToggleOption(String title, bool clientOption) {
  //   final isSelected = _isClient == clientOption;
  //   return Expanded(
  //     child: GestureDetector(
  //       behavior: HitTestBehavior.opaque,
  //       onTap: () {
  //         if (_isClient == clientOption) return;
  //         setState(() {
  //           _isClient = clientOption;
  //           _showSignInText = true;
  //         });
  //         // _switchVideo(clientOption);
  //       },
  //       child: Container(
  //         alignment: Alignment.center, // center the text
  //         child: AnimatedDefaultTextStyle(
  //           duration: const Duration(milliseconds: 250),
  //           style: TextStyle(
  //             color: isSelected ? Colors.black : Colors.white70,
  //             fontWeight: FontWeight.w600,
  //             fontSize: 13.5,
  //             letterSpacing: 0.4,
  //           ),
  //           child: Text(title),
  //         ),
  //       ),
  //     ),
  //   );
  // }
Widget _buildToggleOption(String title, bool clientOption) {
  final isSelected = _isClient == clientOption;
  return Expanded(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_isClient == clientOption) return;
        setState(() {
          _isClient = clientOption;
          _showSignInText = true;
        });
      },
      child: Container(
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: "Roboto",
          ),
          child: Text(title),
        ),
      ),
    ),
  );
}

  Alignment _getVideoAlignment() {
    if (_isClient == true) return Alignment.centerLeft;
    if (_isClient == false) return Alignment.centerRight;
    return Alignment.center;
  }

  String _getHeadline() {
    if (_isClient == true) {
      return "Connecting Quality Inspections\nwith Quality Projects\nfor Every Build that Matters";
    } else if (_isClient == false) {
      return "Join a Trusted Network\nof Inspectors Connecting\nyou with Quality Opportunities";
    } else {
      return "Welcome to Inspect Connect - \nWhere Projects and Inspectors\nMeet to Build Better Together";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body:
          //       Stack(
          //   children: [
          //     // Video
          //     Positioned(
          //       top: 0,
          //       left: 0,
          //       right: 0,
          //       height: size.height*0.85,
          //       child: _videoController.value.isInitialized
          //           ? FadeTransition(
          //               opacity: _fadeController,
          //               child: FittedBox(
          //                 fit: BoxFit.cover,
          //                 child: SizedBox(
          //                   width: _videoController.value.size.width,
          //                   height: _videoController.value.size.height,
          //                   child: VideoPlayer(_videoController),
          //                 ),
          //               ),
          //             )
          //           : const Center(
          //               child: CircularProgressIndicator(color: Colors.white),
          //             ),
          //     ),
          //     // Top overlay
          //     Align(
          //       alignment: Alignment.topCenter,
          //       child: Container(
          //         height: size.height * 0.3,
          //         decoration: BoxDecoration(
          //           gradient: LinearGradient(
          //             begin: Alignment.topCenter,
          //             end: Alignment.bottomCenter,
          //             colors: [
          //               Colors.black,
          //               Colors.black.withOpacity(0.0),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     // Bottom overlay
          //     Align(
          //       alignment: Alignment.bottomCenter,
          //       child: Container(
          //         height: size.height ,
          //         decoration: BoxDecoration(
          //           gradient: LinearGradient(
          //             begin: Alignment.topCenter,
          //             end: Alignment.bottomCenter,
          //             stops: const [0.45, 0.6, 1.0],
          //             colors: [
          //               Colors.black.withOpacity(0.0),
          //               Colors.black.withOpacity(0.85),
          //               Colors.black,
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     // SafeArea content (text, buttons, toggles)
          //     SafeArea(
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //               const Spacer(),
          //             AnimatedSwitcher(
          //               duration: const Duration(milliseconds: 600),
          //               transitionBuilder: (child, animation) => FadeTransition(
          //                 opacity: animation,
          //                 child: SlideTransition(
          //                   position: Tween<Offset>(
          //                     begin: const Offset(0, 0.2),
          //                     end: Offset.zero,
          //                   ).animate(animation),
          //                   child: child,
          //                 ),
          //               ),
          //               child: Padding(
          //                 key: ValueKey(_getHeadline()),
          //                 padding: const EdgeInsets.symmetric(horizontal: 12),
          //                 child: textWidget(
          //                   text: _getHeadline(),
          //                   colour: Colors.white,
          //                   fontSize: 24,
          //                   fontWeight: FontWeight.bold,
          //                   alignment: TextAlign.center,
          //                 ),
          //               ),
          //             ),
          //             Column(
          //               children: [
          //                 Container(
          //                   height: 42,
          //                   width: 250,
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(30),
          //                     border: Border.all(
          //                       color: Colors.white,
          //                       width: 1.2,
          //                     ),
          //                      boxShadow: [
          //       BoxShadow(
          //         // color: Colors.white.withOpacity(0.05),
          //         blurRadius: 8,
          //         offset: const Offset(0, 2),
          //       ),
          //     ],
          //                   ),
          //                   child: Stack(
          //                     children: [
          //                       AnimatedAlign(
          //                         alignment: _isClient == null
          //                             ? Alignment.center
          //                             : _isClient!
          //                                 ? Alignment.centerLeft
          //                                 : Alignment.centerRight,
          //                         duration: const Duration(milliseconds: 300),
          //                         curve: Curves.easeInOut,
          //                         child: AnimatedContainer(
          //                           duration: const Duration(milliseconds: 300),
          //                           curve: Curves.easeInOut,
          //                           width: _isClient == null ? 0 : 120,
          //                           height: 38,
          //                           decoration: BoxDecoration(
          //                             color: Colors.white,
          //                             borderRadius: BorderRadius.circular(25),
          //                              boxShadow: [
          //               BoxShadow(
          //                 color: Colors.white.withOpacity(0.4),
          //                 // blurRadius: 10,
          //                 // offset: const Offset(0, 0),
          //               ),
          //             ],
          //                           ),
          //                         ),
          //                       ),
          //                       Row(
          //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           _buildToggleOption("Client", true),
          //                           _showSignInText ? SizedBox():  VerticalDivider(),
          //                           _buildToggleOption("Inspector", false),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 const SizedBox(height: 40),
          //                 // Create account / Sign in
          //                 Visibility(
          //                   visible: _showSignInText,
          //                   child: AnimatedOpacity(
          //                     opacity: _showSignInText ? 1.0 : 0.0,
          //                     duration: const Duration(milliseconds: 500),
          //                     child: Column(
          //                       children: [
          //                         AppButton(
          //                           height: 50,
          //                           text: "Create Account",
          //                           onTap: () {
          //                             context.replaceRoute(const ClientSignUpRoute());
          //                           },
          //                         ),
          //                         const SizedBox(height: 12),
          //                         Row(
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [
          //                             textWidget(
          //                               text: "Already have an account?",
          //                               colour: AppColors.whiteColor,
          //                             ),
          //                             GestureDetector(
          //                               onTap: () {
          //                                 context.pushRoute(const ClientSignInRoute());
          //                               },
          //                               child: textWidget(
          //                                 text: 'Sign In',
          //                                 fontWeight: FontWeight.w500,
          //                                 fontSize: 18,
          //                                 textDecoration: TextDecoration.underline,
          //                                 textDecorationColor: AppColors.whiteColor,
          //                                 colour: AppColors.whiteColor,
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // )
          Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: size.height * 0.85,
                child: AnimatedAlign(
                  alignment: _getVideoAlignment(),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  child: _videoController.value.isInitialized
                      ? FadeTransition(
                          opacity: _fadeController,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _videoController.value.size.width,
                              height: _videoController.value.size.height,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.black.withOpacity(0.0)],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.45, 0.6, 1.0],
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.85),
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Logo
                      // appCommonLogoBar(
                      //   height: 60,
                      //   alignment: MainAxisAlignment.start,
                      // ),
                      const Spacer(),

                      AnimatedSwitcher(
                        
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: Padding(
                          key: ValueKey(_getHeadline()),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: textWidget(
                            text: _getHeadline(),
                            colour: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            alignment: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      



Container(
  height: 42,
  width: 250,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    border: Border.all(color: Colors.white, width: 1.2),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: Stack(
      children: [
        // Highlight for selected option
        AnimatedAlign(
          alignment: _isClient == null
              ? Alignment.center
              : _isClient!
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _isClient == null ? 0 : 125, // exactly half of 250
            height: 42, // full height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(_isClient == null
              ? 0
              : _isClient!
                  ? 0
                  : 30), right: Radius.circular(_isClient == null
              ? 0
              : _isClient!
                  ? 30
                  : 0))
            ),
          ),
        ),

        // Option texts
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildToggleOption("Client", true),
            _showSignInText
                                    ? SizedBox()
                                    : VerticalDivider(),
            _buildToggleOption("Inspector", false),
          ],
        ),
      ],
    ),
  ),
),


                      /*Container(
                        height: 42,
                        width: 250,
                        decoration: BoxDecoration(
                          // color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              // color: Colors.white.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            AnimatedAlign(
                              alignment: _isClient == null
                                  ? Alignment.center
                                  : _isClient!
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                width: _isClient == null ? 0 : 120,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.4),
                                      // blurRadius: 10,
                                      // offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                _buildToggleOption("Client", true),
                                _showSignInText
                                    ? SizedBox()
                                    : VerticalDivider(),
                                _buildToggleOption("Inspector", false),
                              ],
                            ),
                          ],
                        ),
                      ),
                      */
                      const SizedBox(height: 32),
                      Visibility(
                        visible: _showSignInText,
                        child: AnimatedOpacity(
                          opacity: _showSignInText ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            children: [
                              AppButton(
                                height: 50,
                                buttonBackgroundColor: const Color(0xFF0070F2),
                                text: "Create Account",
                                onTap: () {
                                  if (_isClient == true) {
                                    context.replaceRoute(
                                      const ClientSignUpRoute(),
                                    );
                                  } else {
                                    context.replaceRoute(
                                      const ClientSignUpRoute(),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 32),

                              //  textWidget(
                              //   text:
                              //       "Sign in as ${_isClient == true ? "Client" : "Inspector"}",
                              //   colour: Colors.white,
                              //   fontSize: 16,
                              //   fontWeight: FontWeight.w500,
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  textWidget(
                                    text: "Already have an account? ",
                                    colour: AppColors.whiteColor,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      context.pushRoute(
                                        const ClientSignInRoute(),
                                      );
                                    },
                                    child: textWidget(
                                      text: 'Login',
                                      fontWeight: FontWeight.w500,
                                      // fontSize: 18,
                                      textDecorationColor: AppColors.whiteColor,
                                      textDecoration: TextDecoration.underline,

                                      colour: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
