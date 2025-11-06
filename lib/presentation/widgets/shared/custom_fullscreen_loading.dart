import 'package:flutter/material.dart';

class CustomFullscreenLoading extends StatelessWidget {
  const CustomFullscreenLoading({super.key});
  
  Stream<String> getLoadingMessages(){//* construir el stream que necesita el streambuilder
   
    final messages = <String> [//* arreglo de mensajes, los mostraremos en pantalla, conforme va pasando
      'Cargando Peliculas',
      'Cargando populares',
      'Ya mero...',
      'Esto esta tardando mas de lo esperado :(',
    ];
    
    return Stream.periodic(Duration(seconds: 2), (step){
      return messages[step];
    }).take(messages.length);
  } 
 
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Espere por favor'),
          SizedBox(height: 20,),
          CircularProgressIndicator(strokeWidth: 4,),
          SizedBox(height: 10,),

          StreamBuilder(//* esto es pa que vaya mostrando frases conforme un tiempo va pasando
            stream: getLoadingMessages(), 
            builder: (context, snapshot) {
              if( !snapshot.hasData ) return Text('Cargando....');

              return Text(snapshot.data!);
            },
          )
        ],
      ),
    );
  }
}