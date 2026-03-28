
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/movies/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [

    // ! PARA QUE EL DEEPLINKING FUNCIONE ES NECESARIO QUE ESTAS RUTAS 
    // ! ESTEN ESPECIFICADAS EN EL ENLACE DE LA APP WEB
    // ! EJEMPL https://moviedo.up.railway.app/home/0/movie/$id/
    // ! NO SOLO MOVIE/:ID, PORQUE ESA RUTA NO ESTA EN NUESTRO ROUTER CUANDO COMIENCE EL PROCESO DE DEEPLINKING
    // ! LA RUTA QUE EXISTE ES: /home/0/movie/$id
   
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
      builder: (context, state) => ConfigThemeScreen(),
    ),
    GoRoute(
      path: '/fount',
      builder: (context, state) => ConfigFountScreen(),
    ),
    GoRoute(
      path: '/security',
      builder: (context, state) => ConfigSecurityScreen(),
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


    //! Para redireccionar la direccion / a la nueva /home/0
    GoRoute(
      path: '/',
      redirect: ( _ , _ ) {
        return '/home/0';
      },
    ),

    // // ! LA RUTA PARA EL DEEPLINKING, PARA QUE COMIENCE DESDE /MOVIES/:ID
    // // ! Y PUEDA CONSTRUIRSE LA RUTA E IR HACIA /home/0/movie/$id
    // // ! CUANDO SE INTENTE APLICAR EL DEEPLINKING EL APPROUTER SE VA POR ESTA
    // // ? PORQUE EN SI LA APP COMIENZA DESDE /movies/:id CON ESOS ENLACES
    // // ? ENTONCES PARA CONSTRUIR TODA LA RUTA SE HACE ESTO
    // GoRoute(
    //   path: '/movies/:id',
    //   redirect: (context, state) {
    //     final id = state.pathParameters['id'];

    //     return '/home/0/movie/$id';
    //   },
    // )

  ]
);




     //todo, ruta de el home(donde esta el bottom navigationBar) y rutas hijas
    // GoRoute(
    //   path: '/home/:page',//* esto indica en cual page quiere mostrar 0 home, 1 categories, 2 favorites
    //   builder: (context, state){
    //     final pageIndex = int.parse( state.pathParameters['page'] ?? 0.toString() );

    //     //* el pageindex tanto en movil como en web se aumenta si aumentan lso elementos del bottom
    //     //? PORQUE SI AHORA TENEMOS 4 ELEMENTOS(3) SI ES MAYOR TE DEVUELVE A HOMEVIEW
    //     if(pageIndex > 3 || pageIndex < 0){//* Validacion de que si el usuario por la web pone menor que 0 o mayor a 2 por el url, pues le redireccione al home screen-
    //       return HomeScreen(pageIndex: 0);
    //     }

    //     return HomeScreen(pageIndex: pageIndex);
    //   },
    //   routes: [//todo, para hacer deeplink
    //     GoRoute(
    //       name: MovieScreen.name,
    //       path: 'movie/:id',//* estoy diciendo que voy a mandar ese argumento id, osea que despues de /:id eso le voy a mandar
    //       builder: (context, state) {
    //         final movieId = state.pathParameters[
    //           'id'
    //         ]?? 'no-id';

    //         return MovieScreen(movieId: movieId,);
    //       },
    //     ),
    //   ]
    // ),

    //todo, RUTAS GLOBALES DONDE MANDA A OTRA SCREENS
    //* Pantalla de cambio de theme de la app
    // GoRoute(
    //   name: ChangeThemeScreen.name,
    //   path: '/theme',
    //   builder: (context, state) => ChangeThemeScreen(),
    // ),
    // //* Pantalla de cambio de fondo de la app
    // GoRoute(
    //   name: ChangeFountScreen.name,
    //   path: '/fount',
    //   builder: (context, state) => ChangeFountScreen(),
    // ),
    //* Pantalla de detalles de una notificacion
    // GoRoute(
    //   path: '/push-details/:messageId',
    //   builder: (context, state) => DetailsScreen(pushMessageId: state.pathParameters['messageId'] ?? ''),
    // ),

