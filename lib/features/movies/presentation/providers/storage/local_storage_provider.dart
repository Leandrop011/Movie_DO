import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/infrastructure/datasources/index.dart';
import 'package:movies_app/features/movies/infrastructure/repositories/index.dart';

//*PROVEEDOR QUE NOS DA LA DATASOURCE POR LOS REPOSITORIOS
final localStorageRepositoryProvider = Provider(
  (ref){
    return LocalStorageRepositoryImpl(DriftDatasource());
  }
); 
