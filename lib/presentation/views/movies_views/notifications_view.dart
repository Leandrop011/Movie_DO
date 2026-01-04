import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/domain/entities/push_messages.dart';
import 'package:movies_app/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:movies_app/presentation/providers/config/isdarck_provider.dart';

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key}); 

  void _infoMake(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Notificaciones'),
        content: Text('Aquí podrás visualizar todas tus notificaciones y alertas importantes. Mantente al día con las actualizaciones, mensajes y recordatorios de la aplicación. Desliza para eliminar notificaciones individuales o toca sobre ellas para ver más detalles.'),
        actions: [
          FilledButton(
            onPressed: (){
              context.pop();
            }, 
            child: Text('Ok')
          )
        ],
      ),
    );
  }

  void _snackBar (BuildContext context, String message, bool isDarck){
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDarck ?
      Colors.white70
      :
      Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10)
      ),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = context.watch<NotificationsBloc>().state.status;
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final isDarck = ref.watch(isdarckProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('NOTIFICACIONES'),

          leading: IconButton(
            onPressed: (){
              context.read<NotificationsBloc>().requestPermission();

              if (status == AuthorizationStatus.authorized) {
                _snackBar(context, 'Ya se autorizaron las notificaciones.', isDarck);
              }
            }, 
            icon: status != AuthorizationStatus.authorized ?
            Icon(FontAwesomeIcons.bellSlash, color: colors.primary,)
            :
            Icon(FontAwesomeIcons.solidBell, color: colors.primary,)
          ),
        actions: [
          IconButton(
            onPressed: (){
              _infoMake(context);
            }, 
            icon: Icon(Icons.info_outline)
          )
        ],
      ),
      body: (status != AuthorizationStatus.denied) ?
            _NotificationsView()
            :
            _NotPermissionNotificationsView(colors: colors, textStyle: textStyle)
    );
  }
}

class _NotPermissionNotificationsView extends StatelessWidget {
  const _NotPermissionNotificationsView({
    super.key,
    required this.colors,
    required this.textStyle,
  });

  final ColorScheme colors;
  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 180, color: colors.primary,),
          SizedBox(height: 30,),
          Text('Aun no has permitido\nlas notificaciones :(', style: textStyle.titleMedium, textAlign: TextAlign.center,),
          SizedBox(height: 30,),
          FilledButton(
            onPressed: (){
              context.read<NotificationsBloc>().requestPermission();
            }, 
            child: Text('Permitir Notificaciones'),
          )
        ],
      ),
    );
  }
}


class _NotificationsView extends StatelessWidget {

  const _NotificationsView(); 
  @override
  Widget build(BuildContext context) {

    final List<PushMessages> notifications = context.watch<NotificationsBloc>().state.notifications;
    //final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_paused_outlined, size: 180, color: colors.primary,),
            SizedBox(height: 30,),
            Text('Aun no has recibido\nnotificaciones', style: textStyle.titleMedium, textAlign: TextAlign.center,)
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int index) {
        final notification = notifications[index];
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.push('/push-details/${notification.messageId}');
          },
          child: ListTile(
            title: Text(notification.tittle),
            subtitle: Text(notification.body),
            leading: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Image.network(
                notification.imageUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
          
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          
          ),
        );
      },
    );
  }
}



