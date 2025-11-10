import 'package:flutter/material.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_assets_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/subscription_widget.dart';
import 'package:inspect_connect/features/inspector_flow/providers/inspector_main_provider.dart';

class SubscriptionScreen extends StatelessWidget {
  final InspectorDashboardProvider provider;

  const SubscriptionScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: Stack(
            children: [
              SizedBox(height: rc.screenHeight),
              SizedBox(
                width: rc.screenWidth,
                height: rc.screenHeight * 0.35,
                child: imageAsset(
                  image: finalImage,
                  width: rc.screenWidth,
                  height: rc.screenHeight * 0.5,
                  boxFit: BoxFit.cover,
                ),
              ),

              Container(
                width: rc.screenWidth,
                height: rc.screenHeight * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  ),
                ),
              ),

              Positioned(
                left: 24,
                right: 24,
                top: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    textWidget(
                      text: 'Choose Your Subscription Plan',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textWidget(
                      text: "Subscription Plans",
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),

                    SubscriptionCarousel(
                      plans: provider.subscriptionPlans,
                      onSubscribe: (plan) {
                        provider.fetchUserSubscriptionModel(
                          context: context,
                          plan: plan,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
