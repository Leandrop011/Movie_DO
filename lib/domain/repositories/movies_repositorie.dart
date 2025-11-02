import 'package:movies_app/domain/entities/movie.dart';
//todo, el repositorio es al que vamos a llamar, si queremos otro
//todo, datasource pues solo cambiaremos el repositorie
abstract class MoviesRepositorie {

  Future <List<Movie>>getNowPlaying({int page = 1});
}