
import 'package:movies_app/domain/data_sources/local_notifications_datasource.dart';
import 'package:movies_app/domain/entities/push_messages.dart';
import 'package:movies_app/domain/repositories/local_notifications_repository.dart';

class LocalNotificationsRepositoryImplementation extends LocalNotificationsRepository {
  final LocalNotificationsDatasource datasource;

  LocalNotificationsRepositoryImplementation({required this.datasource});

  
  @override
  Future<List<PushMessages>> getAllNotifications({int limit = 10, int offset = 0}) {
    return datasource.getAllNotifications(limit: limit, offset: offset);
  }

  @override
  Future<void> saveNotification(PushMessages notification) {
    return datasource.saveNotification(notification);
  }
  
}