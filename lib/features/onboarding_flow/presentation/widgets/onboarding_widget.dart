import 'package:clean_architecture/core/utils/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_text_widget.dart';
import 'package:flutter/material.dart';

class OnBoardingWidget extends StatelessWidget {
  const OnBoardingWidget({
    super.key,
    required this.image,
    required this.title,
  });
  final String image, title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image, height: 246, fit: BoxFit.fitWidth),
        const SizedBox(height: 54),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 37),
          child: Column(
            children: [
              textWidget(
                text: title,
                colour: AppColors.themeColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                alignment: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
