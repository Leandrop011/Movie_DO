import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
import 'package:movies_app/features/movies/presentation/widgets/widgets.dart';
import 'package:movies_app/config/theme/theme.dart';

import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConfigThemeScreen extends StatelessWidget {
  const ConfigThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Temas'),

        actions: [
          IconButton(
            onPressed: (){
              CustomInfomakeShowdialog.infoMake(
                context,
                'Informacion', 
                'Aquí puedes cambiar el tema de la aplicación, simplemente debes tocar algun color y listo, el tema de la app se cambiará automáticamente.', 
                [
                  FilledButton(
                    onPressed: (){
                      context.pop();
                    }, 
                    child: Text('Ok'),
                  )
                ], 
                textTheme,
              );
            }, 
            icon: Icon(Icons.info_outline_rounded, color: colorTheme.primary,),
          )
        ],
      ),

      body: _BodyView(),
    );
  }
}

class _BodyView extends StatelessWidget {
  const _BodyView();

  @override
  Widget build(BuildContext context) {

    final themes = colorsTheme;
    final themesName = colorsNameTheme;

    return ListView.builder(
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final color = themes[index];
        final colorName = themesName[index];

        return FadeInUp(child: _CardView(color: color, index: index, colorName: colorName,));
      },
    );
  }
}

class _CardView extends ConsumerWidget {
  final int index;
  final Color color;
  final String colorName;
  const _CardView({
    required this.color, 
    required this.index, 
    required this.colorName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final themeColorIndex = ref.watch(themeProvider).indexTheme;
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final fount = ref.watch(isdarckProvider).fount;
      
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => ref.read(themeProvider.notifier).setTheme(themeColorIndex),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size.width,
          height: size.height * 0.1,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 0.5,
              color: fount?
              Colors.white54
              :
              Colors.black45,
            ),
          ),
          child: RadioListTile(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(5)
            ),

            title: Text(
              colorName,
              style: textTheme.bodyMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.normal),

            ),
            // subtitle: Text('${color.hashCode}'),
            
            // * ESTE ES EL VALUE QUE RESPONDE, SEGUN EL INDEX QUE ESTE SELECCIONADO
            value: index,
          
            activeColor: Colors.white,
            
            groupValue: themeColorIndex,
          
            // ? AQUI CAD AQUE PULSE UN RADIO, HACE UN CAMBIO Y LOS WIDGETS POR EL PROVIDER, HACEN SUS 
            // ? CONSIDERACIONES Y SE REDIBUJAN
            onChanged: (value) {
              HapticFeedback.lightImpact();

              // ? pasamos el index del list, y ese es al tema que cambiara
              ref.read(themeProvider.notifier).setTheme(index);
            },
          ),
        ),
      ),
    );
  }
}
