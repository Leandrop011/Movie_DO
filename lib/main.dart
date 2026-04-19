
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/config/config.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
// ? MEJORAS DE ESTILOS PARA EL FRONTED DE LA APLICACION
Future <void> main()async{ 

  // ! ES COMO EL INICIALIZADOR PARA USAR/MODIFICAR LA BASE DE DATOS O SERVICIOS EXTERNOS(FIREBASE)
  WidgetsFlutterBinding.ensureInitialized();

  // ! PARA ACCEDER A LOS PROVIDERS DESDE EL MAIN, OSEA DESDE EL INICIO DE LA APP
  // ! Y TENER EL VALOR GUARDADO DE EL ID MOVIE Y NAVEGAR A ESA MOVIE
  final ref = ProviderContainer();

  final valueMovieId = await ref.read(lastMovieIdQuickActionProvider.notifier).getMovieIdValueQuickAction();

  QuickActionsPlugin.registerActions(movieId: valueMovieId);

  // ! PARA COLOCAR LA HORIENTACION DEL TELEFONO POR DEFECTO EN VERTICAL
  await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
  ]);
  
  // ! Para usar el api key que colocamos en variables de entorno 
  await dotenv.load(fileName: '.env');

  runApp(
    // ! EL PROVIDER SCOPE ES NECESARIO PARA EL FUNCIONAMIENTO DE RIVERPOD
    const ProviderScope(child: MyApp())
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
    );
  }
}