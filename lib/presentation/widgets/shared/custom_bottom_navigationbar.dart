import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/presentation/providers/bottom_navigation/bottom_navigation_provider.dart';


class CustomBottomNavigationbar extends ConsumerWidget {
  const CustomBottomNavigationbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    final valueBottom = ref.watch(bottomNavigationProvider);

    return BottomNavigationBar(//la barra de navegar inferior
      currentIndex: valueBottom,//todo, valor actual(el provider le provee y actualiza)
      onTap: (index) {//todo, nos va a proveer el index de el elemento seleccionado
        ref.read(bottomNavigationProvider.notifier).state = index;
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
          label: 'Favorities',
          activeIcon: Icon(Icons.favorite)
        ),
      ],
    );
  }
}