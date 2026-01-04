import 'package:drift/drift.dart';
import 'package:movies_app/config/database/notifications/database_notifications.dart';
import 'package:movies_app/domain/data_sources/local_notifications_datasource.dart';
import 'package:movies_app/domain/entities/push_messages.dart';

class DriftNotificationsDatasourceImplementation extends  LocalNotificationsDatasource{

  final AppNotificationsDatabase database;

  DriftNotificationsDatasourceImplementation([AppNotificationsDatabase? databaseToUse])
                  : database  = databaseToUse ?? dbNotifications;

 @override
Future<List<PushMessages>> getAllNotifications({int limit = 13, int offset = 0}) async {
  //! 1. Construir el query con paginación
  final query = database.select(database.notifications)
    ..orderBy([
      (tbl) => OrderingTerm.desc(tbl.id),
    ])
    ..limit(limit, offset: offset); // Limitar resultados y offset para paginación
  
  //! 2. Ejecutar el query
  final notificationDataList = await query.get();
  
  //! 3. Convertir y retornar
  return notificationDataList.map((data) {
    return PushMessages(
      messageId: data.messageId,
      tittle: data.titleMessage,
      body: data.bodyMessage,
      imageUrl: data.imageUrl,
      sentData: DateTime.now(),
    );
  }).toList();
}
  
  @override
  Future<void> saveNotification(PushMessages notification) async {
    //! Lo crea para guardarlo
    final notificationData = NotificationsCompanion.insert(
      messageId: notification.messageId,
      titleMessage: notification.tittle,
      bodyMessage: notification.body,
      imageUrl: notification.imageUrl!,
    );
    
    //! 2. Construir el query de inserción
    final insertStatement = database.into(database.notifications);
    
    //! 3. Ejecutar el query
    await insertStatement.insert(
      notificationData,
      mode: InsertMode.insertOrReplace,
    );
  }
}