import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final List<String> categorias = [
  'Populares',
  'En Cines',
  'Proximamente',
  'Mejor Calificadas',
].toList();

class CustomCategoriesMasonry extends StatelessWidget {
  const CustomCategoriesMasonry({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        physics: AlwaysScrollableScrollPhysics(),
        crossAxisCount: 2, 
        itemCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (context, index) {
          //* SEGUN EL INDEX, RECORRE LA LISTA Y ME DA UN STRING PARA CADA CATEGORIA
          final categoria = categorias[index];
          return _CategoriesContainerView(textcategoria: categoria);
        },
      ),
    );
  }
}

//* ESTO DE LA CAJA DE CADA CATEGORIA
class _CategoriesContainerView extends StatelessWidget {
  final String textcategoria;

  const _CategoriesContainerView({required this.textcategoria});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        
      },
      child: BounceInDown(
        child: Container(
          width: size.width * 0.3,
          height: size.height * 0.2,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1, 
              color: colors.primary
            )
          ),
          child: Center(
            child: Text(textcategoria),
          ),
        ),
      ),
    );
  }
}