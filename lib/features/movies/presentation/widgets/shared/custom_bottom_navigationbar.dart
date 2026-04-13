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
    final colors = Theme.of(context).colorScheme;
    final fount = ref.watch(isdarckProvider).fount;
  
    return Container(
      margin: const EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.75,
          color: fount ? Colors.white30 : Colors.black54, 
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black54, spreadRadius: 3, blurRadius: 10),]
      ),

      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(15),
        child: BottomNavigationBar(//la barra de navegar inferior
          backgroundColor: Colors.transparent,
          selectedItemColor: colors.primary,//? cuando esta seleccionado
          unselectedItemColor: fount ? colors.secondary : colors.onPrimaryFixed ,//? cuando no esta seleccionado
          type: BottomNavigationBarType.shifting,//!CUANDO HAY MAS DE 3 ITEMS HAY QUE COLOCAR ESTO PARA QUE MUESTRE SU COLOR 
          currentIndex: currentIndex,// ? valor actual(segun la list de las view), el numero total
          onTap: (index) {
            onItemTapped(context, index);
          },
          elevation: 0,// ? sin la linea de 'corte'
          
          //backgroundColor: colors.primary,
          items: [// ? requiere por lo menos 2 hijos 
            BottomNavigationBarItem(//cada icono, debe tener icono y label obligado
              icon: const Icon(Icons.home_max_outlined),
              label: 'Inicio',
              backgroundColor: fount ? Colors.grey.shade900 : const Color.fromARGB(255, 207, 206, 206),
              tooltip: 'Seccion Principal'
            ),
        
            BottomNavigationBarItem(
              icon: const Icon(Icons.category_outlined),
              label: 'Populares',
              activeIcon: const Icon(Icons.category_rounded),
              backgroundColor: fount ? Colors.grey.shade900 : const Color.fromARGB(255, 207, 206, 206),
              tooltip: 'Seccion de populares'
            ),
        
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_border_rounded), 
              label: 'Favoritos',
              activeIcon: const Icon(Icons.favorite_rounded),
              backgroundColor: fount ? Colors.grey.shade900 : const Color.fromARGB(255, 207, 206, 206),
              tooltip: 'Seccion de favoritos'
            ),

            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              label: 'Ajustes',
              activeIcon: const Icon(Icons.settings_rounded),
              backgroundColor: fount ? Colors.grey.shade900 : const Color.fromARGB(255, 207, 206, 206),
              tooltip: 'Seccion de Configuraciones'
            )
          ],
        ),
      ),
    );
  }
}

