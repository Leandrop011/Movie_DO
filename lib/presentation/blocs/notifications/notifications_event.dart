part of 'notifications_bloc.dart';

abstract class NotificationsEvent {}



//! 1. Primer Evento de pedir permisos al usuario
class NotificationsStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  NotificationsStatusChanged( this.status );

}

//! 2. Segundo Evento de Recivir los datos de la Notificacion
class NotificationReceived extends NotificationsEvent {
  final PushMessages message;

  NotificationReceived( this.message );
}

//! 3. Tercer Evento de cargar las notificaciones guardadas en la base de datos
class LoadSavedNotifications extends NotificationsEvent {
  LoadSavedNotifications();
}