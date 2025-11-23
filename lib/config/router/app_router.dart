
import 'package:go_router/go_router.dart';
import 'package:movies_app/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [


    //todo, rutas
    GoRoute(
      path: '/home/:page',//* esto indica en cual page quiere mostrar 0 home, 1 categories, 2 favorites
      builder: (context, state){
        final pageIndex = state.pathParameters['page'] ?? 0;

        return HomeScreen(pageIndex: int.parse(pageIndex.toString()),);
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
