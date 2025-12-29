import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies_app/presentation/blocs/notifications/notifications_bloc.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<NotificationsBloc>().state.status;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
        actions: [
          IconButton(
            onPressed: (){
              context.read<NotificationsBloc>().requestPermission();
            }, 
            icon: status != AuthorizationStatus.authorized ?
            Icon(FontAwesomeIcons.bellSlash)
            :
            Icon(FontAwesomeIcons.solidBell)
          )
        ],
      ),
      body: _NotificationsView(), 
    );
  }
}


class _NotificationsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Hola'),
        );
      },
    );
  }
}



