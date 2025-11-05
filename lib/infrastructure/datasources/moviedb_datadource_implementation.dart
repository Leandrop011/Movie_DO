import 'package:dio/dio.dart';
import 'package:movies_app/config/constants/environment.dart';
import 'package:movies_app/domain/data_sources/movies_datasource.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/infrastructure/mappers/movie_mapper.dart';
import 'package:movies_app/infrastructure/models/moviedb/moviedb_response.dart';

//todo, aqui es la implementacion, si o si debo hacer una implementacion
class MoviedbDatadourceImplementation extends MoviesDatasource{
  
  //todo, hacer una peticion htttp
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',//todo, es la base para obtener las peliculas
    queryParameters: {//todo, demas parametros
      'api_key': Environment.movieDBKey,
      'language': 'es-MX'
    }
  ));
  
  //todo, asi obtenemos y mapeamos las peliculas
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async{

    //todo, lo que se coloca para obtener cierto numero de peliculas del datasource 
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {//todo, en la peticion colocamos esto para que me devuelva peliculas infinitas y no solo ciertas
        'page': page
      }
    );
    //todo, leerla, mapearla y regresarle un listado de peliculas

    final movieDBResponse = MovideDbResponse.fromJson(response.data);

    //todo, recibira elemento por elemento de la respuesta http y se hara el mapeo
    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster' && moviedb.backdropPath != 'no-backdro')//si es diferente lo hace pasar al map
    .map(
      (movie) => MovieMapper.movieDBToEntity(movie)
    ).toList();

    
    return movies;
  }
    
}