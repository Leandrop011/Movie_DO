import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(

        // ! APPBAR
        appBar: AppBar(
          title: const Text('Seguridad'),
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
                      child: const Text('Ok')
                    )
                  ], 
                  textTheme,
                );
              }, 
              icon: const Icon(Icons.info_outline_rounded)
            ),
          ],
        ),

        // ! BODY
        body: FadeInUp(child: _BodyView(textTheme: textTheme)),
      
      ),
    );
  }
}

// * VIEW DEL BODY DE AMBOS CONTAINERS
class _BodyView extends ConsumerWidget {

  final TextTheme textTheme;
  

  const _BodyView({required this.textTheme,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final size = MediaQuery.of(context).size;
    final colorTheme = Theme.of(context).colorScheme;
    final securityValue = ref.watch(securityProvider).activeSecurity;
    final fountApp = ref.watch(isdarckProvider).fount;
    // ? VAR ES UN TIPO DE VARIABLE QUE PUEDE CAMBIAR EN CUALQUIER MOMENTO

    return Center(
      child: _BiometricsViewSecurity(securityValue: securityValue, size: size, fountApp: fountApp, colorTheme: colorTheme, textTheme: textTheme),
    );
  }
}

// * VIEW DEL CONTAINER QUE INGRESA SECURITY CON LOS BIOMETRICOS
class _BiometricsViewSecurity extends ConsumerWidget {
  const _BiometricsViewSecurity({
    required this.securityValue,
    required this.size,
    required this.fountApp,
    required this.colorTheme,
    required this.textTheme,
  });

  final bool securityValue;
  final Size size;
  final bool fountApp;
  final ColorScheme colorTheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: (){
        HapticFeedback.heavyImpact();
    
        ref.read(securityProvider.notifier).setSecurity(!securityValue);
    
        ref.read( localAuthProvider ).copyWith(didAuthenticate: true, status: LocalAuthStatus.authenticated);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // ? TAMANO
          width: size.width * 0.7,
          height: size.height * 0.4,
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
              
              const SizedBox(height: 10,),
        
              Text(
                'Desea agregar seguridad\ncon sus datos biometricos?',
                style: textTheme.bodySmall?.copyWith(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10,),
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
    
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
