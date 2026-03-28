
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/config/config.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
// ? RAMA ETAPA 07 QUICK ACTIONS
Future <void> main()async{ 
  // Intl.defaultLocale = 'es_ES';
  // initializeDateFormatting('es_ES', null);
  // FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  // ! ES COMO EL INICIALIZADOR PARA USAR/MODIFICAR LA BASE DE DATOS
  WidgetsFlutterBinding.ensureInitialized();


  // ! QUICK ACTIONS INIT
  QuickActionsPlugin.registerActions();

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

  // ? PARA COLOCAR LA HORIENTACION DEL TELEFONO 
  await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
  ]);
  
  //todo, para usar el api key que colocamos en variables de entorno 
  await dotenv.load(fileName: '.env');
  // await NotificationsBloc.initializeFCM();
  // await LocalNotifications.initializeLocalNotifications();
  //! Inicializar base de datos de notificaciones
  // Esto asegura que la BD esté lista antes de usarla
  // await dbNotifications.select(dbNotifications.notifications).get();
  
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingTerminatedHandler);
  runApp(
  // MultiBlocProvider(
    // providers: [
    //   BlocProvider(create: (context) {
    //     //! le pasamos el repo que nos provee del datasource la data de la database 
    //     final container = ProviderContainer();
    //     final repository = container.read(repositoryNotificationProvider);
        
    //     return NotificationsBloc(
    //     //* caso de uso para pedir el permiso de las local notifications
    //     requestLocalNotificationPermissions: LocalNotifications.requestPermissionLocalNotifications,
    //     //* para el show local notification
    //     showLocalNotification: LocalNotifications.showLocalNotifications,
    //     notificationsRepository: repository
    //     );
    //  }
    // )

    // ],
    //! EL PROVIDER SCOPE ES NECESARIO PARA EL FUNCIONAMIENTO DE RIVERPOD
    ProviderScope(child: const MyApp())
  // ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  // Key _appKey = UniqueKey();

// void reiniciar(){
//   setState(() {
//     _appKey = UniqueKey();
//   });
// }

  @override
  Widget build(BuildContext context) {

    //* Va a estar pendiente de cualquier cambio, si existe algun cambio pues redibuja
    final isdarck = ref.watch(isdarckProvider).fount;
    final indexColor = ref.watch(themeProvider).indexTheme; 

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(isdarck: isdarck, indexColor: indexColor).getTheme(),
      // builder: (context, child) => HandleNotificationInteractions(child: child!),
    );
  }
}