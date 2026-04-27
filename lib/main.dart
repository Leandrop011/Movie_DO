
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/config/config.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
// ! Movie DO
Future <void> main()async{ 

  WidgetsFlutterBinding.ensureInitialized();

  final ref = ProviderContainer();

  final valueMovieId = await ref.read(lastMovieIdQuickActionProvider.notifier).getMovieIdValueQuickAction();

  QuickActionsPlugin.registerActions(movieId: valueMovieId);

  await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
  ]);
  
  // ! VARIABLE DE ENTORNO
  await dotenv.load(fileName: '.env');

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isdarck = ref.watch(isdarckProvider).fount;
    final indexColor = ref.watch(themeProvider).indexTheme; 

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(isdarck: isdarck, indexColor: indexColor).getTheme(),
    );
  }
}