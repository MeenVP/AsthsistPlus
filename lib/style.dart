import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static const Color primaryColor = Color(0xFF4B39EF);
  static const Color primaryColorLight = Color(0xFFa9a1f7);
  static const Color secondaryColor = Color(0xFF1976D2);
  static const Color tertiaryColor = Color(0xFF39D2C0);
  static const Color primaryText = Color(0xFF000000);
  static const Color secondaryText = Color(0xFF8b97a2);
  static const Color tertiaryText = Color(0xFFFFFFFF);
  static const Color primaryBackground = Color(0xFFf1f4f8);
  static const Color secondaryBackground = Color(0xFFFFFFFF);

  static const Color accent1 = Color(0xFF616161);
  static const Color accent2 = Color(0xFF757575);
  static const Color accent3 = Color(0xFFe0e0e0);
  static const Color accent4 = Color(0xFFeeeeee);
  static const Color success = Color(0xFF0EC863);
  static const Color danger = Color(0xFFF44336);
  static const Color warning = Color(0xFFf99e2f);
  static const Color warning2 = Color(0xfff9d72f);
  static const Color heartrate = Color(0xffFB6C81);
  static const Color medication = Color(0xff64C68F);
  static const Color pef = Color(0xff1976D2);
  static const Color weather = Color(0xffe8a548);
  static const Color air = Color(0xff757575);
  static const Color act = Color(0xFF89CDE5);
  static const Color dangerSecondary = Color(0xFFF69894);
  static const Color warningSecondary = Color(0xfff5c695);
  static const Color safeSecondary = Color(0xFF7AE0A6);
}

Text primaryTileText(String input) {
  return Text(
    input,
    style: GoogleFonts.outfit(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: Style.primaryText,
      ),
    ),
  );
}

Text secondaryTileText(String input) {
  return Text(
    input,
    style: GoogleFonts.outfit(
      textStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: Style.accent1,
      ),
    ),
  );
}
