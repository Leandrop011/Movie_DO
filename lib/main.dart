import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/config/router/app_router.dart';
import 'package:movies_app/config/theme/app_theme.dart';
import 'package:movies_app/presentation/providers/config/isdarck_provider.dart';

Future <void> main()async{ 

  //todo, para usar el api key que colocamos en variables de entorno 
  await dotenv.load(fileName: '.env');
  
  runApp(
  ProviderScope(child: const MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //* Va a estar pendiente de cualquier cambio, si existe algun cambio pues redibuja
    final isdarck = ref.watch(isdarckProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(isdarck: isdarck).getTheme(),
    );
  }
}