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

  @override
  void dispose() {
    _videoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

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
      body: Stack(
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
                // vertical: 12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        alignment: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

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
                              width: _isClient == null ? 0 : 125,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(
                                    _isClient == null
                                        ? 0
                                        : _isClient!
                                        ? 0
                                        : 30,
                                  ),
                                  right: Radius.circular(
                                    _isClient == null
                                        ? 0
                                        : _isClient!
                                        ? 30
                                        : 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildToggleOption("Client", true),
                              _showSignInText ? SizedBox() : VerticalDivider(),
                              _buildToggleOption("Inspector", false),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: _showSignInText,
                    child: AnimatedOpacity(
                      opacity: _showSignInText ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Column(
                        children: [
                          AppButton(
                            height: 40,
                            buttonBackgroundColor: const Color(0xFF0070F2),
                            text: "Create Account",
                            onTap: () {
                              if (_isClient == true) {
                                context.replaceRoute( ClientSignUpRoute(showBackButton: false));
                              } else {
                                context.replaceRoute( InspectorSignUpRoute());
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textWidget(
                                text: "Already have an account? ",
                                color: AppColors.whiteColor,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.replaceRoute(
                                     ClientSignInRoute(showBackButton: false),
                                  );
                                },
                                child: textWidget(
                                  text: 'Login',
                                  fontWeight: FontWeight.w500,
                                  // fontSize: 18,
                                  textDecorationColor: AppColors.whiteColor,
                                  textDecoration: TextDecoration.underline,

                                  color: AppColors.whiteColor,
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
