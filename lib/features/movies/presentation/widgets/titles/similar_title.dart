//* TITULO QUE DICE "Recomendaciones" ANTES DE MOSTRAR LAS PELICULAS
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features.dart';

class PreSimilarMoviesView extends ConsumerWidget {
  const PreSimilarMoviesView({
    super.key, 
    required this.size,
    required this.textStyle, 
    required this.movieId,
  });

  final Size size;
  final TextTheme textStyle;
  final String movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final fount = ref.read(isdarckProvider).fount;
    // ? POR SI NO HAY PELICULAS NO MOSTRAR ESTE TITULO
    final moviesById = ref.watch(similarMoviesProvider);
    final movies = moviesById[movieId] ?? [];
    
    if (movies.isEmpty){
      return const SizedBox();
    }
    final colors = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 2, left: 10, right: 10, top: 1),
      child: Column(
        children: [
          // * DIVIDER DE SECTIONS
          DividerSectionsView(fount: fount),

          Row(
            children: [
              
              CustomWidgetForSections(size: size, colors: colors),

              const SizedBox(width: 4,),
              Text(
                'Recomendaciones', 
                style: textStyle.bodyMedium?.copyWith(fontSize: 24),
              ),

              const Spacer(),
              Icon(Icons.recommend, size: size.width * 0.1,),
            ],
          ),
        ],
      ),
    );
  }
}