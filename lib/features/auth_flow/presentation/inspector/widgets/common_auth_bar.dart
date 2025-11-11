import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/helpers/responsive_ui_helper/responsive_config.dart';
import 'package:inspect_connect/core/utils/presentation/app_assets_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/cusotm_painter.dart';

class InspectorCommonAuthBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget form;
  final Widget headerWidget;
  final Widget bottomSection;

  final String image;
  final bool showBackButton;
  final bool? showSubscriptionBanner;

  final ResponsiveUiConfig rc;

  const InspectorCommonAuthBar({
    required this.title,
    required this.subtitle,
    required this.form,
    required this.headerWidget,
    required this.bottomSection,
    required this.image,
    required this.showBackButton,
    this.showSubscriptionBanner = false,
    required this.rc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: rc.screenWidth,
                  height: rc.screenHeight * 0.35,
                  child: imageAsset(
                    image: image,
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
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                Positioned(
                  left: 24,
                  right: 24,
                  top: showBackButton ? 40 : showSubscriptionBanner! ? 40 : 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showBackButton)
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                      const SizedBox(height: 8),
                      textWidget(
                        text: subtitle,
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textWidget(
                        text: title,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),

                      SizedBox(
                        height: showSubscriptionBanner == true ? 0 : 110,
                      ),
                      showSubscriptionBanner == true
                          ? SizedBox()
                          : Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(15.0),
                              child: headerWidget,
                            ),
                      showSubscriptionBanner == true
                          ? SizedBox()
                          : Container(
                              color: AppColors.whiteColor,
                              child: CustomPaint(painter: TrianglePainter()),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 14),
              child: form,
            ),
          ],
        ),
      ),

      bottomNavigationBar: showSubscriptionBanner!
          ? null
          : SafeArea(child: bottomSection),
    );
  }
}