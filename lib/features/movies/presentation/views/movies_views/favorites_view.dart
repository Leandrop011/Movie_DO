import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
import 'package:movies_app/features/movies/presentation/widgets/movies/movies.dart';
import 'package:movies_app/features/movies/presentation/widgets/shared/shared.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();//!SIEMPRE COLOCARLO PRIMERO
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();//* PARA EMPEZAR EL PROCEDIMIENTO DE INICIALIZACION
    
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final movies = ref.watch(favoriteMoviesProvider);
    final myMovieList = movies.values.toList();//!TRANFORMAR A LISTA LAS MOVIES QUE VIENEN COMO MAPA
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    if(myMovieList.isEmpty){
      return _FavoritesEmptyView(colors: colors, textTheme: style);
    }
 
    return Scaffold(
      appBar: CustomAppbarTransparent(
        tittle: 'FAVORITAS', 
        leadingIcon: Icons.add_box_outlined, 
        actions: [
          IconButton(
            onPressed: (){
              CustomInfomakeShowdialog.infoMake(
                context, 
                'Favoritas', 
                'En esta seccion podras ver todas las peliculas que marcaste como favoritas. Las peliculas se guardan en tu dispositivo, asi que siempre estaran disponibles incluso sin conexion. Puedes agregar o quitar una pelicula de favoritos desde su pantalla de detalle.', 
                [
                  FilledButton(onPressed: (){
                    context.pop();
                  }, child: const Text('Ok')),
                ],
                style,
              );
            }, 
            icon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.info_outline, size: size.width * 0.065),
            )
          )
        ],
        blurIntensity: 50,
      ),
      
      body: MoviesMasonry( 
        movies: myMovieList, 
        loadNextPage: () => ref.read(favoriteMoviesProvider.notifier).loadNextPage(), //* el () => es porque espera una funcion
      ),
      
      
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

// ? WIDGET QUE MOSTRARA SI LA LISTA ESTA VACIA 
class _FavoritesEmptyView extends ConsumerWidget {
  const _FavoritesEmptyView({
    required this.colors,
    required this.textTheme,
  });

  final ColorScheme colors;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final fount = ref.watch(isdarckProvider).fount;
    final size = MediaQuery.of(context).size; 
    
    return Scaffold(

      body: Center(
        child: ZoomInDown(
          
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 0.5,
                color: fount ? Colors.white38 : Colors.black45
              ),
              color: fount? Colors.white10 : Colors.black12
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                SizedBox(
                  width: size.width * 0.7,
                  height: size.height * 0.4,
                  child: Image.asset(
                    width: double.infinity,
                    height: double.infinity,
                    (fount) ? 'assets/images/image_without_favorites_white.png' : 'assets/images/image_without_favorites_black.png',
                    fit: BoxFit.cover,
                  ),
                ),
                
                FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    )
                  ),
                    
                  onPressed: (){
                    context.go('/home/0');
                  }, 
                  child: Text(
                    'Empezar a Buscar',
                    style: textTheme.bodySmall?.copyWith(fontSize: 14, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

