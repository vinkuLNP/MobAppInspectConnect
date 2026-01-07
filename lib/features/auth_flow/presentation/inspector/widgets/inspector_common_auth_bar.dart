import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_common_card_container.dart';
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
            LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 335 / 230,
                      // 375/280
                      child: imageAsset(
                        image: image,
                        width: rc.screenWidth,
                        height: rc.screenHeight * 0.5,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: rc.setWidth(20),
                          vertical: rc.setHeight(40),
                        ),
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
                            if (!showSubscriptionBanner!) ...[
                              SizedBox(height: rc.setHeight(20)),
                              AppCardContainer(child: headerWidget),
                              CustomPaint(painter: TrianglePainter()),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
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
