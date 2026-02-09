import 'package:dio/dio.dart';
import 'package:movies_app/config/constants/index.dart';
import 'package:movies_app/features/movies/domain/data_sources/index.dart';
import 'package:movies_app/features/movies/domain/entities/index.dart';
import 'package:movies_app/features/movies/infrastructure/mappers/index.dart';
import 'package:movies_app/features/movies/infrastructure/models/moviedb/index.dart';

//todo, aqui es la implementacion, si o si debo hacer una implementacion
class MoviedbDatadourceImplementation extends MoviesDatasource{
  
  //todo, hacer una peticion htttp
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',//todo, es la base para obtener las peliculas
    queryParameters: {//todo, demas parametros
      'api_key': Environment.movieDBKey,//TODO1, AQUI IMPLEMENTAMOS EL APY-KEY
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
  
  //todo, DATA SOURCE QUE ME DA RESPUESTA DE UN PELICULAS SEGUN UN QUERY QUE MANDAMOS
  @override
  Future<List<Movie>> searchMovies(String query) async{
    if(query.isEmpty) {//! Si el query esta vacio no hacer esa peticion http
      return [];//! Y DEVOLVER UNA LISTA DE MVOIE PERO VACIA
    }

    //* print('Peticion http hecha;');
    final response = await dio.get('/search/movie',
      queryParameters: {
        'query': query
      }
    );

    return _jsonToMovies(response.data);
  }
  
  
  //todo, Datasource que me da lista de peliculas similares de un id de una pelicula
  @override
  Future<List<Movie>> getMoviesSimilar(String id) async{
    final response = await dio.get('/movie/$id/similar');

    return _jsonToMovies(response.data /*as Map<String, dynamic>*/);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int moviId) async{
    final response = await dio.get('/movie/$moviId/videos');//* RESPUESTA HTTP
    final moviedbVideoResponse = MoviedbVideosResponse.fromJson(response.data);//* MAPPEAR LA DATA
    final videos = <Video>[];//* CREAR UNA LIST DE VIDEO VACIA

    //* CONTROLAR QUE SEAN SOLO DE YOUTUBE, SI NO ES NO DEVUELVE 
    for (final moviedbVideo in moviedbVideoResponse.results){
      if ( moviedbVideo.site == 'YouTube' ) {
        final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
        videos.add(video);//* LLENAR LA LIST DE VIDEO
      }
    }
    return videos;//* retornarla
  }  
}
