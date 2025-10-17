import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/basecomponents/base_responsive_widget.dart';
import 'package:clean_architecture/core/utils/auto_router_setup/auto_router.dart';
import 'package:clean_architecture/core/utils/constants/app_assets_constants.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_button.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_logo_bar.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_text_widget.dart';
import 'package:clean_architecture/features/onboarding_flow/presentation/onboarding_view_model.dart';
import 'package:clean_architecture/features/onboarding_flow/presentation/widgets/onboarding_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  List<String> get subs => const [
    "Join a Network that Connects You to Quality Projects.\n\nWe've built the most comprehensive platform for connecting quality inspections with quality projects.",
    "Submit your project inspection request.\n\nGet matched with certified inspectors near you.\n\nTrack and communicate in real-time.\n\nPay securely after inspection is complete.",
    "Apply with your certifications (ICC, ACI, etc.).\n\nChoose your service areas.\n\nReceive job alerts & accept requests.\n\nGet paid instantly after completing inspections.",
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnBoardingProvider()..init(),
      child: BaseResponsiveWidget(
        initializeConfig: true,
        buildWidget: (ctx, rc, app) {
          final provider = ctx.watch<OnBoardingProvider>();

          return DefaultTabController(
            length: 3,
            initialIndex: provider.currentPage,
            child: Builder(
              builder: (ctx) {
                final tabController = DefaultTabController.of(ctx);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (tabController != null &&
                      tabController.index != provider.currentPage) {
                    tabController.index = provider.currentPage;
                  }
                });

                return Scaffold(
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        appCommonLogoBar(height: rc.screenHeight * 0.10),

                        SizedBox(
                          height: 360,
                          child: PageView(
                            controller: provider.pageController,
                            onPageChanged: provider.onPageChanged,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: const [
                              OnBoardingWidget(
                                image: onboardingFirstImg,
                                title: "Welcome to Inspect Connect",
                              ),
                              OnBoardingWidget(
                                image: onboardingSecondImg,
                                title: "How it works? — Client",
                              ),
                              OnBoardingWidget(
                                image: onboardingThirdImg,
                                title: "How it works? — Inspector",
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 140,
                                child: textWidget(
                                  text: subs[provider.currentPage],
                                  alignment: provider.currentPage == 0
                                      ? TextAlign.center
                                      : TextAlign.start,
                                ),
                              ),

                              const SizedBox(height: 20),

                              TabPageSelector(
                                controller: DefaultTabController.of(ctx),
                                selectedColor: app.appTheme.primaryColor,
                              ),

                              const SizedBox(height: 40),

                              textWidget(
                                text: "Sign In As",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),

                              const SizedBox(height: 20),

                              AppButton(
                                text: "CLIENT",
                                onTap: () {
                                  context.replaceRoute(
                                    const ClientSignInRoute(),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),

                              AppButton(text: "INSPECTOR", onTap: () {}),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
