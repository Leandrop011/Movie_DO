import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/presentation/providers/config/fount_provider.dart';


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

    return Scaffold(
      appBar: AppBar(
        title: Text('Fondo'),
      ),
      body: SizedBox(
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 450),
            curve: Curves.elasticInOut,
            width: widthNew,
            height: heigthNew,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),

            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Icon(
                  Icons.brightness_6, 
                  color: Colors.white,
                  size: size.width * 0.1,
                ),

                SizedBox(height: 10,),

                Switch(
                  value: fount, 
                  
                  // ! EL VALUE DEL ONCHANGED YA NOS DEVUELVE EL CONTRARIO, NO ES NECESARIO EL !VALUE
                  onChanged: (value) {
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
    );
  }
}