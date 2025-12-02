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

    return BottomNavigationBar(//la barra de navegar inferior
      currentIndex: currentIndex,//todo, valor actual(segun la list de las view)
      onTap: (index) {
        onItemTapped(context, index);
      },
      elevation: 0,//todo, sin la linea de 'corte'
      items: [//todo, requiere por lo menos 2 hijos 
        BottomNavigationBarItem(//cada icono, debe tener icono y label obligado
          icon: Icon(Icons.home_max),
          label: 'Home',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Categories',
          activeIcon: Icon(Icons.label)
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Favorites',
          activeIcon: Icon(Icons.favorite)
        ),
      ],
    );
  }
}