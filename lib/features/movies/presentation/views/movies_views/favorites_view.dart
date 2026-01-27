import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/movies/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:movies_app/features/movies/presentation/widgets/movies/movies_masonry.dart';
import 'package:movies_app/features/movies/presentation/widgets/shared/custom_appbar_transparent.dart';
import 'package:movies_app/features/movies/presentation/widgets/shared/custom_infomake_showdialog.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> with AutomaticKeepAliveClientMixin{

  @override
  void initState() {
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();//* PARA EMPEZAR EL PROCEDIMIENTO DE INICIALIZACION
    super.initState();//!SIEMPRE COLOCARLO PRIMERO
    
  }

  //* SHOW DIALOG PARA DAR INFORMACION DE LA PANTALLA FAVORITAS MOVIES
  // void _infoMake(BuildContext context){
  //   showDialog(
  //     context: context, 
  //     barrierColor: Colors.black.withOpacity(0.5),
      
  //     builder: (context) {
  //       return BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //         child: AlertDialog(
  //           title: Text('Favoritas'),
  //           content: Text('En esta sección podrás ver todas las películas que marcaste como favoritas. Las películas se guardan en tu dispositivo, así que siempre estarán disponibles incluso sin conexión. Puedes agregar o quitar una película de favoritos desde su pantalla de detalle.'),
  //           actions: [
  //             FilledButton(
  //               onPressed: (){
  //                 context.pop();
  //               }, 
  //               child: Text('OK')
  //             )
  //           ],
            
  //         ),
  //       );
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    super.build(context);

    final movies = ref.watch(favoriteMoviesProvider);
    final myMovieList = movies.values.toList();//!TRANFORMAR A LISTA LAS MOVIES QUE VIENEN COMO MAPA
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    if(myMovieList.isEmpty){
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 100, color: colors.primary,),
              Text('Ohhhh no!!!', style: style.titleLarge!.copyWith(color: colors.primary),),
              SizedBox(height: 15,),
              Text('Sin peliculas Favoritas', style: style.titleMedium,),
              
              SizedBox(height: 20,),
              
              FilledButton(
                onPressed: (){
                  context.go('/home/0');
                }, 
                child: Text('Empezar a Buscar')
              )
            ],
          ),
        ),
      );
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
                'En esta sección podrás ver todas las películas que marcaste como favoritas. Las películas se guardan en tu dispositivo, así que siempre estarán disponibles incluso sin conexión. Puedes agregar o quitar una película de favoritos desde su pantalla de detalle.', 
                [
                  FilledButton(onPressed: (){
                    context.pop();
                  }, child: Text('Ok')),
                ],
                style,
              );
            }, 
            icon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.info_outline, size: size.width * 0.075),
            )
          )
        ]
      ),
      // appBar: AppBar(
      //   leading: Icon(Icons.add_box_outlined, color: colors.primary, size: 30,),
      //   title: Text('FAVORITAS', style: style.titleLarge),
      //   centerTitle: false,
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


      body: MoviesMasonry( 
        movies: myMovieList, 
        loadNextPage: () => ref.read(favoriteMoviesProvider.notifier).loadNextPage(), //* el () => es porque espera una funcion
      ),
      
      
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}