import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:movies_app/presentation/providers/providers.dart';
import 'package:movies_app/presentation/views/movies_views/settings_view.dart';
import 'package:movies_app/presentation/views/views.dart';
//import '../../views/movies_views/home_view.dart';

//todo, dotenv es para mover archivos de entorno hacia la app
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:movies_app/config/constants/environment.dart';

class HomeScreen extends StatelessWidget {

  static const String name = 'home_screen';
  final int pageIndex;

  const HomeScreen({
    super.key, 
    required this.pageIndex
  });

  final viewRoutes = const <Widget>[
    HomeView(), // <---- Home
    CategoriesView(),  // <--- Categories
    FavoritesView(),  // <--- Favorites
    SettingsView(), // <---- Settings
    NotificationsView(), // <---- Notifications
  ];

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Scaffold(
      
        body: IndexedStack(//! Para preservar el estado y no volver a crear el widget MUY UTIL
          index: pageIndex, //* Esto es lo que define cual mostrar con el index(es el que escoge en el children)
          children: viewRoutes//* Todas las View y segun el index decide que view mostrar
        ),
      
        bottomNavigationBar: CustomBottomNavigationbar(currentIndex: pageIndex,),
      ),
    );
  }
}
