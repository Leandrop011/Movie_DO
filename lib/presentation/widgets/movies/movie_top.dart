import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/domain/entities/movie.dart';

class MovieTop extends ConsumerWidget {
  
  final Movie movie;

  const MovieTop({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    //final isDarck = ref.watch(isdarckProvider);//! watch porque tiene que estar pendientes de los cambios

    if(movie.posterPath.isEmpty){
      return Center(child: CircularProgressIndicator(),);
    }
    
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        context.push('/movie/${movie.id}');
      },
      child: Padding(
        padding: const EdgeInsets.only(
          //top: 3, 
          right: 10,
          left: 10, 
          bottom: 10,
        ),
        child: FadeInDown(
          duration: Duration(seconds: 3),
          curve: Curves.elasticOut,
          child: SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.6,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, 
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 5, 
                        offset: Offset(3, 2)
                      )
                    ],
                  ),

                  child: Padding(//! SE COLOCA ESTA PADIGN PORQUE EL POSTER OCUPA ALL THIS SPACE, ENTONCES LO ACORTAMOS CON PAADIGN
                    padding: EdgeInsetsGeometry.all(0.5),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: Image.network(
                        movie.posterPath,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if(loadingProgress != null){
                            return Center(child: CircularProgressIndicator(),);
                          }
                          return child;
                        },
                      ),
                    ),
                  ),
                ),
                      
                Padding(
                  padding: const EdgeInsets.only(bottom: 25, left: 10, right: 10),
                  
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      context.push('/movie/${movie.id}');
                    },
                    child: _CustomButton()
                  ),
                  
                ),
                      
                SizedBox.expand(//* GRADIENTE
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,//* inicio
                        end: Alignment.bottomCenter,//* final
                        stops: [0.93, 1.2],
                        colors: [
                          Colors.transparent,
                          Colors.black87
                        ]
                      )
                    )
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

class _CustomButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.75,
      height: size.height * 0.06,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 0.3,
            color: Colors.white
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.white,),
            SizedBox(width: 10,),
            Text('Ver Detalles', style: TextStyle(color: Colors.white),),
          ],
        ),
      )
    );
  }
}