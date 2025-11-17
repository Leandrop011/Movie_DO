import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/infrastructure/models/moviedb/movie_details.dart';
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
    'https://movienewsletters.net/photos/000000H1.jpg',
    genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: (moviedb.originalTitle.isNotEmpty) ? moviedb.originalTitle : "",
    overview: (moviedb.overview.isNotEmpty) ? moviedb.overview: '',
    popularity: moviedb.popularity,
    posterPath: (moviedb.posterPath != '')? 
    'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
    :
    'https://movienewsletters.net/photos/000000H1.jpg' 
    ,
    releaseDate: moviedb.releaseDate != null ? moviedb.releaseDate! : DateTime.now(),
    title: (moviedb.title.isNotEmpty) ? moviedb.title : '',
    video: moviedb.video,
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount,
  );

  //todo, acoplarlo a la entidad que tenemos
  static Movie movieDetailsToEntity(MovideDbDetails moviedb) => Movie(
    adult: moviedb.adult,
    backdropPath: (moviedb.backdropPath != '') ? //todo, para saber si viene o no
    'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
     : 
    'https://ih1.redbubble.net/image.4905811447.8675/flat,750x,075,f-pad,750x1000,f8f8f8.jpg',
    genreIds: moviedb.genres.map((e) => e.name).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: (moviedb.overview.isNotEmpty) ? moviedb.overview : '',
    popularity: moviedb.popularity,
    posterPath: (moviedb.posterPath != '')? 
    'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
    :
    'https://movienewsletters.net/photos/000000H1.jpg'
    ,
    releaseDate: moviedb.releaseDate != null ? moviedb.releaseDate! : DateTime.now(),
    title: (moviedb.title.isNotEmpty) ? moviedb.title : '',
    video: moviedb.video,
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount,
  );
}