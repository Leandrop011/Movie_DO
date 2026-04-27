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

    textTheme: TextTheme(
      titleLarge: GoogleFonts.googleSans()
        .copyWith(fontSize: 23, fontWeight: FontWeight.bold, letterSpacing: -0.5),
      titleMedium: GoogleFonts.montserrat()
        .copyWith(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.3),
      titleSmall: GoogleFonts.googleSans()
        .copyWith(fontSize: 15, letterSpacing: 0.1),
      bodyLarge: GoogleFonts.googleSans().copyWith(letterSpacing: 0.15),
      bodyMedium: GoogleFonts.saira().copyWith(letterSpacing: 0.1),
      bodySmall: GoogleFonts.roboto(fontWeight: FontWeight.normal, letterSpacing: 0.2),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.montserratAlternates()
            .copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),

    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      labelStyle: GoogleFonts.saira().copyWith(fontSize: 12, letterSpacing: 0.3),
    ),

    cardTheme: CardThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      indicatorColor: colorsTheme[indexColor].withOpacity(0.18),
      backgroundColor: Colors.transparent,
      elevation: 0,
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.montserrat().copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      iconTheme: const WidgetStatePropertyAll(
        IconThemeData(size: 22),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    brightness: isdarck ? Brightness.dark : Brightness.light,
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 75, 74, 74),
      Color.fromARGB(255, 0, 0, 0),
    ],
  );

  static const LinearGradient cinemaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1A2E),
      Color(0xFF0D0D0D),
    ],
  );

  static const LinearGradient movieCardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.5, 1.0],
    colors: [
      Colors.transparent,
      Colors.black87,
    ],
  );

  static const LinearGradient posterOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.55, 1.0],
    colors: [
      Colors.transparent,
      Color(0xCC000000),
    ],
  );
}
