import 'package:dio/dio.dart';
import 'package:movies_app/config/constants/environment.dart';
import 'package:movies_app/features/movies/domain/data_sources/actors_datasource.dart';
import 'package:movies_app/features/movies/domain/entities/actor.dart';
import 'package:movies_app/features/movies/infrastructure/mappers/actor_mapper.dart';
import 'package:movies_app/features/movies/infrastructure/models/moviedb/credits_response.dart';

//todo, DATASOURCE QUE BRINDA LA DATA DE LOS ACTORES Y AQUI MISMO MAPEAMOS Y ACOPLAMOS
class ActorMoviedbDatasourceImplementation extends ActorsDatasource{
  
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.movieDBKey,
      'language': 'es-MX'
    }
  ));
  
  //todo, DATA SOURCE DE LOS ACTORES
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