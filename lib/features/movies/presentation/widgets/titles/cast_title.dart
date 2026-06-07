// * TITULO QUE DICE 'ELENCO'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../movies.dart';

class TitleCast extends ConsumerWidget {
  final TextTheme textTheme; 
  final String movieId;
  final Size size;

  const TitleCast({
    super.key, 
    required this.textTheme, 
    required this.movieId, 
    required this.size
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // ? OBTENEMOS EL VALOR QUE DA EL PROVIDER, EL MAP
    final actorsById = ref.watch( actorsByMovieProvider );
    // ? HACEMOS LA TRANSFORMACION DE MAP A LIST, SEGUN EL ID, OBTENEMOS ESOS ACTORS
    // ? LE DECIMOS QUE ME DE TODOS LOS OBJETOS CON ESE ID DE LA MOVIE
    final actors = actorsById[movieId] ?? [];
    final fount = ref.watch(isdarckProvider).fount;
 
    if(actors.isEmpty){
      return const SizedBox();
    }

    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [

        // * DIVIDER
        DividerSectionsView(fount: fount),

        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 5),
          child: Row(
            children: [
              
              CustomWidgetForSections(size: size, colors: colors),
          
              const SizedBox(width: 5,),
              Text(
                'Elenco',
                style: textTheme.bodyMedium?.copyWith(fontSize: 23),
              ),
          
              const Spacer(),
              
              Icon(Icons.person_2, size: size.width * 0.07,),
            ],
          ),
        ),
      ],
    );
  }
}
