import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/config/router/app_router.dart';
import 'package:movies_app/config/theme/app_theme.dart';

Future <void> main()async{ 

  //todo, para usar el api key que colocamos en variables de entorno 
  await dotenv.load(fileName: '.env');

  runApp(
  ProviderScope(child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}