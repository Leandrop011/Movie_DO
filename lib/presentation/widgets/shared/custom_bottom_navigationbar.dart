import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class CustomBottomNavigationbar extends StatelessWidget {

  final int currentIndex;
  const CustomBottomNavigationbar({
    super.key, 
    required this.currentIndex
  });

  void onItemTapped(BuildContext context, int index){
    context.go('/home/$index');//! ES LA RUTA DEPENDIENDO EL INDEX QUE NOS DA 
  }
  

  @override
  Widget build(BuildContext context) { 
    //final colors = Theme.of(context).colorScheme;

    return BottomNavigationBar(//la barra de navegar inferior
      type: BottomNavigationBarType.fixed,//!CUANDO HAY MAS DE 3 ITEMS HAY QUE COLOCAR ESTO PARA QUE MUESTRE SU COLOR 
      currentIndex: currentIndex,//todo, valor actual(segun la list de las view)
      onTap: (index) {
        onItemTapped(context, index);
      },
      elevation: 0,//todo, sin la linea de 'corte'
      //backgroundColor: colors.primary,
      items: [//todo, requiere por lo menos 2 hijos 
        BottomNavigationBarItem(//cada icono, debe tener icono y label obligado
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          activeIcon: Icon(Icons.home)
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.thumbs_up_down_outlined),
          label: 'Populares',
          activeIcon: Icon(Icons.thumbs_up_down)
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Favoritos',
          activeIcon: Icon(Icons.favorite)
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
          activeIcon: Icon(Icons.settings)
        ),
      ],
    );
  }
}