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

// * VIEW DEL CONTAINER DE INGRESAR SECURITY CON UN PIN
// class _PinViewSecurity extends ConsumerWidget {
//   const _PinViewSecurity({
//     required this.fountApp,
//     required this.colorTheme,
//     required this.size,
//     required this.textTheme,
//   });

//   final bool fountApp;
//   final ColorScheme colorTheme;
//   final Size size;
//   final TextTheme textTheme;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {

//     final pinFormState = ref.watch(pinFormProvider).pinInput;

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         // ? TAMANO
//         width: size.width * 0.7,
//         height: size.height * 0.4,
//       // ? DECORACION
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color:fountApp ?
//         Colors.white30
//         :
//         Colors.black87,
//       ),
            
      
//         if (!snapshot.hasData) return const CircularProgressIndicator();
        
//         final pinActive = snapshot.data!.$2;
//         final pinValue = snapshot.data!.$1;
        
//         return ( pinActive == true && pinValue != -1 ) ?  
//           _PinOnView(colorTheme: colorTheme, size: size, textTheme: textTheme,)
//           :
//           _PinOffView(colorTheme: colorTheme, size: size, textTheme: textTheme, pinFormState: pinFormState);
//           }
//         ),
//       )
//     );
//   }
// }

// * WIDGET QUE SE MUESTRA CUANDO EXISTE UN PIN PARA HABILITAR LA SEGURIDAD O DESHABILITARLA
// class _PinOnView extends ConsumerWidget {
//   final ColorScheme colorTheme;
//   final Size size;
//   final TextTheme textTheme;
//   const _PinOnView({
//     required this.colorTheme, 
//     required this.size, 
//     required this.textTheme,
//   });

//   @override
//   Widget build(BuildContext context, ref) {

//     final valueEnabledPin = ref.watch(pinFormProvider).isPinEnabled;

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Icon(Icons.pin),
//         SizedBox(height: size.height * 0.05,),
//         const Text('Activar seguridad con su PIN'),
//         SizedBox(height: size.height * 0.05,),
//         Switch(
//           value: valueEnabledPin, 
//           onChanged: (value) {
//             ref.read(pinFormProvider.notifier).toggle(value);
//           },
//         ),
//         SizedBox(height: size.height * 0.05,),
//         FilledButton.tonal(
//           onPressed: (){
//             ref.read(pinFormProvider.notifier).deletePin();
//           }, 
//           child: const Row(
//             children: [
//               Icon(Icons.delete),
//               SizedBox(height: 10,),
//               Text('Eliminar Pin'),
//             ],
//           )
//         ),
//       ],
//     );
//   }
// }

// * WIDGET QUE SE MUESTRA CUANO NO EXISTE UN PIN REGISTRADO, PERMITE REGISTRAR UN PIN 
// class _PinOffView extends ConsumerWidget {
//   const _PinOffView({
//     required this.colorTheme,
//     required this.size,
//     required this.textTheme,
//     required this.pinFormState,
//   });

//   final ColorScheme colorTheme;
//   final Size size;
//   final TextTheme textTheme;
//   final PinInput pinFormState;

//   @override
//   Widget build(BuildContext context, ref) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
        
//         Icon(Icons.pin, color: colorTheme.primary, size: size.width * 0.1,),
        
//         SizedBox(height: size.height * 0.02,),
        
//         Text(
//           'Desea agregar seguridad\ncon un PIN?', 
//           style: textTheme.bodySmall?.copyWith(fontSize: 15, color: Colors.white),
//           textAlign: TextAlign.center,
//         ),
        
//         SizedBox(height: size.height * 0.02,),
        
//         // * CAMPO DE INGRESO
//         CustomFormPIN(
//           // * VALOR INICIAL
//           // initialValue: 'Pin',
//           // * STRING QUE TIENE ANIMACION DE COLOCARSE EN LA PARTE DE ARRIBA CUANDO ESCRIBE EL USER
//           label: 'Pin',
    
//           // * VALOR DEL WIDTH
//           width: size.width * 0.45,
//           height: size.height * 0.08,
//           // * FUNCION QUE CADA QUE INGRESA ALGO EL USER VERIFICA SI ES CORRECTO
//           // ? Y ES -1 PARA CUANDO NO EXISTA NADA DETECTE EL ERROR
//           onChanged: (pin) {
//             ref.read(pinFormProvider.notifier).onInputChanged(int.tryParse(pin) ?? -1);
//           },
//           // * ERROR QUE PUEDE TENER ESE INPUT CUANDO EJECUTA EL ONCHANGED VERIFICA SI EXISTE UN 
//           // * ERROR Y SI HAY PUES LO DIBUJA
//           errorMessage: pinFormState.errorMessage,
//         ),
    
//         SizedBox(height: size.height * 0.02,),
        
//         // * BOTON DE AGREGAR PIN
//         FilledButton(
//           onPressed: (){
//             HapticFeedback.heavyImpact();
//             ref.read(pinFormProvider.notifier).onFormSumbit();
//           }, 
//           child: const Text('Agregar'),
//         ),
//       ],
//     );
//   }
// }