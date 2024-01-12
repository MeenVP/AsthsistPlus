import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static const Color primaryColor = Color(0xFF4B39EF);
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
