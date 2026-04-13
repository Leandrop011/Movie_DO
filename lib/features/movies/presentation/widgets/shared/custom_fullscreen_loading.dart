import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/presentation/providers/config/fount_provider.dart';


//todo, WIDGET QUE SE MUESTRA MIENTRAS LA DATA SE ESTA RENDERIZANDO(UN SIMBOLO DE CARGA)
class CustomFullscreenLoading extends ConsumerWidget {
  const CustomFullscreenLoading({super.key});
  
  Stream<String> getLoadingMessages(){//* construir el stream que necesita el streambuilder
   
    final messages = <String> [//* arreglo de mensajes, los mostraremos en pantalla, conforme va pasando
      'Cargando Peliculas',
      'Cargando populares',
      'Ya casi...',
      'Esto esta tardando :(',
      'Estamos trabajando en ello...',
    ];
    
    return Stream.periodic(const Duration(seconds: 2), (step){
      return messages[ step ];
    }).take(messages.length);
  } 
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final style = Theme.of(context).textTheme;
    final fount = ref.watch(isdarckProvider).fount;
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: size.width * 0.7,
        height: size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: fount ? Colors.white10 : Colors.black26,
          border: Border.all(
            width: 0.5, 
            color: fount ? Colors.white24 : Colors.black38
          )

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Espere por favor', style: style.bodySmall?.copyWith(fontSize: 17),),
            const SizedBox(height: 20,),
        
            SizedBox(
              width: size.width * 0.3,
              height: size.height * 0.2,
              child: SpinPerfect(
                duration: const Duration(milliseconds: 1100),
                infinite: true,
                spins: 10,
                child: Image.asset(
                  width: double.infinity,
                  height: double.infinity,
                  (fount) ?
                  'assets/loaders/loader_movie_do_white.png'
                  :
                  'assets/loaders/loader_movie_do_black.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
        
            const SizedBox(height: 10,),
        
            StreamBuilder(//* esto es pa que vaya mostrando frases conforme un tiempo va pasando
              stream: getLoadingMessages(), 
              builder: (context, snapshot) {
                // * MIESTRAS AUN NO TIENE DATA O LOS MENSAGES
                if( !snapshot.hasData ) return Text('Cargando....', style: style.bodySmall?.copyWith(fontSize: 16),);
        
                return Text(
                  snapshot.data!,
                  style: style.bodySmall?.copyWith(fontSize: 16),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}