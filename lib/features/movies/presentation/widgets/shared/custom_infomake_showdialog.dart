import 'dart:ui';

import 'package:flutter/material.dart';

class CustomInfomakeShowdialog {

  static void infoMake(BuildContext context, String title, String content, List<Widget> actions, TextTheme styleText){
    showDialog(
      
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), 
      builder: (context) {
        return BackdropFilter( //* es como un filtro que se le pone atras del widget

          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.black54,
            title: Text(title, style: TextStyle(color: Colors.white)),
            content: Text(content, style: TextStyle(color: Colors.white)),
            actions: actions,
          
          ),
        );
      },
    );
  }
  
}