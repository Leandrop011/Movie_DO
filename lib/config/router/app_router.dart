
import 'package:go_router/go_router.dart';
import 'package:movies_app/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [


    //todo, rutas
    GoRoute(
      path: '/home/:page',//* esto indica en cual page quiere mostrar 0 home, 1 categories, 2 favorites
      builder: (context, state){
        final pageIndex = int.parse( state.pathParameters['page'] ?? 0.toString() );

        //* el pageindex tanto en movil como en web se aumenta si aumentan lso elementos del bottom
        //? PORQUE SI AHORA TENEMOS 4 ELEMENTOS(3) SI ES MAYOR TE DEVUELVE A HOMEVIEW
        if(pageIndex > 3 || pageIndex < 0){//* Validacion de que si el usuario por la web pone menor que 0 o mayor a 2 por el url, pues le redireccione al home screen-
          return HomeScreen(pageIndex: 0);
        }

        return HomeScreen(pageIndex: pageIndex);
      },
      routes: [//todo, para hacer deeplink
        GoRoute(
          name: MovieScreen.name,
          path: 'movie/:id',//* estoy diciendo que voy a mandar ese argumento id, osea que despues de /:id eso le voy a mandar
          builder: (context, state) {
            final movieId = state.pathParameters[
              'id'
            ]?? 'no-id';

            return MovieScreen(movieId: movieId,);
          },
        ),
      ]
    ),

    //! Para redireccionar la direccion / a la nueva /home/0
    GoRoute(
      path: '/',
      redirect: ( _ , __ ) {
        return '/home/0';
      },
    )

  ]
);
