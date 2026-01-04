import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

//!EL COMANDO ES PARA QUE GENERE CODIGO Y NOS DE TABLAS DE DRIFT, Y DEMAS COSAS PARA GESTIONAR LA DATA
//!AQUI SIEMPRE MARCA ERROR SI NO SE EJECUTA EL COMANDO -> dart run build_runner watch
part 'database.g.dart';

// class TodoItems extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get title => text().withLength(min: 6, max: 32)();
//   TextColumn get content => text().named('body')();
//   DateTimeColumn get createdAt => dateTime().nullable()();
// }

//!BASE DE DATOS SQLITE QUE GUARDARA LA INFORMACION LOCALMENTE DE LAS MOVIES FAVORITAS
//!OJO QUERES HACER CAMBIOS DE ESTA BASE DE DATOS EN CALIENTE REQUIERE MIGRACION
//!O REINSTALAR LA APLICACION
class FavoritesMovies extends Table{ 
  //* el named es para renombrarlo
  //* Intcolumn numeros entero
  //* TextColumn texto(la imagen tambien por su url)
  //* RealColumn numeros con decimales
  IntColumn get id => integer().autoIncrement()();//* ID DE NUESTRA BASE DE DATOS
  IntColumn get movieId => integer().named('movie_id')(); //* ID QUE USAREMOS EN THEMOVIEDB
  TextColumn get backdropPath => text().named('backdrop_path')();
  TextColumn get originalTitle => text().named('original_title')();
  TextColumn get posterPath => text().named('poster_path')();
  TextColumn get title => text()();
  RealColumn get voteAverage => real().named('vote_average').withDefault(Constant(0.0))();
  //* EL WITHDEFAULT ES UN VALOR POR DEFECTO
}

//TODO, IMPLEMENTAR UNA BASE DE DATOS QUE GUARDE LOCALMENTE EL FOUNT AND THEME



@DriftDatabase(tables: [FavoritesMovies])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'favorites_db.sqlite',//! esto hay que cmabiarlo si hay muchas base de datos
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}

final db = AppDatabase();

