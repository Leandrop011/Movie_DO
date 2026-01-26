import 'package:flutter/material.dart';
import 'package:movies_app/domain/entities/push_messages.dart';
import 'package:movies_app/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsScreen extends StatelessWidget {
  final String pushMessageId;

  const DetailsScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {

    final PushMessages? message = context.watch<NotificationsBloc>().getMessageById(pushMessageId);
    return Scaffold(
      appBar: AppBar( 
        title: Text('Detalles'),
      ),
      body: (message != null) ?//! Body condicional
            _DetailsView(message: message)
            :
            Center(child: Text('Notificacion no existente'),),
    );
  }
}
class _DetailsView extends StatelessWidget {

  final PushMessages message;

  const _DetailsView({required this.message});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          if(message.imageUrl != null)
            Image.network(message.imageUrl!),

          SizedBox(height: 10,),
          Text(message.tittle, style: textStyle.titleMedium,),
          Text(message.body),

          Divider(),

          Text(message.data.toString())
        ],
      ),
    );
  }
}