import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/config/config.dart';
import 'package:movies_app/features/index.dart';
import 'package:movies_app/features/movies/presentation/providers/config/fount_provider.dart';

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
              width: size.width * 0.5,
              height: size.height * 0.5,
              child: Center(
                child: fount ?
                Image.asset(
                  width: double.infinity,
                  height: double.infinity,
                  'assets/logo_app/logo_app_without_fount.png',
                  fit: BoxFit.cover,
                )
                :
                Image.asset(
                  width: double.infinity,
                  height: double.infinity,
                  'assets/logo_app/logo_app_without_fount_black.png',
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

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 58),
      child: CustomScrollView(
        slivers: [
          // ? APP BAR DE LOS SLIVERS
          _AppBarView(),
      
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

// * INFORMACION DE CONTENIDO
final items = <MenuItem>[
  MenuItem(title: 'Fondo', icon: Icons.brightness_6_rounded, route: '/fount'),
  MenuItem(title: 'Tema', icon: Icons.palette_rounded, route: '/theme'),
  MenuItem(title: 'Seguridad', icon: Icons.security, route: '/security'),
];

// * CONTENIDO
class _BodyView extends StatelessWidget {
  const _BodyView();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          return SliverGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,
      
            children: items.map(
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
                child: Icon(icon, color: Colors.white, size: size.width * 0.08),
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
  const _AppBarView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final fount = ref.watch(isdarckProvider).fount;

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
              'Tema, Fondo y Seguridad',
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
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 35, 49, 120),
                Color.fromARGB(255, 38, 41, 174),
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
              'En esta sección podrás personalizar la apariencia de la app\neligiendo el tema y fondo que más se adapte a tu estilo,\nademas de configurar opciones de seguridad\npara proteger tu experiencia.', 
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

