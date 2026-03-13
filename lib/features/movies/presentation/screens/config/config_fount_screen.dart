import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
import 'package:movies_app/features/features.dart';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class ConfigFountScreen extends ConsumerStatefulWidget {
  const ConfigFountScreen({super.key});

  @override
  ConsumerState<ConfigFountScreen> createState() => _ConfigFountScreenState();
}

class _ConfigFountScreenState extends ConsumerState<ConfigFountScreen> {
  double widthNew = 300;
  double heigthNew = 300;

  void changeDimensions(Size size){
    Random random = Random();

    double widthChange = size.width * (0.6 + random.nextDouble() * 0.1);
    double heithChange = size.height * (0.5 + random.nextDouble() * 0.1);

    setState(() {
      widthNew = widthChange;
      heigthNew = heithChange;
    });
  }

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final fount = ref.watch(isdarckProvider).fount;
    final colorTheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Fondo'),
        actions: [
          IconButton(
            onPressed: (){
              CustomInfomakeShowdialog.infoMake(
                context, 
                'Informacion', 
                'Esta opcion te permite cambiar el fondo de la aplicacion, puedes elegir entre un fondo oscuro o claro, simplemente tocando el boton.', 
                [
                  FilledButton(
                    onPressed: (){
                      context.pop();
                    }, 
                    child: Text('Ok')
                  )
                ], 
                textTheme
              );
            }, 
            icon: Icon(Icons.info_outline_rounded),
          )
        ],
      ),
      body: FadeInUp(
        duration: Duration(milliseconds: 350),
        curve: Curves.linear,
        child: Center(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              HapticFeedback.lightImpact();
              ref.read(isdarckProvider.notifier).setFount(!fount);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 450),
                curve: Curves.elasticInOut,
                width: widthNew,
                height: heigthNew,
                decoration: BoxDecoration(
                  color: fount ?
                  Colors.white30
                  :
                  Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 0.5,
                    color: fount ?
                    Colors.white30
                    :
                    Colors.blueAccent,
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    Icon(
                      fount ?
                      Icons.brightness_7
                      :
                      Icons.brightness_5,
                      color: colorTheme.primary,
                      size: size.width * 0.1,
                    ),
                    
                    SizedBox(height: 10,),
                    
                    Switch(
                      value: fount, 
                      
                      // ! EL VALUE DEL ONCHANGED YA NOS DEVUELVE EL CONTRARIO, NO ES NECESARIO EL !VALUE
                      onChanged: (value) {
                        HapticFeedback.lightImpact();

                        ref.read(isdarckProvider.notifier).setFount(value);
                    
                        changeDimensions(size);
                      },
                    ),
                        
                    SizedBox(height: 10,),
                        
                    Text(
                      'Cambiar\nFondo',
                      style: textTheme.titleMedium?.copyWith(color: Colors.white,),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
