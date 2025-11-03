import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/infrastructure/models/moviedb/movie_moviedb.dart';

//todo, para transformar el modelo que nos da y acoplarlo a una instancia de la 
//todo, entidad(reglas del neogocio)

//todo, lo recibimos como es, y lo transformamos a nuestras reglas de negocio
class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
    adult: moviedb.adult,
    backdropPath: (moviedb.backdropPath != '') ? //todo, para saber si viene o no
    'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
     : 
    'no-backdro',
    genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: moviedb.overview,
    popularity: moviedb.popularity,
    posterPath: (moviedb.posterPath != '')? 
    'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
    :
    'no-poster'
    ,
    releaseDate: moviedb.releaseDate,
    title: moviedb.title,
    video: moviedb.video,
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount,
  );
}