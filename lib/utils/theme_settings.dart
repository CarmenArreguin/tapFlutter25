import 'package:flutter/material.dart';

class ThemeSettings {
  
  static ThemeData customeTheme(){
    final theme = ThemeData.light().copyWith(
      colorScheme: const ColorScheme(
        brightness: Brightness.light, 
        primary: Color.fromARGB(255, 168, 162, 109), 
        onPrimary: Colors.red, 
        secondary: Colors.red, 
        onSecondary: Colors.red, 
        error: Colors.red, 
        onError: Colors.red, 
        surface: Colors.red, 
        onSurface: Colors.red
      )
    );
    return theme;
  }

  
}