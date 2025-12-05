import 'package:movies_app/config/database/config/database_config.dart';

abstract class LocalConfigRepository {
  Future<ConfigAppData?> loadConfig();//* El que nos da una objeto de la configuracion de la app

  Future<void> saveTheme(int themeIndex);
  Future<void> saveFount(bool isEnabled);
}