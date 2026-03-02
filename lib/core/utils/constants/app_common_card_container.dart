import 'package:flutter/material.dart';

class AppCardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurRadius;
  final Offset? shadowOffset;
  final Color backgroundColor;
  final Color shadowColor;
  final bool showShadow;

  const AppCardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 20,
    this.blurRadius = 12,
    this.shadowOffset = const Offset(0, 6),
    this.backgroundColor = Colors.white,
    this.shadowColor = const Color(0xFFEEEEEE),
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: blurRadius,
                  offset: shadowOffset ?? Offset.zero,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
