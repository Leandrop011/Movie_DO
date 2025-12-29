part of 'notifications_bloc.dart';

abstract class NotificationsEvent {}



//! 1. Primer Evento de pedir permisos al usuario
class NotificationsStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  NotificationsStatusChanged( this.status );

}