import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ------------Primary colors------------
  static Color primaryColor = const Color.fromARGB(255, 0, 177, 50);
  static Color primaryAccent = const Color.fromARGB(255, 0, 214, 4);
  
  // ------------Secondary colors------------
  static Color secondaryColor = Colors.white;
  static Color secondaryAccent = Colors.grey[100]!;
  
  // ------------Text colors------------
  static Color titleColor = Colors.black87;
  static Color textColor = Colors.black54;
  static Color headerColor = Colors.black87;
  
  // ------------Action colors------------
  static Color likeColor = Colors.green;
  static Color dislikeColor = Colors.red;
  static Color highlightColor = Colors.amber;
}

ThemeData primaryTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.primaryAccent,
    surface: AppColors.secondaryColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.titleColor,
  ),
  
  // ------------theme settings------------
  scaffoldBackgroundColor: AppColors.secondaryAccent,
  useMaterial3: true,
  
  // ------------AppBar theme------------
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: GoogleFonts.kanit(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
  ),
  
  // ------------Text theme------------
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.kanit(
      color: AppColors.titleColor,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
    headlineMedium: GoogleFonts.kanit(
      color: AppColors.titleColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    headlineSmall: GoogleFonts.kanit(
      color: AppColors.titleColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: GoogleFonts.kanit(
      color: AppColors.textColor,
      fontSize: 16,
      letterSpacing: 0.5,
    ),
    bodyMedium: GoogleFonts.kanit(
      color: AppColors.textColor,
      fontSize: 14,
      letterSpacing: 0.25,
    ),
    titleMedium: GoogleFonts.kanit(
      color: AppColors.textColor,
      fontSize: 16,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,
    ),
  ),

  // ------------Card theme------------
  cardTheme: CardTheme(
    color: AppColors.secondaryColor,
    elevation: 2,
    shadowColor: Colors.black26,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
    ),
  ),

  // ------------Button theme------------
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      textStyle: GoogleFonts.kanit(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),

  // ------------Input decoration theme------------
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.secondaryColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.textColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: AppColors.primaryColor,
        width: 2,
      ),
    ),
    labelStyle: GoogleFonts.kanit(
      color: AppColors.textColor,
    ),
    hintStyle: GoogleFonts.kanit(
      color: AppColors.textColor.withOpacity(0.7),
    ),
  ),

  // ------------Snackbar theme------------
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.secondaryColor,
    contentTextStyle: GoogleFonts.kanit(
      color: AppColors.textColor,
      fontSize: 14,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    behavior: SnackBarBehavior.floating,
  ),

  // ------------Dialog theme------------
  dialogTheme: DialogTheme(
    backgroundColor: AppColors.secondaryColor,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    titleTextStyle: GoogleFonts.kanit(
      color: AppColors.titleColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    contentTextStyle: GoogleFonts.kanit(
      color: AppColors.textColor,
      fontSize: 16,
      letterSpacing: 0.25,
    ),
  ),
);
