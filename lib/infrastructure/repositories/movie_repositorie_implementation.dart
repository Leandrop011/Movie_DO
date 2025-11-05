//todo, lo que hara esta implementacion del respositorie
//todo, es llamar al datasource y ese datasourc va a llamar a esos metodos y 
//todo, obtenemos la info

import 'package:movies_app/domain/data_sources/movies_datasource.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/domain/repositories/movies_repositorie.dart';

class MovieRepositorieImplementation extends MoviesRepositorie{
  
  final MoviesDatasource datasource;

  MovieRepositorieImplementation( this.datasource );
 
  //* PRIMER REPOSITORY
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);//todo, le mandamos la page del datasource
  }
  
  //* SEGUNDO REPOSITORY
  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }
  
  //* TERCER REPOSITORY
  @override
  Future<List<Movie>> getUpComing({int page = 1}) {
    return datasource.getUpComing(page: page);
  }

  //* CUARTO REPOSITORY
  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }
  

  
  
}