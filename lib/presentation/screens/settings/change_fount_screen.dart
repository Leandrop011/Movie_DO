import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChangeFountScreen extends StatelessWidget {

  const ChangeFountScreen({super.key});
  static const String name = 'change_fount_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambio de Fondo'),
        leading: IconButton(
          onPressed: (){
            context.pop();
          }, 
          icon: Icon(Icons.arrow_back_ios_new)
        ),
      ),
      body: Placeholder(),
    );
  }
}