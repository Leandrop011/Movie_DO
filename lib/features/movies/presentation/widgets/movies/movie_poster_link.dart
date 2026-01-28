import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/movie_top_provider.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;
  final bool index;
  const MoviePosterLink({super.key, required this.movie, required this.index});

  //*TAMANO DEL ELEMENTOS DE MASONRY, Y EL LOADING 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/home/0/movie/${movie.id}'), 
      child: FadeInUp(
        //! ESTO ES LA distancia en píxeles desde donde comienza la animación
        from: random.nextInt(100) + 80,//! ESTO CONTROLA MEJOR LA PAGINACION EL CATEGORIES
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage(//* USAMOS ESTE FADE IN IMAGE PARA UNA MEJOR VISUALIZACION DE LA CARGA DE MOVIES
            height: index?
            200
            :
            300,
            width: double.infinity,
            image: NetworkImage(movie.posterPath),
            //! PARA QUE NO DE ESE SALTO FEO POR QUE NO HAY COMO UN LOADING
            //!SOLO PERMITE IMAGENES
            placeholder: AssetImage('assets/loaders/bottle-loader.gif'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}