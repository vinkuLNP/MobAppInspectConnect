import 'package:clean_architecture/core/utils/constants/app_assets_constants.dart';
import 'package:clean_architecture/core/utils/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/presentation/app_assets_widget.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_text_widget.dart';
import 'package:flutter/material.dart';

Widget appCommonLogoBar({
  required double height,
  MainAxisAlignment alignment = MainAxisAlignment.center,
}) => SizedBox(
  height: height,
  child: Row(
    mainAxisAlignment: alignment,
    children: [
      SizedBox(width: 10),
      imageAsset(image: appLogo),
      SizedBox(width: 10),
      textWidget(
        text: "InspectConnect",
        colour: AppColors.themeColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ],
  ),
);
