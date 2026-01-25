import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:movies_app/presentation/providers/providers.dart';
import 'package:movies_app/presentation/views/views.dart';
//import '../../views/movies_views/home_view.dart';

//todo, dotenv es para mover archivos de entorno hacia la app
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:movies_app/config/constants/environment.dart';

class HomeScreen extends StatefulWidget {

  static const String name = 'home_screen';
  final int pageIndex;//* ESTO SE LO EDFINE EN EL ROUTER

  const HomeScreen({
    super.key, 
    required this.pageIndex
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//* Este Mixin es necesario para mantener el estado en el PageView
class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
 
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      keepPage: true,
      // initialPage: widget.pageIndex
    );
  }
 
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(HomeScreen oldWidget) {
  //   super.didUpdateWidget(oldWidget);
    
    // Solo anima si el índice cambió
    // if (oldWidget.pageIndex != widget.pageIndex) {
    //   pageController.animateToPage(
    //     widget.pageIndex,
    //     duration: Duration(milliseconds: 250),
    //     curve: Curves.easeInOut,
    //   );
    // }
  // }
 
  final viewRoutes = const <Widget>[
    HomeView(), // <---- Home
    CategoriesView(),  // <--- Categories
    FavoritesView(),  // <--- Favorites
    SettingsView(), // <---- Settings
    // NotificationsView(), // <---- Notifications
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // * para darle esa animacion
    // if(pageController.hasClients){
    //   pageController.animateToPage(
    //     widget.pageIndex, 
    //     duration: Duration(milliseconds: 250), 
    //     curve: Curves.easeInOut
    //   );
    // }
    

    return Scaffold(
    
      body: IndexedStack(//! Para preservar el estado y no volver a crear el widget MUY UTIL
        index: widget.pageIndex, //* Esto es lo que define cual mostrar con el index(es el que escoge en el children)
        children: viewRoutes//* Todas las View y segun el index decide que view mostrar
      ),
    
      // body: PageView(
      //   physics: const NeverScrollableScrollPhysics(),
      //   controller: pageController,//* este es el controller que da la animacion cuando se cambia de view
      //   children: viewRoutes,
    
      // ),
    
      bottomNavigationBar: CustomBottomNavigationbar(currentIndex: widget.pageIndex,),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
