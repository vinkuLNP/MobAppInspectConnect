import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/helpers/responsive_ui_helper/responsive_config.dart';
import 'package:inspect_connect/core/utils/presentation/app_assets_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class CommonAuthBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget form;
  final String image;
  final bool showBackButton;
  final Function()? onBackPressed;
  final ResponsiveUiConfig rc;
  const CommonAuthBar({
    required this.title,
    required this.subtitle,
    required this.form,
    required this.image,
    required this.showBackButton,this.onBackPressed,
    required this.rc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: rc.screenHeight * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  top: showBackButton ? 26 : 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showBackButton
                          ? IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          : SizedBox(),
                      SizedBox(height: 4),
                      textWidget(
                        text: subtitle,
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textWidget(
                        text: title,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: form,
            ),
          ],
        ),
      ),
    );
  }
}
