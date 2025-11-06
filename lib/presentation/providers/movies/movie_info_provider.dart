import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/providers.dart';

//todo, esto es para poder cargar una pelicula segun el ID, se lo pide al provider que provee los respositorios
//TODO, ENTENDER ESTO
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>(
  (ref){
    final movieRepository = ref.watch(movieRepositoryProvider).getMovieById;

    return MovieMapNotifier(
      getMovie: movieRepository
    ); 

  }
);


typedef GetMovieCallBack = Future<Movie>Function(String moviId);


class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {

  final GetMovieCallBack getMovie ;

  MovieMapNotifier({required this.getMovie}): super({});

  //* esto es para que no haga multiples peticiones http
  Future<void> loadMovie(String movieId) async{
    if(state[movieId] != null) return;

    final movie = await getMovie(movieId);

    state = {...state, movieId: movie};

  }
  
}