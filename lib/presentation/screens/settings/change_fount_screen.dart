import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/presentation/providers/config/isdarck_provider.dart';
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
      body: _ViewButtonFount(),
    );
  }
}

class _ViewButtonFount extends ConsumerStatefulWidget {
  
  @override
  ConsumerState<_ViewButtonFount> createState() => _ViewButtonFountState();
}

class _ViewButtonFountState extends ConsumerState<_ViewButtonFount> {
  
  double widthV = 200;
  double heigthV = 100;
  double radiusV = 20;
  double borderW = 10;
  Color colorV = Colors.blue;
  //* Funcion que cambia los valores de diseno del animatedcontainer randomicamente
  void changeInfo(){
    Random random = Random();
    double widthNew = random.nextInt(270) + 220;
    double heigthNew = random.nextInt(400) + 220;
    double radiusNew = random.nextInt(100) + 20;
    double borderNew = random.nextInt(17) + 9;
    Color colorNew = Color.fromARGB(
      random.nextInt(255) + 1, 
      random.nextInt(255) + 1, 
      random.nextInt(255) + 1, 
      random.nextInt(255) + 1
    );
    setState(() {
      widthV = widthNew;
      heigthV = heigthNew;
      radiusV = radiusNew;
      borderW = borderNew;
      colorV = colorNew;
    });
  } 
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final isDarck = ref.watch(isdarckProvider);

    return Center(
      child: GestureDetector(
        onTap: () {
          changeInfo();
          ref.read(isdarckProvider.notifier).setDark(!isDarck);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          width: widthV,
          height: heigthV,
          decoration: BoxDecoration(
            color: colorV,
            borderRadius: BorderRadius.circular(radiusV),
            border: Border.all(
              width: borderW, 
              color: isDarck?
             Colors.white
             :
             Colors.black
             )
          ),
          child: Center(child: Text('TAP HERE', style: style.titleMedium,)),
        ),
      ),
    );
  }
}