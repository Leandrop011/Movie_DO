
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/domain/entities/push_messages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:movies_app/domain/repositories/local_notifications_repository.dart';
import 'package:movies_app/firebase_options.dart';


part 'notifications_event.dart';
part 'notifications_state.dart';

//! LA PARTE DE GUARDARLAS LOCALMENTE TAMBIEN LA IMPLEMENTAMOS AQUI 

//! PUSH NOTIFICATIONS 

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

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //* Es una funcion que no pied ningun argumento y regresa un future
  final Future<void> Function()? requestLocalNotificationPermissions;
  //* funcion para mostrar las local notifications para el show
  final void Function({
    required int id,
    String? title,
    String? body,
    String? data,
  })? showLocalNotification;
  
  //! para cargar y guardar las notificaciones localmente
  final LocalNotificationsRepository? notificationsRepository;

  NotificationsBloc(
    {this.requestLocalNotificationPermissions, this.showLocalNotification, this.notificationsRepository}
  ) : super(NotificationsState()) {
    //* Handler que pide permisos
    on<NotificationsStatusChanged>(_notificationsStatusChanged);
    //* Handler que recibe la data 
    on<NotificationReceived>(_onPushMessageReceived);
    //* Handler para cargar las notificaciones guardadas(SI ES QUE HAY LAS CARGA)
    on<LoadSavedNotifications>(_onLoadSavedNotifications);
    //* Metodo que le pregunta al proyecto de firebase y le dice si ese user ya acepto o no las notificaciones
    //* Verificar estado de las notificaciones
    _initialStatusCheck();
    //* Colocamos el Stream de las notifications Foreground desde el inicio de la app
    //* Listener para notificaciones en Foreground
    _onForegroundMessage();


    requestPermission();

    //* desde el inicio cargarlas
    add(LoadSavedNotifications());
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

  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationsState> emit){
    emit(
      state.copyWith(
        //! agregar un nuevo message a la lista y conservar el estado anterior
        notifications: [event.message ,...state.notifications]
      )
    );
  }

  void _onLoadSavedNotifications(LoadSavedNotifications event, Emitter<NotificationsState> emit) async {
    if (notificationsRepository == null) return;
    
    // Vamos a la base de datos
    final savedNotifications = await notificationsRepository!.getAllNotifications();
    
    if (savedNotifications.isEmpty) return;

    // Actualizamos el estado con lo que había guardado
    emit(state.copyWith(
      notifications: savedNotifications
    ));
  }

  //! 1. Primer Paso, pedir permisos al usuario
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

    //! PARA PEDIR PERMISO PARA LAS LOCAL NOTIFICATIONS
    if(requestLocalNotificationPermissions != null){
      await requestLocalNotificationPermissions!();
      //await LocalNotifications.requestPermissionLocalNotifications(); 
    }

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

  //! 4. Cuarto paso Obtener el token de la instalacion en el dispositivo del usuario
  void _getFCMToken() async{
    final settings = await messaging.getNotificationSettings();
    if(settings.authorizationStatus != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    print('$token');
  }

  //! 5. Quinto Paso recibir Foreground y Background notifications
  void handleRemoteMessage( RemoteMessage message ) async{
    if (message.notification == null) return;

    final notification = PushMessages(
      //! se quita el : y el % porque pueden romper el go router 
      messageId: message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '', 
      tittle: message.notification!.title?? '', 
      body: message.notification!.body ?? '', 
      sentData: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid ?
                message.notification!.android?.imageUrl ?? ''
                :
                message.notification!.apple?.imageUrl ?? ''
    );
    
    if (notificationsRepository != null) {
      await notificationsRepository!.saveNotification(notification);
    }

    //? Local notification cuando ya recibi la data de la push, se la mando a la local
    //? para su construccion
    //? esto esta ed alguna forma conectado con las push asi que usamos esa misma data
     if(showLocalNotification != null){
      showLocalNotification!(
        id: 1,
        body: notification.body,
        data: notification.messageId,
        title: notification.tittle
      );
     }

    //* Agregar el evento de recibir la notification (data) y se lo agrega al handler
    add(NotificationReceived(notification));
  }
  //! 6. Sexto Paso escuchar el mesnaje que vendra para el Foreground notification
  void _onForegroundMessage(){
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  //! 8. Octavo Paso Obtener una notificacion push segun su id 
  PushMessages? getMessageById(String pushMessageId){
    //! Para saber si existe alguna notificacion con ese ID
    final exist = state.notifications.any((element) => element.messageId == pushMessageId);

    if(!exist) return null;
    
    //* regresa el elemento primero que cumpla esa condicion
    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }
  
}

//! 7. Septimo Paso Recibir notifications Terminated y Background(esto ira en el main)
Future<void> firebaseMessagingTerminatedHandler( RemoteMessage message ) async{

  await Firebase.initializeApp();

}
