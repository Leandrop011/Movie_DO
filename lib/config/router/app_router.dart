
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/features.dart';
import 'package:movies_app/features/movies/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [

    // ! PARA QUE EL DEEPLINKING FUNCIONE ES NECESARIO QUE ESTAS RUTAS 
    // ! ESTEN ESPECIFICADAS EN EL ENLACE DE LA APP WEB
    // ! EJEMPL https://moviedo.up.railway.app/home/0/movie/$id/
   
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse( state.pathParameters['page'] ?? '0' );

        return HomeScreen( pageIndex: pageIndex );
      },
      routes: [
         GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';

            return MovieScreen( movieId: movieId );
          },
        ),
      ]
    ),

    // * RUTAS DE LAS CONFIGURACIONES
    GoRoute(
      path: '/theme',
      builder: (context, state) => const ConfigThemeScreen(),
    ),
    GoRoute(
      path: '/fount',
      builder: (context, state) => const ConfigFountScreen(),
    ),
    GoRoute(
      path: '/security',
      builder: (context, state) => const ConfigSecurityScreen(),
    ),


    // * RUTA PARA EL VIDEO DE LA MOVIE, CUANDO SE USE LA RUTA RECIBIREMOS EL ID
    GoRoute(
      path: '/video_movie/:movieId/:youtubeId',
      builder: (context, state){
        final colors = Theme.of(context).colorScheme;
        final youtubeId = state.pathParameters['youtubeId'] ?? 'no-id'; 
        final movieId = state.pathParameters['movieId'] ?? 'no-movieId';

        return VideoMovieScreen(colors: colors, youtubeId: youtubeId, movieId: movieId,);
      },
    ), 

    // * RUTA SI SE PULSA 'VER MAS' LO LLEVA A UN ESTILO MASONRY DE MOVIES
    GoRoute(
      path: '/show_more_movies/:category',
      builder: (context, state){
        // * SE LO BRINADMOS CUANDO HACEMOS LA NAVEGACION
        final title = state.pathParameters['category'] ?? '';

        return ShowMoreMovies(title: title,);
      },
    ),

    GoRoute(
      path: '/',
      redirect: ( _ , _ ) {
        return '/home/0';
      },
    ),

  ]
);

