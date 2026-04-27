import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/infrastructure/models/moviedb/moviedb.dart';

const Map<int, String> generos = {
  28: "Accion",
  12: "Aventura",
  16: "Animacion",
  35: "Comedia",
  80: "Crimen",
  99: "Documental",
  18: "Drama",
  10751: "Familia",
  14: "Fantasia",
  36: "Historia",
  27: "Terror",
  10402: "Musica",
  9648: "Misterio",
  10749: "Romance",
  878: "Ciencia ficcion",
  10770: "Pelicula TV",
  53: "Suspenso",
  10752: "Guerra",
  37: "Western",
};



class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
    adult: moviedb.adult,
    backdropPath: (moviedb.backdropPath != '') ? 
    'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
     : 
    'https://movienewsletters.net/photos/000000H1.jpg',

    genreIds: moviedb.genreIds.map((id) => generos[id] ?? "Desconocido").toList(),
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

  static Movie movieDetailsToEntity(MovideDbDetails moviedb) => Movie(
    adult: moviedb.adult,
    backdropPath: (moviedb.backdropPath.isNotEmpty) ? 
    'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
     : 
    'https://ih1.redbubble.net/image.4905811447.8675/flat,750x,075,f-pad,750x1000,f8f8f8.jpg',
    
    genreIds: moviedb.genres.map((genres) => genres.name).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: (moviedb.overview.isNotEmpty) ? moviedb.overview : '',
    popularity: moviedb.popularity,
    posterPath: (moviedb.posterPath != null && moviedb.posterPath!.isNotEmpty)? 
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

