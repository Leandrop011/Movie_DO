
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/infrastructure/datasources/drift_notifications_datasource_implementation.dart';
import 'package:movies_app/infrastructure/repositories/local_notifications_repository_implementation.dart';
//! Porvider que nos provee el repositorio que nos da la list de notifications
final repositoryNotificationProvider = Provider(
  (ref){
    return LocalNotificationsRepositoryImplementation(datasource: DriftNotificationsDatasourceImplementation());
  }
);