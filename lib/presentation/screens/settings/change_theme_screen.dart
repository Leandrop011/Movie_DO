import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/config/theme/app_theme.dart';
import 'package:movies_app/presentation/providers/config/value_theme_provider.dart';

class ChangeThemeScreen extends StatelessWidget {
  const ChangeThemeScreen({super.key});
  static const String name = 'change_theme_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambio de Tema'),
        leading: IconButton(
          onPressed: (){
            context.pop();
          }, 
          icon: Icon(Icons.arrow_back_ios_new)
        ),
      ),
      body: _ThemeChangerView(),
    );
  }
}

class _ThemeChangerView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(valueThemeProvider);
    return ListView.builder(
      itemCount: colorsTheme.length,
      itemBuilder: (context, index) {

        final color = colorsTheme[index];
        final nameColor = colorsThemeNames[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(//! SE HACE ESTE PROCESO DE ENVOLVER EN MATERIAL PARA PODER CAMBIAR LA ANIMACION DE 'TOCAR', PORQUE ESA ANIMACION VIENE POR DEFECTO
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(20)
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: color)
              ),
              child: RadioListTile(
                
                value: index,
                title: Text(nameColor, style: TextStyle(color: color),),
                //subtitle: Text('${color.hashCode}'),
                activeColor: color,
                groupValue: value,//! EL QUE LE DA CHECK AL RADIO
                onChanged: (value) {//! EL QUE ACTUALIZA EL DATO
                  ref.read(valueThemeProvider.notifier).update((cb) => index);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}