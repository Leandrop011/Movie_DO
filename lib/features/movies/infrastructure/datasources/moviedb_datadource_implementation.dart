import 'package:dio/dio.dart';
import 'package:movies_app/config/constants/constants.dart';
import 'package:movies_app/features/movies/domain/data_sources/data_sources.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/infrastructure/mappers/mappers.dart';
import 'package:movies_app/features/movies/infrastructure/models/moviedb/moviedb.dart';


class MoviedbDatadourceImplementation extends MoviesDatasource{
  
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.movieDBKey,
      'language': 'es-MX'
    }
  ));

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {

    final movieDBresponse = MovideDbResponse.fromJson(json);


    final List<Movie> movies = movieDBresponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster' && moviedb.backdropPath != 'no-backdro')
    .map(
      (movie) => MovieMapper.movieDBToEntity(movie)
    ).toList();

    return movies;
  }
  
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async{
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);
  }
  

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
  

  @override
  Future<List<Movie>> getUpComing({int page = 1}) async{
    final response = await dio.get('/movie/upcoming',
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async{
    final response = await dio.get('/movie/top_rated',
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);

  }
  
  @override
  Future<Movie> getMovieById(String id) async{

    final response = await dio.get('/movie/$id');
 
    if(response.statusCode != 200 ) throw Exception('Movie with id: $id not found');


    final movieDBDetails = MovideDbDetails.fromJson(response.data);

    final Movie movie = MovieMapper.movieDetailsToEntity(movieDBDetails);

    return movie;
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async{
    if(query.isEmpty) {
      return [];
    }

    //* print('Peticion http hecha;');
    final response = await dio.get('/search/movie',
      queryParameters: {
        'query': query
      }
    );

    return _jsonToMovies(response.data);
  }
  
  
  @override
  Future<List<Movie>> getMoviesSimilar(String id) async{
    final response = await dio.get('/movie/$id/similar');

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int moviId) async{
    final response = await dio.get('/movie/$moviId/videos');
    final moviedbVideoResponse = MoviedbVideosResponse.fromJson(response.data);
    final videos = <Video>[];
 
    for (final moviedbVideo in moviedbVideoResponse.results){
      if ( moviedbVideo.site == 'YouTube' ) {
        final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
        videos.add(video);
      }
    }
    return videos;//* retornarla
  }  
}

