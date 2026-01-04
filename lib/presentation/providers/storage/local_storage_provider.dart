import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/infrastructure/datasources/drift_datasource.dart';
import 'package:movies_app/infrastructure/repositories/local_storage_repository_impl.dart';

//*PROVEEDOR QUE NOS DA LA DATASOURCE POR LOS REPOSITORIOS
final localStorageRepositoryProvider = Provider(
  (ref){
    return LocalStorageRepositoryImpl(DriftDatasource());
  }
); 