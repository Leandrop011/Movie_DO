import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/presentation/providers/actors/actors.dart';


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

