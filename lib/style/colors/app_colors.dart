import 'package:flutter/material.dart';

enum AppColors {
  bgGreen("BgGreen", Color(0xFF556B2F)),
  bgSoftGreen("BgSoftGreen", Color(0xFFEAF1DD)),
  bgWhite("BgWhite", Color(0xFFFFFFFF)),
  bgBlue("BgBlue", Color(0xFFDDECF2)),
  bgCream("BgCream", Color(0xFFFFF3D6)),
  bgGrey("BgGrey", Color(0xFFE8E8E8)),

  btnTextGreen("BtnTextGreen", Color(0xFF5E7F0F)),
  btnTextWhite("BtnTextWhite", Color(0xFFFFFFFF)),
  btnWhite("BtnWhite", Color(0xFFEAF2DD)),
  btnGreen("BtnGreen", Color(0xFF556B2F)),

  textBlack("TextBlack", Color(0xFF1A1A19)),
  textGrey("TextGrey", Color(0xFF6A6A6A)),
  textError("TextError", Color(0xFFF44336)),
  textWhite("TextWhite", Color(0xFFEAF2DD)),
  textGreen("TextGreen", Color(0xFF556B2F)),

  textTaskBlack("TextTaskBlack", Color(0xFF383838)),
  textTaskRed("TextTaskRed", Color(0xFFF2656F));

  const AppColors(this.name, this.colors);
  final String name;
  final Color colors;
}
