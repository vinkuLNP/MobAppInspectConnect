import 'package:inspect_connect/core/utils/presentation/app_assets_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
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
  final Function()? onTap;
  final FontWeight fontWeight;
  final Icon? icon;
  final bool isElevation, isSvg, isBorder, isLoading, isDisabled, showIcon;

  const AppButton({
    super.key,
    this.width = 500,
    this.height = 50,
    this.borderRadius = 5,
    this.fontWeight = FontWeight.w500,
    this.textColor = AppColors.whiteColor,
    required this.text,
    this.image = "",
    this.imageSize = 15,
    this.pHorizontal = 0,
    required this.onTap,
    this.isElevation = false,
    this.isSvg = false,
    this.isBorder = false,
    this.fontSize = 14,
    this.iconLeftMargin = 0,
    this.borderColor = AppColors.whiteColor,
    this.buttonBackgroundColor = AppColors.authThemeColor,
    this.isLoading = false,
    this.isDisabled = false,
    this.showIcon = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = !(isLoading || isDisabled);

    return GestureDetector(
      onTap: isInteractive ? onTap : null,
      behavior: HitTestBehavior.translucent,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: isInteractive ? 1.0 : 0.8,
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
          child: isLoading
              ? SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    color: textColor,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
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
                    showIcon
                        ? Container(
                            margin: EdgeInsets.only(right: iconLeftMargin),
                            child: icon!,
                          )
                        : SizedBox(),

                    image == "" || text.isEmpty || !showIcon
                        ? const SizedBox()
                        : const SizedBox(width: 8),
                    text.isNotEmpty
                        ? textWidget(
                            text: text,
                            color: textColor,
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                          )
                        : const SizedBox(),
                  ],
                ),
        ),
      ),
    );
  }
}
