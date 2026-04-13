import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';


class MovieTop extends ConsumerWidget {
  
  final Movie movie;

  const MovieTop({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    // final fount = ref.watch(isdarckProvider).fount; //! watch porque tiene que estar pendientes de los cambios
    final moviesFromVideo = ref.watch(videosFromMovieProvider(movie.id));

    final videos = moviesFromVideo.value;
    // * LO QUE HACE EL FIRSTORNULL ES QUE SI LA LISTA DA VACIA NOS DA UN NULO EN LUGAR DE EXCEPCION
    final youtubeId = videos?.firstOrNull?.youtubeKey;

    // * SI NO HAY VIDEOS RELACIONADOS O EL YOUTUBE ID ES NULO
    if(videos == null || youtubeId == null){
      return _MovieTopViewWithOutVideo(movie: movie, size: size);
    }else{
      // * SI EXISTE UN YOUTUBE ID PUES CONSTRUYE ESTE WIDGET 
      return _MovieTopViewWithVideo(movie: movie, size: size, youtubeId: youtubeId);
    }
  }
}


// * VIEW DE LA CAJA DE LA TOP MOVIE SI NO EXISTE UN VIDEO
class _MovieTopViewWithOutVideo extends StatelessWidget {
  const _MovieTopViewWithOutVideo({
    required this.movie,
    required this.size,
  });

  final Movie movie;
  final Size size;

  @override
  Widget build(BuildContext context) {
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
                _MovieTopViewPosterPath(movie: movie),
    
                //* GENEROS DE LA MOVIE Y BOTON
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Wrap(
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
                      // *  BOTON DE LA MOVIE FOR VIEW MORE DETAILES  
                      Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.015, top: size.height * 0.01),
                        
                        child: GestureDetector(
                          onTap: () => context.push('/home/0/movie/${movie.id}'),
                          child: const _CustomButton(text: 'Ver Detalles', color: Colors.black54,),
                        ),
                        
                      ),
                    ],
                  ),
                ),
                // *  GRADIENT OF CONTAINER
                _GradientView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// * VIEW DE LA CAJA DE TOP MOVIE SI EXISTE VIDEO
class _MovieTopViewWithVideo extends ConsumerWidget {
  const _MovieTopViewWithVideo({
    required this.movie,
    required this.size,
    required this.youtubeId,
  });

  final Movie movie;
  final Size size;
  final String youtubeId;

  @override
  Widget build(BuildContext context, ref) {

    final valueOnTapMovie = ref.watch(movieTapValueChangeProvider).isTaped;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        context.push('/home/0/movie/${movie.id}');
        ref.read(movieTapValueChangeProvider.notifier).changeValue(true);
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
                _MovieTopViewPosterPath(movie: movie),

                // *  GRADIENT OF CONTAINER SE COLOCA AQUI PARA QUE NO ESTE POR ENCIMA DE LOS BOTONES
                _GradientView(),
    
                //* GENEROS DE LA MOVIE Y BOTONES
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Wrap(
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
                      // *  BOTON DE LA MOVIE FOR VIEW MORE DETAILES  
                      Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.015, top: size.height * 0.01),
                        
                        child: GestureDetector(
                          onTap: () => context.push('/home/0/movie/${movie.id}'),
                          child: const _CustomButton(text: 'Ver Detalles', color: Colors.black54,),
                        ),
                        
                      ),
                      // * BOTON QUE REDIRIGUE HACIA LA REPRODUCCION DE ESA MOVIE
                      GestureDetector(
                        onTap: () {
                          context.push('/video_movie/${movie.id}/$youtubeId');
                          ref.read(movieTapValueChangeProvider.notifier).changeValue(true);
                        },
                        child:  _CustomButton(
                          text: valueOnTapMovie ? 'Cargando...' : 'Reproducir',
                          color: Colors.white,
                          colorText: Colors.black,
                          icon: valueOnTapMovie ? Icons.change_circle : Icons.play_arrow_rounded,
                        ),
                      ),
                    ],
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
      width: size.width * 0.3,//!DISENO RESPONSIVO UN TAMANO DE CAJA DEPENDIENDO EL DISPOSITIVO
      height: size.height * 0.03,
      decoration: BoxDecoration(
        color: Colors.black54, 
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 1, 
          color: const Color.fromARGB(255, 162, 159, 159)
        )
      ),
      child: Text(
        gender,
        style: style.bodyMedium?.copyWith(//*EL ? ES PORQUE AVECES NO LLEGA EL TITLLESMALL POR EL CONTEXTO
          color: Colors.white,
          fontSize: size.width * 0.035,
        ),
        //maxLines: 1,
      ),
    );
  }
}

//*IMAGEN DE LA MOVIE TOP Y SUS DECORACIONES
class _MovieTopViewPosterPath extends ConsumerWidget {
  const _MovieTopViewPosterPath({
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
            offset: const Offset(3, 3)
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
            
            placeholder: const AssetImage('assets/loaders/movie_do-loader.gif'), 
            
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
          gradient: const LinearGradient(
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
    );
  }
}


//* BOTON PERSONALIZADO
class _CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? colorText;
  final IconData? icon;

  const _CustomButton({
    required this.text, 
    required this.color, 
    this.colorText, 
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.75,
      height: size.height * 0.06,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? Colors.black54,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 0.5,
            color: colorText ?? Colors.white54
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon( icon ?? Icons.info_outline, color: colorText ?? Colors.white,),
            const SizedBox(width: 10,),
            Text(
              text, 
              style: TextStyle(
                color: colorText ?? Colors.white, 
                fontSize: size.width * 0.045
              ),
            ),
          ],
        ),
      )
    );
  }
}

