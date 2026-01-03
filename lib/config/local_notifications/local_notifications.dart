
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:movies_app/config/router/app_router.dart';

//! LOCAL NOTIFICATIONS


class LocalNotifications  {
  //! 1. Primer Paso pedir permisos de recibir local notifications
  static Future<void> requestPermissionLocalNotifications() async{
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.
    requestNotificationsPermission();
  }

  //! 2. Segundo Paso Inicializar las local notifications
  static Future<void> initializeLocalNotifications() async{
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //* LA IMAGEN QUE TENDRA LA NOTIFICATION, LO BUSCARA EN LA CARPETA ANDROID/APP/SRC/MAIN/RES/DRAWABLE
    const initializationSettingsAndroid = AndroidInitializationSettings('logo1');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings, 
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
    );
  }

  //! 3 Tercer Paso para mostrar las local notifications
  static void showLocalNotifications( {
    required int id,
    String? title,
    String? body,
    String? data,
  }){

    const androidDetails = AndroidNotificationDetails(
      'channelId', 
      'channelName',
      playSound: true,
      //* UN SONIDO PERSONALIZADO DE LA NOTIFICATION, COLOCAMOS ESTO EN EL RAW(SE LA CREA) DE ANDROID
      //* Y COLOCAMOS EL NOMBRE DEL MP3 AQUI SIN .MP3
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high
    );

    //* para agregar los details
    const notificationDetails = NotificationDetails(
      android: androidDetails,

    );

    //! para pedir permiso
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //* Mostramos la local notification con la data que recibimos 
    flutterLocalNotificationsPlugin.show(
      id, 
      title, 
      body, 
      notificationDetails,
      payload: data
    );


  }

  //! 4. Cuarto paso para reaccionar al tocar y navegar hacia una pantalla de la local
  static void onDidReceiveNotificationResponse(NotificationResponse response ){
    //* Usamos el paylod, el paylod recibe ese id de l anotification
    appRouter.push('/push-details/${response.payload}');
  }
  
}