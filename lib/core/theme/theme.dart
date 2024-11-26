import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class AppTheme {
  static final light = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: bluishClr,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    scaffoldBackgroundColor: Colors.black54,
    primaryColor: Colors.blueAccent,
    brightness: Brightness.dark,
  );

 static TextStyle get subHeadingStyle {
    return GoogleFonts.lato(
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black54,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  static TextStyle get headingStyle {
    return GoogleFonts.lato(
      textStyle: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
