//* WIDGET QUE NOS DA LISTA DE PELICULAS SIMILARES
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../features.dart';

class MoviesSimilars extends ConsumerWidget {
  final String movieId;
  const MoviesSimilars({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //lista de peliculas
    final moviesById = ref.watch(similarMoviesProvider);//* mapa que da el provider
    final moviesSimilars = moviesById[movieId] ?? [];//* lo transformamos
    final size = MediaQuery.of(context).size;
    var totalMoviesSmilisar = moviesSimilars.length;

    if(moviesById[movieId] == null){
      return const CircularProgressIndicator();
    }

    // * SI NO HAY MOVIES SIMILARES 
    if(moviesSimilars.isEmpty){
      return const SizedBox();
    }
    // * CONDICONAL DEPENDIENDO EL TOTAL DE MOVIES
    if(totalMoviesSmilisar >= 9) {
      totalMoviesSmilisar = 9;
    }else{
      totalMoviesSmilisar = 6;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: SizedBox(
        
        height: size.height,
        child: MasonryGridView.count(
          // ? PARA QUE EL MASONRY NO TENGA SU PROPIO SCROLL Y SE INTEGRE EN LA LISTA DE SLIVERS 
          physics: const NeverScrollableScrollPhysics(),
          
          crossAxisCount: 3,
          itemCount: totalMoviesSmilisar,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          
          itemBuilder: (context, index) {
            final movie = moviesSimilars[index];

            return _MovieSimilarView(movie: movie, height: false);
            // if(index %2 == 0){//? si el index es par pues true para que tenga una dimension distinta
            //   return _MovieSimilarView(movie: movie, height: true);
            // }
            // return _MovieSimilarView(movie: movie, height: false);
          },
        ),
      ),
    );
  }
}

// ! ALGO MUY IMPORTANTE USAR EL SIZEDBOX PARA DEFINIR MAXIMOS TAMANOS Y NO EXISTA EL DESVORDAMIENTO
//* WIDGET QUE LE DA DISENO A CADA PELICULA SIMILAR DE LA LISTA DE ARRIBA
class _MovieSimilarView extends StatelessWidget {
  final Movie movie;
  final bool height;
  const _MovieSimilarView({required this.movie, required this.height});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: height ?
      size.height * 0.25
      : 
      size.height * 0.3,
      child: GestureDetector(
        onTap: () {
          //! LA DIRECCION DE LA RUTA CAMBIO PORQUE AHORA ES /HOME, YA NO ES DE DIRECCION RAIZ /
          context.push('/home/0/movie/${movie.id}');
        },
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(5),
          child: SizedBox(
            width: double.infinity,
            height: height ?
            size.height * 0.24
            :
            size.height * 0.29,//* le decimos que tome solo una parte no todo
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                CustomImageMovieView(image: movie.posterPath, iconErrorWidget: Icons.movie, size: size, valueSize: 0.3,),

                CustomViewRating(size: size, movie: movie, textStyle: textTheme,)
              ],
            ),
          ),
         
        ),
      ),
    );
  }
}

