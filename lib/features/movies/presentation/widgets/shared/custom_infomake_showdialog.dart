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
            backgroundColor: Colors.black87,
            title: Text(title, style: styleText.titleLarge?.copyWith(color: Colors.white,)),
            content: Text(content, style: styleText.titleMedium?.copyWith(color: Colors.white, fontSize: 13, fontWeight: FontWeight.normal)),
            actions: actions,
          
          ),
        );
      },
    );
  }
  
}