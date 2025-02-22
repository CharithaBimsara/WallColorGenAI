import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: Colors.blue, // Define your primary color here
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.blue, // Define your primary color here
        onPrimary: Colors.white, // Define your onPrimary color here
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blue, // Define your button color here
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
