
import 'package:drift/drift.dart';
import 'package:movies_app/config/database/config/database_config.dart';
import 'package:movies_app/domain/data_sources/local_config_datasource.dart';

class DriftConfigDatasource extends LocalConfigDatasource {

  DriftConfigDatasource();

  static final AppConfigDatabase database = AppConfigDatabase();

  //* ESTE METODO LEE DATOS GUARDADOS EN LA DATABASE
  @override
  Future<ConfigAppData?> loadConfig() async{
    //Construir el query
    //* AQUI REGRESA LA FILA 
    //* ES COMO DECIRLE selecciona todo lo que hay en la tabla configApp
    //* Y ES UNA LISTA PORQUE EN TODA LA TABLA HAY VARIOS ELEMENTO Y SE HACE LIST
    final query = await database.select(database.configApp).get();//*OBTENEMOS LOS DATOS
    //Ejecutar el query
    if(query.isEmpty) return null;//* SI ES NULL NO DA NADA
    //Retornar el resultado
    return query.first;//* PERO SI HAY DEVUELVE EL PRIMER GUARDADO
  }

  //* ESTAS IMPLEMENTACIONES DE ABAJO SON PARA GUARDAR COSAS EN EL DATABASE ENTONCES SE USA INTO
  @override
  Future<void> saveFount(bool isEnabled) async{
    final current = await loadConfig();
    await database.into(database.configApp).insertOnConflictUpdate(
      ConfigAppCompanion(
        id: Value(1),
        fount: Value(isEnabled),
        theme: Value(current?.theme ?? 1)
      )
    );
  }

  @override
  Future<void> saveTheme(int themeIndex) async{
    final current = await loadConfig();

    await database.into(database.configApp).insertOnConflictUpdate(
      ConfigAppCompanion(
        id: Value(1),
        theme: Value(themeIndex),
        fount: Value(current?.fount ?? true),
      )
    );
  }
  
}