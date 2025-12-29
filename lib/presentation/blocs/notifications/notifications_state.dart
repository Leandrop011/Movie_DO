part of 'notifications_bloc.dart';

class NotificationsState extends Equatable{
  final AuthorizationStatus status;
  final List<PushMessages> notifications;

  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined, 
    this.notifications = const []
  });

  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<PushMessages>? notifications,

  }) => NotificationsState(
    status: status ?? this.status,
    notifications: notifications ?? this.notifications
  );
  
  @override
  List<Object?> get props => [notifications, status];
}
