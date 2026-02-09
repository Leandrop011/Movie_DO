import 'package:movies_app/features/movies/domain/entities/index.dart';
import 'package:movies_app/features/movies/infrastructure/models/moviedb/index.dart';

//* MAPA PARA TRANSFORMAR LOS GENEROS DE UNA MOVIE, POR EJEMPLO DE 28 -> A ACCION
const Map<int, String> generos = {
  28: "AcciÃ³n",
  12: "Aventura",
  16: "AnimaciÃ³n",
  35: "Comedia",
  80: "Crimen",
  99: "Documental",
  18: "Drama",
  10751: "Familia",
  14: "FantasÃ­a",
  36: "Historia",
  27: "Terror",
  10402: "MÃºsica",
  9648: "Misterio",
  10749: "Romance",
  878: "Ciencia ficciÃ³n",
  10770: "PelÃ­cula de TV",
  53: "Suspenso",
  10752: "Guerra",
  37: "Western",
};



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

    //* ASI MAPEAMOS LOS "NUMEROS" QUE VIENEN DE LOS GENEROS HACIA PALABRAS, Y NOS DEVUELVE UNA LISTA DE STRINGS
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

  //todo, acoplarlo a la entidad que tenemos
  static Movie movieDetailsToEntity(MovideDbDetails moviedb) => Movie(
    adult: moviedb.adult,
    backdropPath: (moviedb.backdropPath.isNotEmpty) ? //todo, para saber si viene o no
    'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
     : 
    'https://ih1.redbubble.net/image.4905811447.8675/flat,750x,075,f-pad,750x1000,f8f8f8.jpg',
    
    //* AQUI NO ES NECESARIO USAR EL MAP QUE CREAMOS PORQUE LA MISMA DATA QUE NOS DA 
    //* YA NOS LA DA COMO UN STRING 
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
