// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_config.dart';

// ignore_for_file: type=lint
class $ConfigAppTable extends ConfigApp
    with TableInfo<$ConfigAppTable, ConfigAppData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfigAppTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<int> theme = GeneratedColumn<int>(
    'index_theme',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fountMeta = const VerificationMeta('fount');
  @override
  late final GeneratedColumn<bool> fount = GeneratedColumn<bool>(
    'bool_fount',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bool_fount" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, theme, fount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'config_app';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfigAppData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('index_theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['index_theme']!, _themeMeta),
      );
    } else if (isInserting) {
      context.missing(_themeMeta);
    }
    if (data.containsKey('bool_fount')) {
      context.handle(
        _fountMeta,
        fount.isAcceptableOrUnknown(data['bool_fount']!, _fountMeta),
      );
    } else if (isInserting) {
      context.missing(_fountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfigAppData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfigAppData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}index_theme'],
      )!,
      fount: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bool_fount'],
      )!,
    );
  }

  @override
  $ConfigAppTable createAlias(String alias) {
    return $ConfigAppTable(attachedDatabase, alias);
  }
}

class ConfigAppData extends DataClass implements Insertable<ConfigAppData> {
  final int id;
  final int theme;
  final bool fount;
  const ConfigAppData({
    required this.id,
    required this.theme,
    required this.fount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['index_theme'] = Variable<int>(theme);
    map['bool_fount'] = Variable<bool>(fount);
    return map;
  }

  ConfigAppCompanion toCompanion(bool nullToAbsent) {
    return ConfigAppCompanion(
      id: Value(id),
      theme: Value(theme),
      fount: Value(fount),
    );
  }

  factory ConfigAppData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfigAppData(
      id: serializer.fromJson<int>(json['id']),
      theme: serializer.fromJson<int>(json['theme']),
      fount: serializer.fromJson<bool>(json['fount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'theme': serializer.toJson<int>(theme),
      'fount': serializer.toJson<bool>(fount),
    };
  }

  ConfigAppData copyWith({int? id, int? theme, bool? fount}) => ConfigAppData(
    id: id ?? this.id,
    theme: theme ?? this.theme,
    fount: fount ?? this.fount,
  );
  ConfigAppData copyWithCompanion(ConfigAppCompanion data) {
    return ConfigAppData(
      id: data.id.present ? data.id.value : this.id,
      theme: data.theme.present ? data.theme.value : this.theme,
      fount: data.fount.present ? data.fount.value : this.fount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfigAppData(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('fount: $fount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, theme, fount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfigAppData &&
          other.id == this.id &&
          other.theme == this.theme &&
          other.fount == this.fount);
}

class ConfigAppCompanion extends UpdateCompanion<ConfigAppData> {
  final Value<int> id;
  final Value<int> theme;
  final Value<bool> fount;
  const ConfigAppCompanion({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.fount = const Value.absent(),
  });
  ConfigAppCompanion.insert({
    this.id = const Value.absent(),
    required int theme,
    required bool fount,
  }) : theme = Value(theme),
       fount = Value(fount);
  static Insertable<ConfigAppData> custom({
    Expression<int>? id,
    Expression<int>? theme,
    Expression<bool>? fount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (theme != null) 'index_theme': theme,
      if (fount != null) 'bool_fount': fount,
    });
  }

  ConfigAppCompanion copyWith({
    Value<int>? id,
    Value<int>? theme,
    Value<bool>? fount,
  }) {
    return ConfigAppCompanion(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      fount: fount ?? this.fount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (theme.present) {
      map['index_theme'] = Variable<int>(theme.value);
    }
    if (fount.present) {
      map['bool_fount'] = Variable<bool>(fount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfigAppCompanion(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('fount: $fount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppConfigDatabase extends GeneratedDatabase {
  _$AppConfigDatabase(QueryExecutor e) : super(e);
  $AppConfigDatabaseManager get managers => $AppConfigDatabaseManager(this);
  late final $ConfigAppTable configApp = $ConfigAppTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [configApp];
}

typedef $$ConfigAppTableCreateCompanionBuilder =
    ConfigAppCompanion Function({
      Value<int> id,
      required int theme,
      required bool fount,
    });
typedef $$ConfigAppTableUpdateCompanionBuilder =
    ConfigAppCompanion Function({
      Value<int> id,
      Value<int> theme,
      Value<bool> fount,
    });

class $$ConfigAppTableFilterComposer
    extends Composer<_$AppConfigDatabase, $ConfigAppTable> {
  $$ConfigAppTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fount => $composableBuilder(
    column: $table.fount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfigAppTableOrderingComposer
    extends Composer<_$AppConfigDatabase, $ConfigAppTable> {
  $$ConfigAppTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fount => $composableBuilder(
    column: $table.fount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfigAppTableAnnotationComposer
    extends Composer<_$AppConfigDatabase, $ConfigAppTable> {
  $$ConfigAppTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<bool> get fount =>
      $composableBuilder(column: $table.fount, builder: (column) => column);
}

class $$ConfigAppTableTableManager
    extends
        RootTableManager<
          _$AppConfigDatabase,
          $ConfigAppTable,
          ConfigAppData,
          $$ConfigAppTableFilterComposer,
          $$ConfigAppTableOrderingComposer,
          $$ConfigAppTableAnnotationComposer,
          $$ConfigAppTableCreateCompanionBuilder,
          $$ConfigAppTableUpdateCompanionBuilder,
          (
            ConfigAppData,
            BaseReferences<_$AppConfigDatabase, $ConfigAppTable, ConfigAppData>,
          ),
          ConfigAppData,
          PrefetchHooks Function()
        > {
  $$ConfigAppTableTableManager(_$AppConfigDatabase db, $ConfigAppTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfigAppTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfigAppTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfigAppTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> theme = const Value.absent(),
                Value<bool> fount = const Value.absent(),
              }) => ConfigAppCompanion(id: id, theme: theme, fount: fount),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int theme,
                required bool fount,
              }) =>
                  ConfigAppCompanion.insert(id: id, theme: theme, fount: fount),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfigAppTableProcessedTableManager =
    ProcessedTableManager<
      _$AppConfigDatabase,
      $ConfigAppTable,
      ConfigAppData,
      $$ConfigAppTableFilterComposer,
      $$ConfigAppTableOrderingComposer,
      $$ConfigAppTableAnnotationComposer,
      $$ConfigAppTableCreateCompanionBuilder,
      $$ConfigAppTableUpdateCompanionBuilder,
      (
        ConfigAppData,
        BaseReferences<_$AppConfigDatabase, $ConfigAppTable, ConfigAppData>,
      ),
      ConfigAppData,
      PrefetchHooks Function()
    >;

class $AppConfigDatabaseManager {
  final _$AppConfigDatabase _db;
  $AppConfigDatabaseManager(this._db);
  $$ConfigAppTableTableManager get configApp =>
      $$ConfigAppTableTableManager(_db, _db.configApp);
}
