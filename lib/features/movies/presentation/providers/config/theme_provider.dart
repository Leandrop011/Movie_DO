// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/features/shared/infrastructure/services/config/theme/theme_value_storage_service.dart';
import 'package:movies_app/features/shared/infrastructure/services/config/theme/theme_value_storage_service_impl.dart';

// ! PROVIDER
final themeProvider = StateNotifierProvider.autoDispose<ThemeNotifier, ThemeState>((ref) {

  final themeValueStorageService = ThemeValueStorageServiceImpl();
  
  return ThemeNotifier(themeValueStorageService: themeValueStorageService);
});

// ! NOTIFIER
class ThemeNotifier extends StateNotifier<ThemeState> {

  final ThemeValueStorageService themeValueStorageService;

  ThemeNotifier({required this.themeValueStorageService}): super(ThemeState()){
    getTheme();
  }

  // ? CADA QUE INICIE PREGUNTARA POR EL INDEX COLOR Y EL QUE SE HAYA GUARDADO
  // ? CON SETTHEME, ACTUALIZA ESE VALOR EN MEMORIA Y ACTUALIZA SU ESTADO
  void getTheme() async{
    final value = await themeValueStorageService.getValue('theme');

    state = state.copyWith(
      indexTheme: value
    );

  }

  void setTheme(int value){

    themeValueStorageService.setValue(value, 'theme');

    state = state.copyWith(
      indexTheme: value,
    );
  }
  
}

// ! STATE
class ThemeState {
  final int indexTheme;

  ThemeState({
    this.indexTheme = 0
  });

  

  ThemeState copyWith({
    int? indexTheme,
  }) => ThemeState(
      indexTheme: indexTheme ?? this.indexTheme,
  );
}
