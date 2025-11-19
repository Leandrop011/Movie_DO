import 'package:flutter/material.dart';

class AppTheme {
  final bool isdarck;

  AppTheme({
    required this.isdarck
  });


  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 2, 69, 177),

    brightness: isdarck ? 
                Brightness.dark
                : 
                Brightness.light
    
    
  );
}