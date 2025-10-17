import 'package:clean_architecture/core/utils/presentation/app_assets_widget.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_text_widget.dart';
import 'package:clean_architecture/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final double width,
      height,
      borderRadius,
      fontSize,
      imageSize,
      pHorizontal,
      iconLeftMargin;
  final Color textColor, buttonBackgroundColor, borderColor;
  final String text, image;
  final Function() onTap;
  final FontWeight fontWeight;
  final bool isElevation, isSvg, isBorder;

  const AppButton({
    super.key,
    this.width = 500,
    this.height = 60,
    this.borderRadius = 15,
    this.fontWeight = FontWeight.bold,
    this.textColor = AppColors.whiteColor,
    required this.text,
    this.image = "",
    this.imageSize = 15,
    this.pHorizontal = 0,
    required this.onTap,
    this.isElevation = false,
    this.isSvg = false,
    this.isBorder = false,
    this.fontSize = 16,
    this.iconLeftMargin = 0,
    this.borderColor = AppColors.whiteColor,
    this.buttonBackgroundColor = AppColors.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: width == 0 ? null : width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: pHorizontal),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isBorder
              ? null
              : buttonBackgroundColor == AppColors.transparent
              ? null
              : buttonBackgroundColor,

          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: isElevation
              ? kElevationToShadow[1]
              : kElevationToShadow[0],
          border: isBorder ? Border.all(color: borderColor, width: 1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image == ""
                ? const SizedBox()
                : Container(
                    margin: EdgeInsets.only(left: iconLeftMargin),
                    child: isSvg
                        ? svgAsset(
                            image: image,
                            width: imageSize,
                            height: imageSize,
                          )
                        : imageAsset(
                            image: image,
                            width: imageSize,
                            height: imageSize,
                          ),
                  ),
            image == "" || text.isEmpty
                ? const SizedBox()
                : const SizedBox(width: 8),
            text.isNotEmpty
                ? textWidget(
                    text: text,
                    colour: textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
