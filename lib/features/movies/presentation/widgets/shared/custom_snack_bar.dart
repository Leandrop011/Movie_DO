import 'package:flutter/material.dart';

class CustomSnackBar {
  static void snackBar(BuildContext context, bool isDarck, String message, TextTheme textTheme){
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(//* crea el nuevo
      content: Text(message, style: textTheme.titleSmall?.copyWith(color: isDarck ? Colors.black : Colors.white),),
      behavior: SnackBarBehavior.floating,//* efecto de estar flotando en la pantalla
      backgroundColor: isDarck ?
      Colors.white70
      :
      Colors.black87,
      // action: SnackBarAction(
      //   label: 'Ok', 
      //   onPressed: (){}
      // ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10)
      ),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
