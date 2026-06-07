// * GENEROS DE LA PELICULA
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/features.dart';

class Genders extends ConsumerWidget {
  final Movie movie;

  const Genders({super.key, 
    required this.movie
  });


  @override
  Widget build(BuildContext context, ref) {

    final colors = Theme.of(context).colorScheme;
    final fount = ref.watch(isdarckProvider).fount;

    return Padding(//* GENEROS DE LA MOVIE
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          
          children: movie.genreIds.map(
            (gender) => Container(
              margin: const EdgeInsets.only(right: 10),
              child: Chip(

                label: Text(gender),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
                backgroundColor: colors.primary.withOpacity( fount ? 0.3 : 0.9),
              ),
            )
          ).toList(),
        ),
      ),
    );
  }
}