import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/presentation/providers/config/isdarck_provider.dart';
import 'package:movies_app/presentation/widgets/shared/custom_appbar_transparent.dart';
import 'package:movies_app/presentation/widgets/shared/custom_settings_cards.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  //* Metodo que construye un AlertDialog
  void _infoMake(BuildContext context){
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final isDarck = ref.watch(isdarckProvider);

    return Scaffold(
      appBar: CustomAppbarTransparent(
        tittle: 'AJUSTES',  
        leadingIcon: Icons.settings_suggest, 
        actions: [
          IconButton(
            onPressed: (){
              _infoMake(context);
            }, 
            icon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.info_outline, size: 30,),
            )
          )
        ]
      ),
      // appBar: AppBar(
      //   title: Text('AJUSTES', style: style.titleLarge,),
      //   centerTitle: false,
      //   leading: Padding(
      //     padding: const EdgeInsets.only(bottom: 7.0),
      //     child: Icon(Icons.settings_suggest, color: colors.primary, size: 33,),
      //   ),
      //   titleSpacing: 0,

      //   actions: [
      //     IconButton(
      //       onPressed: (){
      //         infoMake(context);
      //       }, 
      //       icon: Icon(Icons.info_outline)
      //     )
      //   ],
      // ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
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
                  width: size.width * 0.8,
                  height: size.height * 0.4,
                  'assets/settings/image_01.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
        
            Padding(
              padding: EdgeInsets.only(
                right: size.width * 0.04, 
                left: size.width * 0.04, 
                bottom: size.height * 0.02
              ),
              child: Container (
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: isDarck ?
                    Colors.white70
                    :
                    Colors.black54
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: SwitchListTile (
                  title: Text('Cambiar Fondo'),
                  value: isDarck, 
                  onChanged: (value) async {
                    await ref.read(isdarckProvider.notifier).setDark(value);
                  }
                ),
              ),
            ),

            //* CARD DE CHANGE THEME
            CustomSettingsCards(type: types[0], icon: icons[0], link: links[0],),
            
            // //* CARD DE CHANGE FOUNT
            // CustomSettingsCards(type: types[1], icon: icons[1], link: links[1],),
      
          ],
        ),
      )
    );
  }
}

//* LISTADOS PARA CADA CARD
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


