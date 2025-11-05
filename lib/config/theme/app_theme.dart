import 'package:flutter/material.dart';

class AppTheme {
  final bool isdarck;

  AppTheme({
    required this.isdarck
  });


  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,

    brightness: isdarck ? 
                Brightness.dark
                : 
                Brightness.light
    
    
  );
}