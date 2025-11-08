import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/domain/entities/actor.dart';
import 'package:movies_app/presentation/providers/actors/actor_repository_provider.dart';

//todo, provider que nos da cada actor por id
//todo, nos da ua lista de actores como vienen en el JSON

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>(
  (ref){
    final actorRepository = ref.watch(actorRepositoryProvider).getActorByMovie;
    return ActorsByMovieNotifier(
      getActor: actorRepository
    );
  }
);



typedef GetActorsCallBack = Future<List<Actor>>Function(String moviId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {

  final GetActorsCallBack getActor; 

  ActorsByMovieNotifier({required this.getActor}):super({});

  Future<void> loadActors(String movieId) async{
    if(state[movieId] != null) return;

    final List<Actor> actors = await getActor(movieId);

    state = {...state, movieId: actors};
  }
  
}