import 'package:flutter/material.dart';

import 'package:movies_app/features/movies/presentation/providers/index.dart';
import 'package:movies_app/features/movies/presentation/views/index.dart';
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
  
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      keepPage: true,
      initialPage: widget.pageIndex,
    );
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pageIndex != widget.pageIndex && pageController.hasClients) {
      pageController.animateToPage(
        widget.pageIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
 
  final viewRoutes = const <Widget>[
    HomeView(), // <---- Home
    CategoriesView(),  // <--- Categories
    FavoritesView(),  // <--- Favorites
    // SettingsView(), // <---- Settings
    // NotificationsView(), // <---- Notifications
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      extendBody: true, //? PARA COLOCAR EL BOTTOMNAVIGATIONBAR ENCIMA DE TODO1, COMO QUE SE EXTIENDE
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController, //* este es el controller que da la animacion cuando se cambia de view
        children: viewRoutes,
      ),

    
      bottomNavigationBar: CustomBottomNavigationbar(currentIndex: widget.pageIndex,),

      // drawer: NavigationDrawer(),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
