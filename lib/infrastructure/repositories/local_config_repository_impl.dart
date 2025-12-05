
import 'package:movies_app/config/database/config/database_config.dart';
import 'package:movies_app/domain/data_sources/local_config_datasource.dart';
import 'package:movies_app/domain/repositories/local_config_repository.dart';

class LocalConfigRepositoryImpl extends LocalConfigRepository {

  final LocalConfigDatasource datasource;

  LocalConfigRepositoryImpl({required this.datasource}); 

  @override
  Future<ConfigAppData?> loadConfig() {
    return datasource.loadConfig();
  }

  @override
  Future<void> saveFount(bool isEnabled) {
    return datasource.saveFount(isEnabled);
  }

  @override
  Future<void> saveTheme(int themeIndex) {
    return datasource.saveTheme(themeIndex);
  }
  
}