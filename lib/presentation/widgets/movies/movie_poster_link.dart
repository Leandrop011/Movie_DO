import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/movies/movie_top_provider.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;
  final bool index;
  const MoviePosterLink({super.key, required this.movie, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/home/0/movie/${movie.id}'),
      child: FadeInUp(
        from: random.nextInt(100) + 80,//! ESTO CONTROLA MEJOR LA PAGINACION EL CATEGORIES
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(//* USAMOS ESTE FADE IN IMAGE PARA UNA MEJOR VISUALIZACION DE LA CARGA DE MOVIES
            height: index?
            200
            :
            300,
            image: NetworkImage(movie.posterPath),
            placeholder: AssetImage('assets/loaders/bottle-loader.gif'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}