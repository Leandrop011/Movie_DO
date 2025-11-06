
import 'package:go_router/go_router.dart';
import 'package:movies_app/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    //todo, rutas
    GoRoute(
      name: HomeScreen.name,
      path: '/',
      builder: (context, state) => HomeScreen(),
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

  ]
);
