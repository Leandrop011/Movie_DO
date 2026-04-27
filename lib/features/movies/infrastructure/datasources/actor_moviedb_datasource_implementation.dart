import 'package:dio/dio.dart';
import 'package:movies_app/config/constants/constants.dart';
import 'package:movies_app/features/movies/domain/data_sources/data_sources.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/infrastructure/mappers/mappers.dart';
import 'package:movies_app/features/movies/infrastructure/models/moviedb/moviedb.dart';

class ActorMoviedbDatasourceImplementation extends ActorsDatasource{
  
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.movieDBKey,
      'language': 'es-MX'
    }
  ));
  
  @override
  Future<List<Actor>> getActorByMovie(String movieid) async{
    // * respuesta
    final response = await dio.get('/movie/$movieid/credits');

    // * mapearla
    final castResponse = CastResponse.fromJson(response.data);

    // * mappaer cada actor a nuestra regla de negocio
    final List<Actor> actores = castResponse.cast.map(
      (actor) => ActorMapper.castToEntity(actor),
    ).toList();

    return actores;
  }

  
}

