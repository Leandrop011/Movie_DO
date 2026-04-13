import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/features.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {


  @override
  void initState(){
    super.initState();
    ref.read(localAuthProvider.notifier).authenticateUser();
  }

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme; 
    final fount = ref.watch(isdarckProvider).fount;
    final size = MediaQuery.of(context).size;
    final valueBiometricsEnabled = ref.watch(existBiometricProvider).value;

    return Scaffold(

      body: Center(
        child: Container(
          width: size.width * 0.8,
          height: size.height * 0.7,
          decoration: BoxDecoration(
            color: fount ?
            const Color.fromARGB(255, 79, 77, 77)
            :
            const Color.fromARGB(255, 122, 121, 121),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 0.5,
              color: fount ?
              Colors.white
              :
              Colors.black,
            )
            
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // * IMAGEN
                SizedBox( 
                  width: size.width * 0.7,
                  height: size.height * 0.4,
                  child: Image.asset(
                    width: double.infinity,
                    height: double.infinity,
          
                    (fount == true) ?
                    'assets/logo_app/logo_app_without_fount_with_words_white.png'
                    :
                    'assets/logo_app/logo_app_without_fount_with_words_black.png',
                    fit: BoxFit.cover,
                  ),
                ),
          
                Divider(
                  indent: 25,
                  endIndent: 25,
                  thickness: 2,
                  radius: BorderRadius.circular(20),
                  color: fount ? 
                  Colors.white
                  :
                  Colors.black,

                ),

                // * TEXTO EXPLICATIVO
                Text(
                  'Autenticacion\nNecesaria',
                  style: textTheme.titleLarge?.copyWith(fontSize: size.width * 0.06, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10,),

                // * BOTON QUE EJECUTA EL PROCESO DE AUTENTICACION CON HUELLA
                (valueBiometricsEnabled == true ) ? 
                _ButtonVerificationBiometricsView(size: size, textTheme: textTheme, colors: colors, ref: ref, fount: fount)
                :
                const SizedBox(),

                // const SizedBox(height: 10,),

                // // * BOTON QUE EJECUTA EL PROCESO DE AUTENTICACION CON CODIGO
                // (valuePinEnabled == true) ? 
                // _ButtonVerificationPinView(size: size, colors: colors, textTheme: textTheme, fount: fount)
                // :
                // const SizedBox(),                  
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _ButtonVerificationPinView extends ConsumerWidget {
//   const _ButtonVerificationPinView({
//     required this.size,
//     required this.colors,
//     required this.textTheme,
//     required this.fount,
//   });

//   final Size size;
//   final ColorScheme colors;
//   final TextTheme textTheme;
//   final bool fount;

//   @override
//   Widget build(BuildContext context, ref) {

//     final errors = ref.watch(pinFormProvider).pinInput.errorMessage;
//     final valuePinTemporal = ref.watch(valuePinProvider);

//     return Center(
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             const Text('Ingrese el Pin'),
//             CustomFormPIN(
//               onChanged: (value) {
//                 ref.read(pinFormProvider.notifier).onInputChanged(int.tryParse(value) ?? -1);

//                 ref.read(valuePinProvider.notifier).state = (int.tryParse(value) ?? -1);
//               },
//               errorMessage: errors,
//             ),
//             FilledButton(
//               onPressed: () async{ 

//                 final isValid = await ref.read(pinFormProvider.notifier).verificationPin(valuePinTemporal);
                
//                 if(isValid == true){
//                   CustomSnackBar.snackBar(
//                     // ignore: use_build_context_synchronously
//                     context, 
//                     fount, 
//                     'Verificacion con exito', 
//                     textTheme,
//                   );
//                 }else{
//                   CustomSnackBar.snackBar(
//                     // ignore: use_build_context_synchronously
//                     context, 
//                     fount, 
//                     'Verificacion fallida :(', 
//                     textTheme,
//                   );

//                 }
//               }, 
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.verified),
//                   SizedBox(width: 5,),
//                   Text('Verificar')
//                 ],
//               )
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class _ButtonVerificationBiometricsView extends StatelessWidget {
  const _ButtonVerificationBiometricsView({
    required this.size,
    required this.textTheme,
    required this.colors,
    required this.ref,
    required this.fount,
  });

  final Size size;
  final TextTheme textTheme;
  final ColorScheme colors;
  final WidgetRef ref;
  final bool fount;

  @override
  Widget build(BuildContext context) {
    return CustomButtonAuthenticated(
      width: size.width * 0.45, 
      height: size.height * 0.08, 
      text: 'Huella', 
      icon: Icons.fingerprint_rounded, 
      textTheme: textTheme, 
      colors: colors,
      // ignore: void_checks
      onPressed: () async{
        final (didAuthenticate, message) = await ref.read(localAuthProvider.notifier).authenticateUser();
      
        if(didAuthenticate == true){
          CustomSnackBar.snackBar(context, fount, 'Se Autentico con Exito :D', textTheme);
        }else{
          CustomSnackBar.snackBar(context, fount, 'La Autenticacion Fallo :(', textTheme);
        }
      }, 
      size: size
    );
  }
}