
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:movies_app/config/config.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
// ? rama etapa 06
Future <void> main()async{ 
  Intl.defaultLocale = 'es_ES';
  initializeDateFormatting('es_ES', null);
  // FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

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

  
 
// //! 9. Noveno Paso Implementar Navegacion desde estado notification Background o Terminated
// //! Navegue hacia los detalles de la notification
// //! Metodo para cuando se pulse una notificcacion en estado Background navegue hacia los details
// class HandleNotificationInteractions extends StatefulWidget {
  
//   final Widget child;
//   const HandleNotificationInteractions({super.key, required this.child});

//   @override
//   State<HandleNotificationInteractions> createState() => _HandleNotificationInteractionsState();
// }

// class _HandleNotificationInteractionsState extends State<HandleNotificationInteractions> {

//   Future<void> setupInteractedMessage() async {
//     // Get any messages which caused the application to open from
//     // a terminated state.
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     // If the message also contains a data property with a "type" of "chat",
//     // navigate to a chat screen
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }

//     // Also handle any interaction when the app is in the background via a
//     // Stream listener
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
//   }
  
//   void _handleMessage(RemoteMessage message) {
//     context.read<NotificationsBloc>().handleRemoteMessage(message);
//     final messageId = message.messageId?.replaceAll(':', '').replaceAll('%', '');

//     //* Para que navegue mas rapido con la instancia del app router
//     appRouter.push('/push-details/$messageId');

//     // if (message.data['type'] == 'chat') {
//     //   Navigator.pushNamed(context, '/chat', 
//     //     arguments: ChatArguments(message),
//     //   );
//     // }
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Run code required to handle interacted messages in an async function
//     // as initState() must not be async
//     setupInteractedMessage();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }





