import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/features.dart';
import 'package:movies_app/features/movies/presentation/providers/config/config.dart';
import 'package:movies_app/features/movies/presentation/providers/local_auth/local_auth_providers.dart';

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
    // final fount = ref.watch(isdarckProvider).fount;

    // if(ref.read(localAuthProvider).didAuthenticate == false){
    //   CustomSnackBar.snackBar(context, fount, 'La Autenticacion Fallo :(');
    // }

    // if(didAuthenticate == false){
    //   CustomSnackBar.snackBar(context, fount, message);
    // }
  }

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    // final colorTheme = Theme.of(context).colorScheme; 
    final fount = ref.watch(isdarckProvider).fount;
    final size = MediaQuery.of(context).size;

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
              width: 1,
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
          
                Text(
                  'Autenticacion\nNecesaria',
                  style: textTheme.titleLarge?.copyWith(fontSize: size.width * 0.06, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10,),
                FilledButton.tonal(
                  
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                    ),
                  ),
          
                  onPressed: () async{
                    final (didAuthenticate, message) = await ref.read(localAuthProvider.notifier).authenticateUser();
                  
                    if(didAuthenticate == true){
                      CustomSnackBar.snackBar(context, fount, 'Se Autentico con Exito :D');
                    }else{
                      CustomSnackBar.snackBar(context, fount, 'La Autenticacion Fallo :(');
                    }
                  }, 
                  child: SizedBox(
                    width: size.width * 0.4,
                    height: size.height * 0.08,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Verificar',
                          style: textTheme.bodySmall?.copyWith(fontSize: size.width * 0.05),
                        ),
                        SizedBox(width: 5,),
                        Icon(Icons.fingerprint, size: size.width * 0.07,),
                      ],
                    ),
                  ),
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}