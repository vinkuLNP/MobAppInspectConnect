import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_assets_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:flutter/material.dart';

Widget appCommonLogoBar({
  required double height,
  MainAxisAlignment alignment = MainAxisAlignment.start,
}) => SizedBox(
  height: height,
  child: Row(
    mainAxisAlignment: alignment,
    children: [
      imageAsset(image: appLogo,color: AppColors.whiteColor,height: 30,width: 30,),
      SizedBox(width: 10),
      textWidget(
        text: "InspectConnect",
        color: AppColors.whiteColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ],
  ),
);
