import 'package:movies_app/domain/entities/push_messages.dart';

//* LA FORM
abstract class LocalNotificationsDatasource {
  //Para mostrar en la APP
   Future<List<PushMessages>> getAllNotifications({int limit = 13, int offset = 0});
  
  // Para guardar cuando llega una notificación push
  Future<void> saveNotification(PushMessages notification);
  
}