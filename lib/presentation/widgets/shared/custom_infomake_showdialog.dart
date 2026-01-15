import 'dart:ui';

import 'package:flutter/material.dart';

class CustomInfomakeShowdialog {

  static void infoMake(BuildContext context, String title, String content, List<Widget> actions){
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), 
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: actions,
          
          ),
        );
      },
    );
  }
  
}