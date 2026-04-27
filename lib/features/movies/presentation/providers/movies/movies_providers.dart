//todo, esto es para proveer las peliculas, pero dependiendo el caso de uso



import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/movies.dart';

//* DEL PRIMER REPOSITORY(USAMOS LA MISMA CLASE DE ABAJO PARA LAS DOS)
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    // * le pasamos el repo 
    final fetchMoreMoviesR = ref.watch(movieRepositoryProvider).getNowPlaying;// * le traemos esas pelicuas y eso se aplicara dependiendo del caso de uso
    return MoviesNotifier(
      fetchMoreMovies: fetchMoreMoviesR
    ); 
  }
);

//* DEL SEGUNDO RESPOSITORY
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    // * le pasamos el repo 
    final fetchMoreMoviesR = ref.watch(movieRepositoryProvider).getPopular;// * le traemos esas pelicuas y eso se aplicara dependiendo del caso de uso
    return MoviesNotifier(
      fetchMoreMovies: fetchMoreMoviesR
    ); 
  }
);

//* DEL TERCER REPOSITORY
final upComingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    // * le pasamos el repo 
    final fetchMoreMoviesR = ref.watch(movieRepositoryProvider).getUpComing;// * le traemos esas pelicuas y eso se aplicara dependiendo del caso de uso
    return MoviesNotifier(
      fetchMoreMovies: fetchMoreMoviesR
    ); 
  }
);

//* DEL CUARTO REPOSITORY
final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    // * le pasamos el repo 
    final getTopRatedMovies = ref.watch(movieRepositoryProvider).getTopRated;// * le traemos esas pelicuas y eso se aplicara dependiendo del caso de uso
    return MoviesNotifier(
      fetchMoreMovies: getTopRatedMovies
    ); 
  }
);


// ! CADA PROVIDER DE CADA CATEGORY DE LAS MOVIES, USA EL MISMO NOTIFIER PARA MANEJAR SU ESTADO
// ! Y MISMAS FUNCIONES

// * el objetivo es definir el caso de uso
typedef MovieCallBack = Future<List<Movie>> Function({int page});  

typedef SimilarMoviesCallback = Future<List<Movie>> Function(String movieId);


/// * se crea dependiendo del caso de uso
class MoviesNotifier extends StateNotifier<List<Movie>> {

  bool isLoading = false;
  // * actualiza en la pagina que esta
  int currentPage = 0;
  // * una funcion que sabe como traer las peliculas
  MovieCallBack fetchMoreMovies;

  MoviesNotifier(
    {
      required this.fetchMoreMovies
    }
  ): super([]);

  // * este metodo carga mas peliculas
  Future<List<Movie>> loadNextPage() async{

    if(isLoading == true) isLoading = false;// * para que no haga demasiadas peticiones simultaneas

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
    // * le pasamos el repo 
    final getMoviesSimilar = ref.watch(movieRepositoryProvider).getMoviesSimilar;// * le traemos esas pelicuas y eso se aplicara dependiendo del caso de uso
    return SimilarMoviesNotifier(
      fetchSimilarMovies: getMoviesSimilar
    ); 
  }
);
// * PARA OBTENER SEGUN EL ID MAS PELICULAS SIMILARES  
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

