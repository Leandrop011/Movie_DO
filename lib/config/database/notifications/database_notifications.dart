import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database_notifications.g.dart';

// class TodoItems extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get title => text().withLength(min: 6, max: 32)();
//   TextColumn get content => text().named('body')();
//   DateTimeColumn get createdAt => dateTime().nullable()();
// }
//! BASE DE DATOS QUE ALMACENARA DE FORMA LOCAL LAS NOTIFICATIONS QUE RECIBA 
//! EL USUARIO EN SU DEVICE, SE GUARDARAN LOCALMENTE
class Notifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get messageId => text().named('message_id')();
  TextColumn get titleMessage => text().named('message_title')();
  TextColumn get bodyMessage => text().named('body_message')();
  TextColumn get imageUrl => text().named('image_message')();
  TextColumn get data => text().nullable()(); 
}

@DriftDatabase(tables: [Notifications])
class AppNotificationsDatabase extends _$AppNotificationsDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppNotificationsDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  //! VERSION DE LA DATABASE, 
  //! SI ES NUEVA ESCOGER 1
  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'notifications_app.sqlite',
      native: DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}

final dbNotifications = AppNotificationsDatabase();
