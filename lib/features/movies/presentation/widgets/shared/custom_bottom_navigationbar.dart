import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';


class CustomBottomNavigationbar extends ConsumerWidget {
  
  final int currentIndex;

  const CustomBottomNavigationbar({
    super.key, 
    required this.currentIndex
  });

  void onItemTapped(BuildContext context, int index){

    //* Ligera Vibracion cada que pulsa un item de elbottom navigation bar
    HapticFeedback.lightImpact();

    context.go('/home/$index');//! ES LA RUTA DEPENDIENDO EL INDEX QUE NOS DA 
  
  }
  

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    // final colors = Theme.of(context).colorScheme;
    final fount = ref.watch(isdarckProvider).fount;
  
    return Container(
      margin: const EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.75,
          color: fount ? Colors.white30 : Colors.black54, 
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black54, spreadRadius: 3, blurRadius: 10),],
      ),

      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(20),
          // indicatorColor: colors.secondary,
        child: NavigationBar(
          // shadowColor: colors.primary,
          // surfaceTintColor: colors.primary,
          // backgroundColor: colors.primary,
          backgroundColor: fount ? const Color.fromARGB(255, 27, 27, 27) : const Color.fromARGB(255, 195, 193, 193),
          selectedIndex: currentIndex,
          onDestinationSelected: (value) => onItemTapped(context, value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_max), 
              label: 'Inicio',
              tooltip: 'Inicio',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.category),
              icon: Icon(Icons.category_outlined), 
              label: 'Populares',
              tooltip: 'Populares',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.favorite_rounded),
              icon: Icon(Icons.favorite_border_rounded), 
              label: 'Favoritas',
              tooltip: 'Favoritas',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined), 
              label: 'Ajustes',
              tooltip: 'Ajustes',
            ),
            
          ]
        ),
      ),
    );
  }
}

