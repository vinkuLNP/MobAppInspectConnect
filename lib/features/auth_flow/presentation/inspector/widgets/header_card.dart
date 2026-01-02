import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_common_card_container.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/cusotm_painter.dart';

class HeaderCard extends StatelessWidget {
  final Widget child;

  const HeaderCard(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCardContainer(child: child),
        Container(
          color: AppColors.whiteColor,
          child: CustomPaint(painter: TrianglePainter()),
        ),
      ],
    );
  }
}
