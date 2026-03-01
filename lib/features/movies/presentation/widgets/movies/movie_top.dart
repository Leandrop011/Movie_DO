import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/features/movies/domain/entities/index.dart';

import '../../providers/config/fount_provider.dart';

class MovieTop extends ConsumerWidget {
  
  final Movie movie;

  const MovieTop({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    //final isDarck = ref.watch(isdarckProvider);//! watch porque tiene que estar pendientes de los cambios

    // if(movie.posterPath.isEmpty){//* para animacion de carga 
    //   return Shimmer(
    //     duration: Duration(seconds: 2),
    //     color: Colors.white,
    //     colorOpacity: 1,
    //     enabled: true,
    //     direction: ShimmerDirection.fromLBRT(),

    //     child: SizedBox()
    //   );
    // }
    
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        context.push('/home/0/movie/${movie.id}');
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10, 
          right: 10,
          left: 10, 
          bottom: 10,
        ),
        child: FadeInDown(
          duration: const Duration(seconds: 3),
          curve: Curves.elasticOut,
          child: SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.6,
            child: Stack(
              alignment: Alignment.bottomCenter,
              
              children: [

                //* IMAGE MOVIE AND STYLES
                _MovieTopView(movie: movie),

                //* GENEROS DE LA MOVIE
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    bottom: size.height * 0.097//!DISENO RESPONSIVO
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      ...movie.genreIds.map(
                        (gender) => Container(
                          margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                          child: _GenderView(gender: gender),
                        )
                      )
                    ],
                  ),
                ),

                //*  BOTON DE LA MOVIE FOR VIEW MORE DETAILES  
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

                //*  GRADIENT OF CONTAINER
                _GradientView(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

//*CAJA DE DISENO DE CADA GENERO 
class _GenderView extends StatelessWidget {
  final String gender;

  const _GenderView({required this.gender});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final style = Theme.of(context).textTheme;

    return Container(
      alignment: Alignment.center,
      width: size.width * 0.4,//!DISENO RESPONSIVO UN TAMANO DE CAJA DEPENDIENDO EL DISPOSITIVO
      height: size.height * 0.04,
      decoration: BoxDecoration(
        color: Colors.black54, 
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          width: 1, 
          color: const Color.fromARGB(255, 162, 159, 159)
        )
      ),
      child: Text(
        gender,
        style: style.titleSmall?.copyWith(//*EL ? ES PORQUE AVECES NO LLEGA EL TITLLESMALL POR EL CONTEXTO
          color: Colors.white
        ),
        //maxLines: 1,
      ),
    );
  }
}

//*IMAGEN DE LA MOVIE TOP Y SUS DECORACIONES
class _MovieTopView extends ConsumerWidget {
  const _MovieTopView({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarck = ref.watch(isdarckProvider).fount;//* WATCH PORQUE NECESITO QUE ESTE PENDIENTE DE LOS CAMBIOS
    // final size = MediaQuery.of(context).size;
    return DecoratedBox(
      decoration: BoxDecoration(
        // border: Border.all(
        //   color: Colors.white, 
        //   width: 0.5,
        // ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [//*gradient
          BoxShadow(
            color: isDarck ?
            Colors.white12
            :
            Colors.black87,
            blurRadius: 5, 
            offset: Offset(3, 3)
          )
        ],
      ),
        
      child: Padding(//! SE COLOCA ESTE PADIGN PARA EL BORDER ALL PORQUE EL POSTER OCUPA ALL THIS SPACE, ENTONCES LO ACORTAMOS CON PAADIGN
        padding: const EdgeInsetsGeometry.all(0.5),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(10),
          child: FadeInImage(
            width: double.infinity,//! DISENO RESPONSIVO
            height: double.infinity,
            
            placeholder: AssetImage('assets/loaders/bottle-loader.gif'), 
            
            fit: BoxFit.cover,
            image: NetworkImage(
            movie.posterPath,
          ),
          )
          
        ),
      ),
    );
  }
}

//* GRADIENTE DE LA IMAGEN
class _GradientView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(//* GRADIENTE
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,//* inicio
            end: Alignment.bottomCenter,//* final
            stops: const [0.93, 1.2],
            colors: [
              Colors.transparent,
              Colors.black87
            ]
          )
        )
      ),
    );
  }
}


//* BOTON PERSONALIZADO
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
            const SizedBox(width: 10,),
            Text('Ver Detalles', style: TextStyle(color: Colors.white),),
          ],
        ),
      )
    );
  }
}
