//todo, esto es para proveer las peliculas, pero dependiendo el caso de uso



import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/movies_repository_provider.dart';

//* DEL PRIMER REPOSITORY(USAMOS LA MISMA CLASE DE ABAJO PARA LAS DOS)
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    //todo, le pasamos el repo 
    final fetchMoreMoviesR = ref.watch(movieRepositoryProvider).getNowPlaying;//todo, le traemos esas pelicuas y eso se aplicara dependiendo del caso de uso
    return MoviesNotifier(
      fetchMoreMovies: fetchMoreMoviesR
    ); 
  }
);

//* DEL SEGUNDO RESPOSITORY
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    //todo, le pasamos el repo 
    final fetchMoreMoviesR = ref.watch(movieRepositoryProvider).getPopular;//todo, le traemos esas pelicuas y eso se aplicara dependiendo del caso de uso
    return MoviesNotifier(
      fetchMoreMovies: fetchMoreMoviesR
    ); 
  }
);

//* DEL TERCER REPOSITORY
final upComingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    //todo, le pasamos el repo 
    final fetchMoreMoviesR = ref.watch(movieRepositoryProvider).getUpComing;//todo, le traemos esas pelicuas y eso se aplicara dependiendo del caso de uso
    return MoviesNotifier(
      fetchMoreMovies: fetchMoreMoviesR
    ); 
  }
);

//* DEL CUARTO REPOSITORY
final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    //todo, le pasamos el repo 
    final getTopRatedMovies = ref.watch(movieRepositoryProvider).getTopRated;//todo, le traemos esas pelicuas y eso se aplicara dependiendo del caso de uso
    return MoviesNotifier(
      fetchMoreMovies: getTopRatedMovies
    ); 
  }
);




//todo, el objetivo es definir el caso de uso
typedef MovieCallBack = Future<List<Movie>> Function({int page});  

typedef SimilarMoviesCallback = Future<List<Movie>> Function(String movieId);


///todo, se crea dependiendo del caso de uso
class MoviesNotifier extends StateNotifier<List<Movie>> {

  bool isLoading = false;
  //todo, actualiza en la pagina que esta
  int currentPage = 0;
  //todo, una funcion que sabe como traer las peliculas
  MovieCallBack fetchMoreMovies;

  MoviesNotifier(
    {
      required this.fetchMoreMovies
    }
  ): super([]);

  //todo, este metodo carga mas peliculas
  Future<List<Movie>> loadNextPage() async{

    if(isLoading == true) isLoading = false;//todo, para que no haga demasiadas peticiones simultaneas

    isLoading = true;
     
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    
    isLoading = false;
    return movies;
  }

  

}


final similarMoviesProvider = StateNotifierProvider<SimilarMoviesNotifier, Map<String, List<Movie>>>(
  (ref) {
    //todo, le pasamos el repo 
    final getMoviesSimilar = ref.watch(movieRepositoryProvider).getMoviesSimilar;//todo, le traemos esas pelicuas y eso se aplicara dependiendo del caso de uso
    return SimilarMoviesNotifier(
      fetchSimilarMovies: getMoviesSimilar
    ); 
  }
);
//todo, PARA OBTENER SEGUN EL ID MAS PELICULAS SIMILARES  
class SimilarMoviesNotifier extends StateNotifier<Map<String, List<Movie>>> {
  
  final SimilarMoviesCallback fetchSimilarMovies;
  bool isLoading = false;
  SimilarMoviesNotifier({required this.fetchSimilarMovies}):super({});

  
  Future<void> loadSimilarMovies(String movieId) async{
    // opcional: si ya las cargaste, no vuelves a pedirlas
    if (state[movieId] != null) return;
    if (isLoading) return;

    isLoading = true;

    final movies = await fetchSimilarMovies(movieId);

    state = {
      ...state,
      movieId: movies//segun un id me da peliculas
    };
    isLoading = false;
  }
}