
import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/domain/repositories/local_storage_repository.dart';
import 'package:movies_app/features/movies/presentation/providers/storage/local_storage_provider.dart';

//! ESTE PROVIDER PROVEE LA INFO A LA APP Y TAMBIEN POR PARTE DEL BOTON HACE CAMBIOS EN LA BASE DE DATOS Y EN LA APP
final favoriteMoviesProvider = StateNotifierProvider(
  (ref){
  final localStorageRepository =  ref.watch(localStorageRepositoryProvider);

  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);

});


//* EN EL NOTIFIER ES DONDE SE MANEJA SI SE ELIMINA O SE AGREGA COSAS EN LA APP

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>>{
  int page = 0;//* PARA PAGINACION INFINITA
  final LocalStorageRepository localStorageRepository;//* PARA OBTENER LA DATA

  StorageMoviesNotifier({required this.localStorageRepository}): super({});

  //* TAMBIEN PODEMOS CREAR UNA FUNCION QUE DEVUELVA EL BOOL PARA EL ICONO DE FAVORITOS
 
  Future<List<Movie>> loadNextPage() async{
    final movies = await localStorageRepository.loadFavoriteMovies(
      limit: 13,//*SIEMPPRE INICIALRE DESDE EL 13 PARA ESTE CASO, PARA LA PAGINACION
      offset: page * 10,
    );

    page++;//* PARA CARGAR LA SIGUEINTE PAGINA

    final tempMovies = <int, Movie>{};

    for(final movie in movies){//* foreach
      //state = {...state, movie.id: movie};
      tempMovies[movie.id] = movie;//* PARA QUE NO REALICE UNA ACTUALIZACION DE ESTADO DEMASIADAS VECES POR CADA MOVIE
    }

    state = {...state, ...tempMovies};//* PARA GESTIONAR EL ESTADO

    return movies;
  }

  //* FUNCION QUE AGREGA O ELIMINA UNA MOVIE DE FAVORITOS, TAMBIEN ACTUALIZA LA BASE DE DATOS
  Future<void> toggleFavoriteMovie(Movie movie) async{
    
    //? ESA PELICULA ESTA EN FAVORITOS ?
    final isFavorite = await localStorageRepository.isFavoriteMovie(movie.id);
    
    //? SUCEDE EL CAMBIO EN LA BASE DE DATOS
    await localStorageRepository.toggleFavoriteMovie(movie);//* AQUI ES DONDE SUCEDDE EL CAMBIO

    //? CASO A, ES FAVORITA 
    if(isFavorite == true){
      state.remove(movie.id);//* LA REMUEVE DEL MAPA
      state = {... state};//* REGENERA EL ESTADO(IMPORTANTE PARA DECIRLES A LOS WIDGETS QUE HUVO CAMBIO)
      return;
    }

    //? CASE B, NO ES FAVORITA
    state = {... state, movie.id: movie};//* AL ESTADO QUE YA ESTA SE LE AGREGA UNA MOVIE

  }

  
  
}