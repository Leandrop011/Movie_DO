import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/infrastructure/datasources/drift_config_datasource.dart';
import 'package:movies_app/infrastructure/repositories/local_config_repository_impl.dart';

final localConfigRepositoryProvider = Provider(
  (ref){
    return LocalConfigRepositoryImpl(datasource: DriftConfigDatasource());
  }
);