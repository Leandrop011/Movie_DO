
import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/infrastructure/repositories/local_config_repository_impl.dart';
import 'package:movies_app/presentation/providers/config/local_config_provider.dart';
//!ESTA ES LA MANERA DE COMUNICAR UN DATASOURE/REPOSITORIO CON PROVIDER, USAR NOTIFIER
final indexThemeProvider =
    StateNotifierProvider<IndexThemeNotifier, int>((ref) {
  final repo = ref.read(localConfigRepositoryProvider);
  return IndexThemeNotifier(repo)..loadFromDB();
});

class IndexThemeNotifier extends StateNotifier<int> {
  final LocalConfigRepositoryImpl repository;

  IndexThemeNotifier(this.repository) : super(0);

  Future<void> loadFromDB() async {
    final config = await repository.loadConfig();
    if (config != null) state = config.theme;
  }

  Future<void> setTheme(int value) async {
    state = value;
    await repository.saveTheme(value); //! ← GUARDAR EN DB
  }
}
