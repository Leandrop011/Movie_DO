import 'package:flutter/material.dart';
import 'package:movies_app/presentation/widgets/shared/custom_settings_cards.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings View'),
      ),
      body: ListView.builder(
        itemCount: types.length,
        itemBuilder: (context, index) {
          final String type = types[index];
          final Icon icon = icons[index];

          return CustomSettingsCards(type: type, icon: icon,);
        },
      )
    );
  }
}

//* LISTADO DE LOS TIPOS DE SETTINGS
final List<String> types = [
  'Cambiar Tema',
  'Cambiar Fondo'
];
final List<Icon> icons =[
  Icon(Icons.palette_outlined),
  Icon(Icons.light_mode_outlined)
];
