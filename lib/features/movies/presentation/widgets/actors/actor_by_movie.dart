//* ACTORES DE LA PELICULA
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movies_app/features/movies/domain/entities/actor.dart';
import 'package:movies_app/features/movies/presentation/providers/actors/actors_bymovie_provider.dart';
import 'package:movies_app/features/movies/presentation/widgets/shared/custom_image_movie_view.dart';

class ActorsByMovie extends ConsumerWidget {
  

  final String movieId;
  final bool fount;

  const ActorsByMovie({
    super.key, 
    required this.movieId, 
    required this.fount
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final actorsByMovie = ref.watch(actorsByMovieProvider);
    final size = MediaQuery.of(context).size;

    if(actorsByMovie[movieId]== null){
      return const Center(child: CircularProgressIndicator());
    }

    final actors = actorsByMovie[movieId]!;


    return SizedBox(
      height: size.height * 0.45,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        addAutomaticKeepAlives: false, //* PARA QUE NO GUARDE EL ESTADO DE LOS WIDGETS SI SE HACE SCROLL SE DESTRUYE
        itemBuilder: (context, index) {
          final actor = actors[index];

          return _ActorView(actor: actor, fount: fount,);
        },
      ),
    );
  }
}

//* CAJA DE CADA ACTOR (DISENO) Y SU INFORMACION
class _ActorView extends StatelessWidget {

  final Actor actor;
  final bool fount;
  const _ActorView({
    required this.actor, 
    required this.fount
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(//? DEFINE EL TAMANO DE TODA LA 'TARJETA' CON IMAGEN NOMBRE
      width: size.width * 0.33,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //* Foto de el Actor
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: CustomImageMovieView(
                image: actor.profilePath, 
                iconErrorWidget: Icons.person, 
                size: size, 
                valueSize: 0.27
              ),
            ),

            //* Nombre de el Actor
            const SizedBox(height: 5,),
            // const Spacer(),
            Text(
              actor.name, 
              maxLines: 1,
            ),
      
            //* el papel que interpretaron 
            Text(
              actor.character ?? '', 
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis
              ),
            )
          ],
        ),
      ),
    );
  }
}
