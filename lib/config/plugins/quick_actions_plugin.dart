//? PATRON ADAPTADOR DE QUICK ACTIONS
import 'package:movies_app/config/router/router.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickActionsPlugin {

  //? METODO QUE CREA LAS QUICK ACTIONS
  static void registerActions({String? movieId, String? titleMovie}){



    //* INSTANCIA DEL PAQUETE 
    const QuickActions quickActions = QuickActions();


    //* NAVEGACION DEPENDIENDO DEL QUICK ACTION TYPE
    if (movieId != null && movieId.isNotEmpty) {
      quickActions.initialize((shortcutType) {
        switch (shortcutType) {
          case 'home':
            appRouter.go('/home/0');
          break;
          case 'popular':
            appRouter.go('/home/1');
          break;
          case 'favorites':
            appRouter.go('/home/2');
          break;

          case 'movie':

            if(movieId.isEmpty){
              appRouter.go('/home/0');
            }

            appRouter.push('/home/0/movie/$movieId');

          break;
          default:
        }
      });

      // * CREACION DE LAS QUICK ACTIONS(los icons en drawable con mismo name de el type)
      quickActions.setShortcutItems(<ShortcutItem>[
        const ShortcutItem(type: 'home', localizedTitle: 'Principal', icon: 'home'),
        const ShortcutItem(type: 'popular', localizedTitle: 'Populares', icon: 'popular'),
        const ShortcutItem(type: 'favorites', localizedTitle: 'Favoritas', icon: 'favorites'),
        ShortcutItem(type: 'movie', localizedTitle: titleMovie ?? 'Ultima Pelicula Vista', icon: 'movie'),
      ]);
    }else{
      quickActions.initialize((shortcutType) {
        switch (shortcutType) {
          case 'home':
            appRouter.go('/home/0');
          break;
          case 'popular':
            appRouter.go('/home/1');
          break;
          case 'favorites':
            appRouter.go('/home/2');
          break;
          default:
        }
      });

      // * CREACION DE LAS QUICK ACTIONS(los icons en drawable con mismo name de el type)
      quickActions.setShortcutItems(<ShortcutItem>[
        const ShortcutItem(type: 'home', localizedTitle: 'Principal', icon: 'home'),
        const ShortcutItem(type: 'popular', localizedTitle: 'Populares', icon: 'popular'),
        const ShortcutItem(type: 'favorites', localizedTitle: 'Favoritas', icon: 'favorites'),
      ]);
    }

    
  }
  

}