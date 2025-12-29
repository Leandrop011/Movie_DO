import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/domain/entities/push_messages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:movies_app/firebase_options.dart';


part 'notifications_event.dart';
part 'notifications_state.dart';
//!PRIMERO VINCULAR LA APP CON UN PROYECTO DE FIREBASE
/*
  1. Primero crear un Proyecto en Firebase
  2. Cambiar Id de la App a uno personalizado exmp 'com.pozo.movies'
  3. Instalar el paquete firebaseCore (Documentation)
  4. Instalar el Firebase CLI
  5. Instalar dart pub global activate flutterfire_cli
  6. Instalar flutterfire configure, y escojer el proyecto
*/

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsState()) {
    //* Handler que pide permisos
    on<NotificationsStatusChanged>(_notificationsStatusChanged);


    //* Metodo que le pregunta al proyecto de firebase y le dice si ese user ya acepto o no las notificaciones
    _initialStatusCheck();
  }

  //! METODOS PARA MANEJAR LOS HANDLRES
  //* Para cambiar el estado cuando se permitan las notifications o no 
  void _notificationsStatusChanged(NotificationsStatusChanged event, Emitter<NotificationsState> emit){
    //* Aqui emitimos un nuevo evento, y cuando se haga watch redibujara el widget
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getFCMToken();
  }

  //! 1. Primer Paso, pedir permisos al usuario
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void requestPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true
    );  

    //! AQUI LE DAMOS EL VALOR AL BLOC
    add(NotificationsStatusChanged(settings.authorizationStatus));
  }

  //! 2. Segundo Paso Inicializar Firebase en la App
  static Future<void> initializeFCM () async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }

  //! 3. Tercer Paso para que el bloc cargue si ya acepto o no los permisos
  void _initialStatusCheck() async{
    final settings = await messaging.getNotificationSettings();
    add(NotificationsStatusChanged(settings.authorizationStatus));
    
  }

  //! 4 Cuarto paso Obtener el token de la instalacion en el dispositivo del usuario
  void _getFCMToken() async{
    final settings = await messaging.getNotificationSettings();
    if(settings.authorizationStatus != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    print('token: $token');
  }

  
}
