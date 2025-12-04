import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/presentation/widgets/shared/custom_settings_cards.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  //* Metodo que construye un AlertDialog
  void infoMake(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Ajustes'),
          content: Text('En esta sección puedes personalizar la apariencia de la app. Aquí encontrarás opciones para cambiar el tema, modificar la fuente y ajustar detalles visuales para que la experiencia se adapte a ti.'),
          actions: [
            FilledButton(
              onPressed: (){
                context.pop();
              }, 
              child: Text('Ok'),
            )
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes', style: style.titleLarge,),
        centerTitle: false,
        leading: Icon(Icons.settings_outlined, color: colors.primary,),
        titleSpacing: 0,

        actions: [
          IconButton(
            onPressed: (){
              infoMake(context);
            }, 
            icon: Icon(Icons.info_outline)
          )
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: size.width * 0.04, 
              left: size.width * 0.04,
              top: size.height * 0.01, 
              bottom: size.height * 0.025
            ),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Image.asset(
                'assets/settings/image_01.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: types.length,
              itemBuilder: (context, index) {
                final String type = types[index];
                final IconData icon = icons[index];
                final String link = links[index];
            
                return CustomSettingsCards(type: type, icon: icon, link: link,);
              },
            ),
          ),
        ],
      )
    );
  }
}

//* LISTADO DE LOS TIPOS DE SETTINGS
final List<String> types = [
  'Cambio de Tema',
  'Cambio de Fondo'
];
final List<IconData> icons =[
  Icons.palette_outlined,
  Icons.light_mode_outlined
];

final List<String> links = [
  'theme',
  'fount'
];


