import 'package:flutter/material.dart';
import 'constants.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: acehGold,
  scaffoldBackgroundColor: acehDarkGreen,
  colorScheme: const ColorScheme.dark(
    primary: acehGold,
    secondary: acehGold,
    background: acehDarkGreen,
    surface: acehSurface,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: acehSurface,
    selectedItemColor: acehGold,
    unselectedItemColor: Colors.white54,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: acehSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: acehGold, width: 2),
    ),
    labelStyle: const TextStyle(color: Colors.white70),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: acehGold,
      foregroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
