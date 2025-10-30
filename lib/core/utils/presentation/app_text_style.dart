import 'package:google_fonts/google_fonts.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

TextStyle appTextStyle({
  required double fontSize,
  bool isBold = false,
  Color? colour,
  Color? textDecorationColor,
  FontWeight fontWeight = FontWeight.normal,
  FontStyle fontStyle = FontStyle.normal,
  TextDecoration? textDecoration,
  TextOverflow? textOverflow,
  double height = 0.0,
}) => GoogleFonts.poppins(
  decoration: textDecoration,
  decorationColor: textDecorationColor ?? AppColors.black,

  // overflow: textOverflow,
  fontSize: fontSize,
  color: colour ?? AppColors.black,
  fontStyle: fontStyle,
  height: height,
  fontWeight: isBold == true ? FontWeight.bold : fontWeight,
);
