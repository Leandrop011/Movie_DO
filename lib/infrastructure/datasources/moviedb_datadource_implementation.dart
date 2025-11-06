import 'package:dio/dio.dart';
import 'package:movies_app/config/constants/environment.dart';
import 'package:movies_app/domain/data_sources/movies_datasource.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/infrastructure/mappers/movie_mapper.dart';
import 'package:movies_app/infrastructure/models/moviedb/movie_details.dart';
import 'package:movies_app/infrastructure/models/moviedb/moviedb_response.dart';

//todo, aqui es la implementacion, si o si debo hacer una implementacion
class MoviedbDatadourceImplementation extends MoviesDatasource{
  
  //todo, hacer una peticion htttp
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',//todo, es la base para obtener las peliculas
    queryParameters: {//todo, demas parametros
      'api_key': Environment.movieDBKey,//TODO, AQUI IMPLEMENTAMOS EL APY-KEY
      'language': 'es-MX'
    }
  ));

  //todo, METODO PARA MAPEAR LA INFORMACION
  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    //* ACOPLARLA AL MODELO DEL NEGOCIO
    final movieDBresponse = MovideDbResponse.fromJson(json);

    //* MAPEARLA PARA MANDARLA AL RESPOSITORY
    final List<Movie> movies = movieDBresponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster' && moviedb.backdropPath != 'no-backdro')
    .map(
      (movie) => MovieMapper.movieDBToEntity(movie)
    ).toList();

    return movies;
  }
  
  //todo, PRIMER DATASOURCE
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async{
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {//todo, en la peticion colocamos esto para que me devuelva peliculas infinitas y no solo ciertas
        'page': page
      }
    );

    return _jsonToMovies(response.data);
  }
  

  //todo, SEGUNDO DATASOURCE
  @override
  Future<List<Movie>> getPopular({int page = 1}) async{

    //* PEDIR INFO(PETICION HTTP)
    final response = await dio.get('/movie/popular',
      queryParameters: {
        'page': page
      }
    );

   return  _jsonToMovies(response.data);
  }
  

  //todo, TERCER DATASOURCE
  @override
  Future<List<Movie>> getUpComing({int page = 1}) async{
    final response = await dio.get('/movie/upcoming',
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);
  }

  //todo, CUARTA DATASOURCE
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async{
    final response = await dio.get('/movie/top_rated',
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);

  }
  
  //todo, DATA SOURCE QUE DEVUELVE UNA PELICULA POR ID
  @override
  Future<Movie> getMovieById(String id) async{

    final response = await dio.get('/movie/$id');
    //* por si no hay pelicula 
    if(response.statusCode != 200 ) throw Exception('Movie with id: $id not found');

    //todo, mapeo
    final movieDBDetails = MovideDbDetails.fromJson(response.data);

    //todo, devolver una movie, ahora el mapper , recibe un movidetails como objeto y regresa una entidad

    final Movie movie = MovieMapper.movieDetailsToEntity(movieDBDetails);

    return movie;
  }
  
    
}