import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final List<Color> colorsTheme = [
  // Colors.yellow,
  Colors.blue,
  // Colors.purple,
  // Colors.purpleAccent,
  // Colors.green,
  // Colors.greenAccent,
  // Colors.orange,
  // Colors.red,
  // const Color.fromARGB(255, 57, 204, 165)
];

// final List<String> colorsThemeNames = [
//   "Yellow",
//   "Blue",
//   "Purple",
//   "Purple Accent",
//   "Green",
//   "Green Accent",
//   "Orange",
//   "Red",
//   "Teal",
// ];


class AppTheme {
  final bool isdarck;
  final int indexColor;
  AppTheme({
    required this.isdarck,  
    required this.indexColor
  });


  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: colorsTheme[indexColor],

    // * Tema de texto
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 23, fontWeight: FontWeight.bold ),
      titleMedium: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 18, fontWeight: FontWeight.bold ),
      titleSmall: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 15 )
    ),

    // * Botones
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.montserratAlternates()
            .copyWith(fontWeight: FontWeight.w700)
          )
      )
    ),

    brightness: isdarck ? 
                Brightness.dark
                : 
                Brightness.light
    
    
  );
}