import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database_config.g.dart';//! ESTE PART ES DEPENDIENDO EL NOMBRE DEL DART


// class TodoItems extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get title => text().withLength(min: 6, max: 32)();
//   TextColumn get content => text().named('body')();
//   DateTimeColumn get createdAt => dateTime().nullable()();
// }

class ConfigApp extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get theme => integer().named('index_theme')();
  BoolColumn get fount => boolean().named('bool_fount')();//* BOOLEANO
} 

@DriftDatabase(tables: [ConfigApp])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}
