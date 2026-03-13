import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:movies_app/features/movies/presentation/presentation.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

class ConfigSecurityScreen extends StatelessWidget {
  const ConfigSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Seguridad'),
        actions: [
          IconButton(
            onPressed: (){
              CustomInfomakeShowdialog.infoMake(
                context, 
                'Informacion', 
                'Esta sección le permite habilitar o deshabilitar la autenticación biométrica (huella dactilar) para acceder a la aplicación, brindando una capa adicional de protección a sus datos.', 
                [
                  FilledButton.tonal(
                    onPressed: () => context.pop(), 
                    child: Text('Ok')
                  )
                ], 
                textTheme,
              );
            }, 
            icon: Icon(Icons.info_outline_rounded)
          ),
        ],
      ),
      body: FadeInUp(child: _BodyView(textTheme: textTheme,)),
    );
  }
}

class _BodyView extends ConsumerStatefulWidget {

  final TextTheme textTheme;
  

  const _BodyView({required this.textTheme});

  @override
  ConsumerState<_BodyView> createState() => BodyViewState();
}

class BodyViewState extends ConsumerState<_BodyView> {

  double width = 300;
  double height = 400;

  void changeDimensions( Size size){
    Random random = Random();
    
    double widthNew = size.width * (0.6 + random.nextDouble() * 0.1);
    double heightNew = size.height * (0.5 + random.nextDouble() * 0.1);

    setState(() {
      width = widthNew;
      height = heightNew;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    final colorTheme = Theme.of(context).colorScheme;
    final securityValue = ref.watch(securityProvider).activeSecurity;
    final fountApp = ref.watch(isdarckProvider).fount;
    // ? VAR ES UN TIPO DE VARIABLE QUE PUEDE CAMBIAR EN CUALQUIER MOMENTO
    // late var authAprove = ref.watch(securityProvider).activeSecurity;

    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: (){

          HapticFeedback.heavyImpact();

          ref.read(securityProvider.notifier).setSecurity(!securityValue);

          ref.read( localAuthProvider ).copyWith(didAuthenticate: true, status: LocalAuthStatus.authenticated);

          changeDimensions(size);

          // if(securityValue == false){
          //   RestartWidget.restartApp(context);
          // }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 450),
            curve: Curves.elasticInOut,
            // ? TAMANO
            width: width,
            height: height,
            // ? DECORACION
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:fountApp ?
              Colors.white30
              :
              Colors.black87,
            ),
            // ? CONTENIDO DEL CONTAINER
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Icon(
                  Icons.fingerprint_rounded, 
                  size: size.width * 0.15,
                  color: colorTheme.primary,
                ),
                
                SizedBox(height: 10,),
          
                Text(
                  'Desea agregar seguridad\ncon sus datos biometricos?',
                  style: widget.textTheme.bodySmall?.copyWith(fontSize: 15, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10,),
                Switch(
                  value: securityValue, 
                  onChanged: (value) {

                    HapticFeedback.heavyImpact();

                    ref.read(securityProvider.notifier).setSecurity(value);

                    // ? ESTO ES UN INGENIO QUE REALIZAMOS PARA QUE CADA QUE ACTIVA LA SEGURIDAD CON BIOMETRICOS
                    // ? EL USUARIO, Y VUELVE A LAS VIEWS MUESTRE YA AUTENTICADO Y NO SEA NECESARIO AUTENTICAR CUANDO ESTE EN LA APP
                    // ? ANTERIORMENTE EXISTIA UN 'BUG' SI SALIAS Y TE AUTENTICABAS EL BOTTOM MARCABA AJUSTES PERO ESTABA EN INICIO
                    // ? ENTONCES CON ESTO SOLUCIONAMOS ESE PROBLEMA
                    ref.read(localAuthProvider).copyWith(didAuthenticate: true, status: LocalAuthStatus.authenticated);

                    // widget.reiniciar();
                    // context.pop();
                    

                    changeDimensions(size);
                    
                    // if(securityValue == fal){
                    //   RestartWidget.restartApp(context);
                    // }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}