import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final List<Color> colorsTheme = [
  Colors.blue,
  Colors.purpleAccent,
  Colors.green,
  Colors.orange,
  Colors.red,
  const Color.fromARGB(255, 57, 204, 165),
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.amber,
  Colors.indigo,
];

final List<String> colorsNameTheme = [
  'Azul',
  'Morado',
  'Verde',
  'Naranja',
  'Rojo',
  'Turquesa',
  'Rosa',
  'Verde Azulado',
  'Cian',
  'Ámbar',
  'Índigo',
];


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

    // * Tema de texto title
    textTheme: TextTheme(
      titleLarge: GoogleFonts.googleSans()
        .copyWith( fontSize: 23, fontWeight: FontWeight.bold ), 
      titleMedium: GoogleFonts.montserrat()
        .copyWith( fontSize: 18, fontWeight: FontWeight.bold ),
      titleSmall: GoogleFonts.googleSans()
        .copyWith( fontSize: 15, ),
    // * Tema de texto body
      bodyLarge: GoogleFonts.googleSans(),
      bodyMedium: GoogleFonts.saira(),
      bodySmall: GoogleFonts.roboto(fontWeight: FontWeight.normal)
    

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
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 75, 74, 74),
      Color.fromARGB(255, 0, 0, 0),
    ],
  );
}