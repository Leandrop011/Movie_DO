import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/movies/presentation/providers/config/fount_provider.dart';


class CustomBottomNavigationbar extends ConsumerWidget {

  final int currentIndex;
  const CustomBottomNavigationbar({
    super.key, 
    required this.currentIndex
  });

  void onItemTapped(BuildContext context, int index){
    context.go('/home/$index');//! ES LA RUTA DEPENDIENDO EL INDEX QUE NOS DA 
  }
  

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    final colors = Theme.of(context).colorScheme;
    final isDarck = ref.watch(isdarckProvider).fount;
  
    return Container(
      margin: EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black54, spreadRadius: 3, blurRadius: 10),]
      ),

      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10),
        child: BottomNavigationBar(//la barra de navegar inferior
        backgroundColor: Colors.transparent,
        selectedItemColor: isDarck ?
          colors.primary
          :
          Colors.blueAccent,//? cuando esta seleccionado
          unselectedItemColor: isDarck ?
          colors.primary
          :
          Colors.blueAccent,//? cuando no esta seleccionado
          type: BottomNavigationBarType.shifting,//!CUANDO HAY MAS DE 3 ITEMS HAY QUE COLOCAR ESTO PARA QUE MUESTRE SU COLOR 
          currentIndex: currentIndex,//todo, valor actual(segun la list de las view)
          onTap: (index) {
            onItemTapped(context, index);
          },
          elevation: 0,//todo, sin la linea de 'corte'
          //backgroundColor: colors.primary,
          items: [//todo, requiere por lo menos 2 hijos 
            BottomNavigationBarItem(//cada icono, debe tener icono y label obligado
              icon: const Icon(Icons.home_max_outlined),
              label: 'Home',
              backgroundColor: Colors.black87,
              tooltip: 'Ir a Home'
            ),
        
            BottomNavigationBarItem(
              icon: const Icon(Icons.theater_comedy_outlined),
              label: 'Populares',
              activeIcon: const Icon(Icons.theater_comedy),
              backgroundColor: Colors.black87,
              tooltip: 'Ir a la seccion de populares'
            ),
        
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_border_rounded), 
              label: 'Favoritos',
              activeIcon: const Icon(Icons.favorite_rounded),
              backgroundColor: Colors.black87,
              tooltip: 'Ir a la seccion de favoritos'
            ),
        
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.settings_outlined),
            //   label: 'Ajustes',
            //   activeIcon: Icon(Icons.settings)
            // ),
        
            // BottomNavigationBarItem(
            //   icon: Icon(Icons. notifications_outlined),
            //   label: 'Notificaciones',
            //   activeIcon: Icon(Icons.notifications_active)
            // ),
          ],
        ),
      ),
    );
  }
}