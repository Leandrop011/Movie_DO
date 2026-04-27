import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/movies.dart';
import 'package:movies_app/features/movies/presentation/widgets/shared/custom_image_movie_view.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;
  final bool index;
  const MoviePosterLink({super.key, required this.movie, required this.index});

  //*TAMANO DEL ELEMENTOS DE MASONRY, Y EL LOADING 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () => context.push('/home/0/movie/${movie.id}'), 
          child: FadeInUp(
            //! ESTO ES LA distancia en píxeles desde donde comienza la animación
            from: random.nextInt(100) + 80,//! ESTO CONTROLA MEJOR LA PAGINACION EL CATEGORIES
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  _ImageView(index: index, movie: movie, size: size),

                  _RatingView(size: size, movie: movie, textTheme: textTheme)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// * VIEW DE LA IMAGEN DE LA MOVIE
class _ImageView extends StatelessWidget {
  const _ImageView({
    required this.index,
    required this.movie,
    required this.size,
  });

  final bool index;
  final Movie movie;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return CustomImageMovieView(
      image: movie.posterPath, 
      iconErrorWidget: Icons.movie, 
      size: size,
      valueSize: index ? 0.3 : 0.4,
    );
  }
}

// * VIEW DE EL RATING DE LA MOVIE
class _RatingView extends StatelessWidget {
  const _RatingView({
    required this.size,
    required this.movie,
    required this.textTheme,
  });

  final Size size;
  final Movie movie;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: size.width * 0.01,
      top: size.height * 0.006,
      child: Container(
        width: size.width * 0.17,
        height: size.height * 0.045,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black87,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_half_outlined, color: Colors.yellow.shade800,),
            const SizedBox(width: 3,),
            Text(
              movie.voteAverage.toStringAsFixed(1), 
              style: textTheme.bodyMedium?.copyWith(color: Colors.yellow.shade800),
            ),
          ],
        ),
      ),
    );
  }
}

