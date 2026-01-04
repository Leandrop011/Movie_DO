import 'package:movies_app/domain/entities/push_messages.dart';

abstract class LocalNotificationsRepository {
  //Para mostrar en la APP
  Future<List<PushMessages>> getAllNotifications({int limit = 10, int offset = 0});
  
  // Para guardar cuando llega una notificación push
  Future<void> saveNotification(PushMessages notification);
  
}