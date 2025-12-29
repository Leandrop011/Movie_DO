import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/config/router/app_router.dart';
import 'package:movies_app/config/theme/app_theme.dart';
import 'package:movies_app/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:movies_app/presentation/providers/config/index_theme_provider.dart';
import 'package:movies_app/presentation/providers/config/isdarck_provider.dart';

//import 'package:movies_app/config/database/database.dart';
Future <void> main()async{ 

  //!ES COMO EL INICIALIZADOR PARA USAR/MODIFICAR LA BASE DE DATOS
  WidgetsFlutterBinding.ensureInitialized();

  // await db.into(db.favoritesMovies).insert(//!PARA HACER INCERSIONES DE ELEMENTOS EN LA BASE DE DATOS
  //   FavoritesMoviesCompanion.insert(
  //     movieId: 1, 
  //     backdropPath: "backdropPath.png", 
  //     originalTitle: "Mi first movie", 
  //     posterPath: 'posterPath.png', 
  //     title: 'Batman'
  //   )
  // );
  //! PARA BORRAR LOS RECURSOS DE LA BASE DE DATOS
  // final deleteQuery = db.delete(db.favoritesMovies);
  // await deleteQuery.go();

  //!EJEMPLO DE LO QUE INSERTA
  // final movies = await db.select(db.favoritesMovies).get();

  // print('Movies: $movies');

  //todo, para usar el api key que colocamos en variables de entorno 
  await dotenv.load(fileName: '.env');
  await NotificationsBloc.initializeFCM();
  runApp(

  MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => NotificationsBloc())
    ],
    child: ProviderScope(child: const MyApp())
  ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //* Va a estar pendiente de cualquier cambio, si existe algun cambio pues redibuja
    final isdarck = ref.watch(isdarckProvider);
    final indexColor = ref.watch(indexThemeProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(isdarck: isdarck, indexColor: indexColor).getTheme(),
    );
  }
}