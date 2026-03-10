import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/config/config.dart';
import 'package:movies_app/features/features.dart';
import 'package:movies_app/features/movies/presentation/providers/config/fount_provider.dart';
import 'package:movies_app/features/movies/presentation/providers/local_auth/local_auth_providers.dart';

class ConfigView extends ConsumerStatefulWidget {
  const ConfigView({super.key});

  @override
  ConsumerState<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends ConsumerState<ConfigView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final size = MediaQuery.of(context).size;
    final fount = ref.watch(isdarckProvider).fount;

    return FadeInDown(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [

            SizedBox(
              width: size.width * 0.65,
              height: size.height * 0.5,
              child: Center(
                child: fount ?
                Image.asset(
                  width: double.infinity,
                  height: double.infinity,
                  'assets/logo_app/logo_app_without_fount_with_words_white.png',
                  fit: BoxFit.cover,
                )
                :
                Image.asset(
                  width: double.infinity,
                  height: double.infinity,
                  'assets/logo_app/logo_app_without_fount_with_words_black.png',
                  fit: BoxFit.cover,
                )
              ),
            ),

            _SettingsView(),
          ],
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class _SettingsView extends ConsumerWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final existBiometrics = ref.watch(existBiometricProvider).value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 58),
      child: CustomScrollView(
        slivers: [
          // ? APP BAR DE LOS SLIVERS
          _AppBarView(existBiometrics: existBiometrics ?? false,),
      
          // ? CONTENIDO DE LA PANTALLA
          _BodyView()
      
        ],
      ),
    );
  }
}

// * CLASE DE CADA ITEM DE INFORMACION DE CONTENIDO
class MenuItem {
  final String title;
  final IconData icon;
  final String route;

  MenuItem({
    required this.title, 
    required this.icon, 
    required this.route
  });
}

// * INFORMACION DE CONTENIDO CON BIOMETRICOS
final itemsWithBiometrics = <MenuItem>[
  MenuItem(title: 'Fondo', icon: Icons.brightness_6_rounded, route: '/fount'),
  MenuItem(title: 'Tema', icon: Icons.palette_rounded, route: '/theme'),
  
  MenuItem(title: 'Seguridad', icon: Icons.security, route: '/security'),
];

// * INFORMACION DE CONTENIDO SIN BIOMETRICOS
final itemsWithOutBiometrics = <MenuItem>[
  MenuItem(title: 'Fondo', icon: Icons.brightness_6_rounded, route: '/fount'),
  MenuItem(title: 'Tema', icon: Icons.palette_rounded, route: '/theme'),
  
];

// * CONTENIDO
class _BodyView extends ConsumerWidget {
  const _BodyView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final existBiometrics = ref.watch(existBiometricProvider);


    return SliverPadding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          return SliverGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,

            // ! SEGUN EL VALOR DE QUE SI ES POSIBLE LEER O EL DISPOSITIVO ES CAPAZ POR LA PARTE DEL HARDWARE, DE LEER BIOMETRICOS
            // ! SEGUN ESO DEVOLVERA SOLO UNO DE LOS MAPS, SI TIENE PUES DEVUELVE EL MAP CON 3 ELEMENTOS, SI NO TIENE BIOMETRICOS O 
            // ! NO TIENE LA CAPACIDAD DE HARDWARE PUES DEVUELVE UN MAP SOLO CON 2 ELEMEENTOS SIN LA POSIBILIDAD DE AGREGAR SEGURIDAD
            children: existBiometrics.when(
              data: (existValue) => existValue ?
               itemsWithBiometrics.map(
                (item) => FadeInDown(
                  duration: const Duration(seconds: 1),
                  curve: Curves.elasticInOut,
                  child: _CardView(
                    title: item.title,
                    icon: item.icon,
                    route: item.route,
                  ),
                ),
              ).toList()
              :
              itemsWithOutBiometrics.map(
                (item) => FadeInDown(
                  duration: const Duration(seconds: 1),
                  curve: Curves.elasticInOut,
                  child: _CardView(
                    title: item.title,
                    icon: item.icon,
                    route: item.route,
                  ),
                ),
              ).toList(),
              error: (error, stackTrace) => [Text('Error: $error')], 
              loading: () => [CircularProgressIndicator()],
            ),
      
            // children: itemsWithBiometrics.map(
            //   (item) => FadeInDown(
            //     duration: const Duration(seconds: 1),
            //     curve: Curves.elasticInOut,
            //     child: _CardView(
            //       title: item.title,
            //       icon: item.icon,
            //       route: item.route,
            //     ),
            //   ),
            // ).toList(),
          );
        },
      ),
    );
  }
}

// * VIEW DE CADA CARD
class _CardView extends StatelessWidget {
  
  final String title;
  final IconData icon;
  final String route;
  
  const _CardView({  
    required this.title, 
    required this.icon, 
    required this.route
  });

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final colorTheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.push(route),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: CustomAppCard(
          // padding: const EdgeInsets.all(5),
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              // ? ICONO Y SU CAJA
              Container(
                width: size.width * 0.17,
                height: size.height * 0.07,
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 143, 143, 143).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(icon, color: colorTheme.primary, size: size.width * 0.08),
              ),

              const SizedBox(height: 12),

              // ? DESCRIPCION
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// * APP BAR
class _AppBarView extends ConsumerWidget {

  final bool existBiometrics;

  const _AppBarView({required this.existBiometrics});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final fount = ref.watch(isdarckProvider).fount;
    final colorTheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      pinned: false,
      floating: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      expandedHeight: size.height * 0.14,
      flexibleSpace: FlexibleSpaceBar(  
      
        // * SEPARACION
        titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
        
        // * LO QUE CONTENDRA
        title: Column(
          // ! definimos el tamano minimo en el sliver
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajustes',
              style: textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            SizedBox(height: 5,),
            Text(
              (existBiometrics) ? 'Tema, Fondos y Seguridad': 'Tema y Fondos',
              style: textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          ],
        ),

        // * DECORACION
        background: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: fount ?
              Colors.white38
              :
              Colors.grey,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                colorTheme.primary,
              ],
            ),
            
            borderRadius: BorderRadius.circular(20),
          ),
        ),

      ),
      
      // * ACTIONS DE LA PARTE DERECHA
      actions: [
        IconButton(
          onPressed: (){
            CustomInfomakeShowdialog.infoMake(
              context, 
              'Ajustes', 
              (existBiometrics) ? 'En esta sección podrás personalizar la apariencia de la app eligiendo el tema y fondo que más se adapte a tu estilo, ademas de configurar opciones de seguridad para proteger tu experiencia.': 'En esta sección podrás personalizar la apariencia de la app eligiendo el tema y fondo que más se adapte a tu estilo.', 
              [
                // * BOTON DE REGRESO
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
          icon: Icon(Icons.info_outline, color: Colors.white, size: size.width * 0.07,)
        )
      ],

    );
  }
}


