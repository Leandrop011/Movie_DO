import 'package:flutter/material.dart';

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