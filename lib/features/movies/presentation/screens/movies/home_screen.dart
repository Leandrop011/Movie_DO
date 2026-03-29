import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/movies.dart';
import 'package:movies_app/features/movies/presentation/providers/config/security_provider.dart';
import 'package:movies_app/features/movies/presentation/providers/local_auth/local_auth_providers.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/movies.dart';
//import '../../views/movies_views/home_view.dart';

//todo, dotenv es para mover archivos de entorno hacia la app
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:movies_app/config/constants/environment.dart';

class HomeScreen extends ConsumerStatefulWidget {

  static const String name = 'home_screen';
  final int pageIndex;//* ESTO SE LO EDFINE EN EL ROUTER

  const HomeScreen({
    super.key, 
    required this.pageIndex
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

//* Este Mixin es necesario para mantener el estado en el PageView
class _HomeScreenState extends ConsumerState<HomeScreen> with AutomaticKeepAliveClientMixin {
  
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
    ConfigView()// <---- Settings
    // NotificationsView(), // <---- Notifications
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final authAprove = ref.watch(localAuthProvider).didAuthenticate;
    final securityActive = ref.watch(securityProvider).activeSecurity;
    final tutorialValueExecuted = ref.watch(tutorialMoviesProvider).didExecuted;

    return Scaffold(
      extendBody: true, //? PARA COLOCAR EL BOTTOMNAVIGATIONBAR ENCIMA DE TODO1, COMO QUE SE EXTIENDE
      // ? SI LA SEGURIDAD ESTA ACTIVA, PRIMERO HACE LAS CONSIDERACIONES, DE APROVADO O NO
      // ? SI NO ESTA ACTIVA MUESTRA LA APP NORMAL
      body:  (securityActive == true) ? 
        // ? SI LA SEGURIDAD ESTA ACTIVA, PRIMERO VERIFICA SI ESTA APROVADO PARA VER QUE SE MUESTRA
        (authAprove == true) ?
        // * APROVADO: MUESTRA LA APP O EL TUTORIAL
        (tutorialValueExecuted == true) ? 
        PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController, //* este es el controller que da la animacion cuando se cambia de view
          children: viewRoutes
        )
        :
        TutorialScreen()
        // * NO APROVADO: MUESTRA LA PANTALLA DE VERIFICARSE
        :
        SecurityScreen()
      :
      (tutorialValueExecuted == true) ?
      PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController, //* este es el controller que da la animacion cuando se cambia de view
        children: viewRoutes
      )
      :
      TutorialScreen(),
      

      // ? HAY QUE PRIMERO HACER UNA CONSIDERACION LUEGO OTRA AUTH AND SECURITY 2 TERNARIOS
      // ? PRIMERO SI ESTA ACTIVA LA SEGURIDAD Y HACE SUS CONSIDERACIONES
      bottomNavigationBar: (securityActive == true) ?
        // ? SI ESTA APROVADO MUESTRA EL BOTTOM, SINO NADA
        (authAprove == true) ?
        (tutorialValueExecuted == true)?
        CustomBottomNavigationbar(currentIndex: widget.pageIndex,)
        :
        null
        :
        null
      :
      (tutorialValueExecuted == true) ?
      // ? PERO SI NO ESTA ACTIVA LA SEGURIDAD SIMPLEMENTE MUESTRA EL BOTTOM 
      CustomBottomNavigationbar(currentIndex: widget.pageIndex,)
      :
      null,
      
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

