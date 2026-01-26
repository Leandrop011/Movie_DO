import 'package:flutter/material.dart';


//todo, WIDGET QUE SE MUESTRA MIENTRAS LA DATA SE ESTA RENDERIZANDO(UN SIMBOLO DE CARGA)

class CustomFullscreenLoading extends StatelessWidget {
  const CustomFullscreenLoading({super.key});
  
  Stream<String> getLoadingMessages(){//* construir el stream que necesita el streambuilder
   
    final messages = <String> [//* arreglo de mensajes, los mostraremos en pantalla, conforme va pasando
      'Cargando Peliculas',
      'Cargando populares',
      'Ya casi...',
      'Esto esta tardando mas de lo esperado :(',
      'Estamos trabajando en ello...',
    ];
    
    return Stream.periodic(Duration(seconds: 2), (step){
      return messages[step];
    }).take(messages.length);
  } 
 
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Espere por favor', style: style.titleMedium,),
          SizedBox(height: 20,),

          CircularProgressIndicator(strokeWidth: 2,),

          SizedBox(height: 10,),

          StreamBuilder(//* esto es pa que vaya mostrando frases conforme un tiempo va pasando
            stream: getLoadingMessages(), 
            builder: (context, snapshot) {
              if( !snapshot.hasData ) return Text('Cargando....', style: style.titleMedium,);

              return Text(
                snapshot.data!,
                style: style.titleMedium,
              );
            },
          )
        ],
      ),
    );
  }
}