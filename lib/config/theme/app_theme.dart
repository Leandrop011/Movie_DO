import 'package:flutter/material.dart';

final List<Color> colorsTheme = [
  Colors.yellow,
  Colors.blue,
  Colors.purple,
  Colors.purpleAccent,
  Colors.green,
  Colors.greenAccent,
  Colors.orange,
  Colors.red,
  const Color.fromARGB(255, 57, 204, 165)
];

final List<String> colorsThemeNames = [
  "Yellow",
  "Blue",
  "Purple",
  "Purple Accent",
  "Green",
  "Green Accent",
  "Orange",
  "Red",
  "Teal",
];


class AppTheme {
  final bool isdarck;

  AppTheme({
    required this.isdarck
  });


  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 122, 192, 196),

    brightness: isdarck ? 
                Brightness.dark
                : 
                Brightness.light
    
    
  );
}