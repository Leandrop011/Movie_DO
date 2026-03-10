import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
//* PARA QUE SE CONSERVE ESA BUSQUEDA DEL USUARIO CUANDO SE VUELVE A HOME Y EL USUARIO QUIERO
//* BUSCAR DENUEVO YA TIENE ESE STRING CARGADO
final searchQueryProvider = StateProvider<String>(
  (ref) => ''
);

final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier,  List<Movie>>(
  (ref){
    
    final moviesRepository = ref.read(movieRepositoryProvider);

    return SearchedMoviesNotifier(
      searchMovies: moviesRepository.searchMovies, //* LA REFERENCIA ES COMO CUANDO LA APP LO NECESITE LLAMARA LA FUNCION
      ref: ref
    );
  }
);

typedef SearchMoviesCallBack = Future<List<Movie>> Function(String query); 

class SearchedMoviesNotifier extends StateNotifier <List<Movie>>{

  SearchMoviesCallBack searchMovies;
  final Ref ref;
  
  SearchedMoviesNotifier({
    required this.searchMovies, 
    required this.ref
  }): super([]);
  
  //* PARA DEVOLVER LAS PELICULAS Y QUE SE ACTUALICE Y CONSERVE LA ULTIMA BUSQUEDA
  Future<List<Movie>> searchMoviesByQuery(String query) async{
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).state = query;

    state = movies;
    return movies;
  }
}

