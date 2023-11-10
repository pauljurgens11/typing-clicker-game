import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Palette {
  static const Color primaryColor = Color(0xFF007ACC);
  static const Color accentColor = Color(0xFFFF5722);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static TextStyle textToTypeStyle(
          {Color? color,
          double? fontSize,
          FontWeight? fontWeight,
          TextDecoration? decoration}) =>
      GoogleFonts.ubuntuMono(
        textStyle: TextStyle(
          color: color ?? black,
          fontSize: fontSize ?? 16.0,
          fontWeight: fontWeight ?? FontWeight.normal,
          decoration: decoration ?? TextDecoration.none,
        ),
      );
}
