

import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/infrastructure/repositories/local_config_repository_impl.dart';
import 'package:movies_app/presentation/providers/config/local_config_provider.dart';

//todo, un provider que provee un boleano para saber y cambiar el font darck or ligth
final isdarckProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref){
    final repo = ref.read(localConfigRepositoryProvider);
    return DarkModeNotifier(repo)..loadFromDB();
  }
);

class DarkModeNotifier extends StateNotifier<bool> {
  final LocalConfigRepositoryImpl repository;

  DarkModeNotifier(this.repository) : super(true);

  Future<void> loadFromDB() async {
    final config = await repository.loadConfig();
    if (config != null) state = config.fount;
  }

  Future<void> setDark(bool value) async {
    state = value;
    await repository.saveFount(value); //! ← GUARDAR EN DB
  }
}
