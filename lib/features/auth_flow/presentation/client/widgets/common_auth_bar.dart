import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/helpers/responsive_ui_helper/responsive_config.dart';
import 'package:inspect_connect/core/utils/presentation/app_assets_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_logo_bar.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class CommonAuthBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget form;
  final String image;
  final bool showBackButton;
  final ResponsiveUiConfig rc;
  const CommonAuthBar({
    required this.title,
    required this.subtitle,
    required this.form,
    required this.image,
    required this.showBackButton,
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
                  top: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // appCommonLogoBar(height: 50),
                 showBackButton ?      IconButton(icon: Icon( Icons.arrow_back),color: Colors.white,onPressed: (){
                        Navigator.pop(context);
                      },) : SizedBox(),
                      SizedBox(height: 10,),
                       textWidget( 
                        text: subtitle,
                        fontSize: 14,
                        colour: Colors.white70,
                      ),
                      // const SizedBox(height: 2),

                      textWidget(
                        text: title,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        colour: Colors.white,
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
