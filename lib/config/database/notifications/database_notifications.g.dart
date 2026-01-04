// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_notifications.dart';

// ignore_for_file: type=lint
class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, Notification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMessageMeta = const VerificationMeta(
    'titleMessage',
  );
  @override
  late final GeneratedColumn<String> titleMessage = GeneratedColumn<String>(
    'message_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMessageMeta = const VerificationMeta(
    'bodyMessage',
  );
  @override
  late final GeneratedColumn<String> bodyMessage = GeneratedColumn<String>(
    'body_message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    messageId,
    titleMessage,
    bodyMessage,
    imageUrl,
    data,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Notification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('message_title')) {
      context.handle(
        _titleMessageMeta,
        titleMessage.isAcceptableOrUnknown(
          data['message_title']!,
          _titleMessageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_titleMessageMeta);
    }
    if (data.containsKey('body_message')) {
      context.handle(
        _bodyMessageMeta,
        bodyMessage.isAcceptableOrUnknown(
          data['body_message']!,
          _bodyMessageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bodyMessageMeta);
    }
    if (data.containsKey('image_message')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_message']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Notification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Notification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      titleMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_title'],
      )!,
      bodyMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_message'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_message'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      ),
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }
}

class Notification extends DataClass implements Insertable<Notification> {
  final int id;
  final String messageId;
  final String titleMessage;
  final String bodyMessage;
  final String imageUrl;
  final String? data;
  const Notification({
    required this.id,
    required this.messageId,
    required this.titleMessage,
    required this.bodyMessage,
    required this.imageUrl,
    this.data,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message_id'] = Variable<String>(messageId);
    map['message_title'] = Variable<String>(titleMessage);
    map['body_message'] = Variable<String>(bodyMessage);
    map['image_message'] = Variable<String>(imageUrl);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      titleMessage: Value(titleMessage),
      bodyMessage: Value(bodyMessage),
      imageUrl: Value(imageUrl),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
    );
  }

  factory Notification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Notification(
      id: serializer.fromJson<int>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      titleMessage: serializer.fromJson<String>(json['titleMessage']),
      bodyMessage: serializer.fromJson<String>(json['bodyMessage']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      data: serializer.fromJson<String?>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'messageId': serializer.toJson<String>(messageId),
      'titleMessage': serializer.toJson<String>(titleMessage),
      'bodyMessage': serializer.toJson<String>(bodyMessage),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'data': serializer.toJson<String?>(data),
    };
  }

  Notification copyWith({
    int? id,
    String? messageId,
    String? titleMessage,
    String? bodyMessage,
    String? imageUrl,
    Value<String?> data = const Value.absent(),
  }) => Notification(
    id: id ?? this.id,
    messageId: messageId ?? this.messageId,
    titleMessage: titleMessage ?? this.titleMessage,
    bodyMessage: bodyMessage ?? this.bodyMessage,
    imageUrl: imageUrl ?? this.imageUrl,
    data: data.present ? data.value : this.data,
  );
  Notification copyWithCompanion(NotificationsCompanion data) {
    return Notification(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      titleMessage: data.titleMessage.present
          ? data.titleMessage.value
          : this.titleMessage,
      bodyMessage: data.bodyMessage.present
          ? data.bodyMessage.value
          : this.bodyMessage,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Notification(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('titleMessage: $titleMessage, ')
          ..write('bodyMessage: $bodyMessage, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, messageId, titleMessage, bodyMessage, imageUrl, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notification &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.titleMessage == this.titleMessage &&
          other.bodyMessage == this.bodyMessage &&
          other.imageUrl == this.imageUrl &&
          other.data == this.data);
}

class NotificationsCompanion extends UpdateCompanion<Notification> {
  final Value<int> id;
  final Value<String> messageId;
  final Value<String> titleMessage;
  final Value<String> bodyMessage;
  final Value<String> imageUrl;
  final Value<String?> data;
  const NotificationsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.titleMessage = const Value.absent(),
    this.bodyMessage = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.data = const Value.absent(),
  });
  NotificationsCompanion.insert({
    this.id = const Value.absent(),
    required String messageId,
    required String titleMessage,
    required String bodyMessage,
    required String imageUrl,
    this.data = const Value.absent(),
  }) : messageId = Value(messageId),
       titleMessage = Value(titleMessage),
       bodyMessage = Value(bodyMessage),
       imageUrl = Value(imageUrl);
  static Insertable<Notification> custom({
    Expression<int>? id,
    Expression<String>? messageId,
    Expression<String>? titleMessage,
    Expression<String>? bodyMessage,
    Expression<String>? imageUrl,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (titleMessage != null) 'message_title': titleMessage,
      if (bodyMessage != null) 'body_message': bodyMessage,
      if (imageUrl != null) 'image_message': imageUrl,
      if (data != null) 'data': data,
    });
  }

  NotificationsCompanion copyWith({
    Value<int>? id,
    Value<String>? messageId,
    Value<String>? titleMessage,
    Value<String>? bodyMessage,
    Value<String>? imageUrl,
    Value<String?>? data,
  }) {
    return NotificationsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      titleMessage: titleMessage ?? this.titleMessage,
      bodyMessage: bodyMessage ?? this.bodyMessage,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (titleMessage.present) {
      map['message_title'] = Variable<String>(titleMessage.value);
    }
    if (bodyMessage.present) {
      map['body_message'] = Variable<String>(bodyMessage.value);
    }
    if (imageUrl.present) {
      map['image_message'] = Variable<String>(imageUrl.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('titleMessage: $titleMessage, ')
          ..write('bodyMessage: $bodyMessage, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppNotificationsDatabase extends GeneratedDatabase {
  _$AppNotificationsDatabase(QueryExecutor e) : super(e);
  $AppNotificationsDatabaseManager get managers =>
      $AppNotificationsDatabaseManager(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [notifications];
}

typedef $$NotificationsTableCreateCompanionBuilder =
    NotificationsCompanion Function({
      Value<int> id,
      required String messageId,
      required String titleMessage,
      required String bodyMessage,
      required String imageUrl,
      Value<String?> data,
    });
typedef $$NotificationsTableUpdateCompanionBuilder =
    NotificationsCompanion Function({
      Value<int> id,
      Value<String> messageId,
      Value<String> titleMessage,
      Value<String> bodyMessage,
      Value<String> imageUrl,
      Value<String?> data,
    });

class $$NotificationsTableFilterComposer
    extends Composer<_$AppNotificationsDatabase, $NotificationsTable> {
  $$NotificationsTableFilterComposer({
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

  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleMessage => $composableBuilder(
    column: $table.titleMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyMessage => $composableBuilder(
    column: $table.bodyMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationsTableOrderingComposer
    extends Composer<_$AppNotificationsDatabase, $NotificationsTable> {
  $$NotificationsTableOrderingComposer({
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

  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleMessage => $composableBuilder(
    column: $table.titleMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyMessage => $composableBuilder(
    column: $table.bodyMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationsTableAnnotationComposer
    extends Composer<_$AppNotificationsDatabase, $NotificationsTable> {
  $$NotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get titleMessage => $composableBuilder(
    column: $table.titleMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyMessage => $composableBuilder(
    column: $table.bodyMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$NotificationsTableTableManager
    extends
        RootTableManager<
          _$AppNotificationsDatabase,
          $NotificationsTable,
          Notification,
          $$NotificationsTableFilterComposer,
          $$NotificationsTableOrderingComposer,
          $$NotificationsTableAnnotationComposer,
          $$NotificationsTableCreateCompanionBuilder,
          $$NotificationsTableUpdateCompanionBuilder,
          (
            Notification,
            BaseReferences<
              _$AppNotificationsDatabase,
              $NotificationsTable,
              Notification
            >,
          ),
          Notification,
          PrefetchHooks Function()
        > {
  $$NotificationsTableTableManager(
    _$AppNotificationsDatabase db,
    $NotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> messageId = const Value.absent(),
                Value<String> titleMessage = const Value.absent(),
                Value<String> bodyMessage = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String?> data = const Value.absent(),
              }) => NotificationsCompanion(
                id: id,
                messageId: messageId,
                titleMessage: titleMessage,
                bodyMessage: bodyMessage,
                imageUrl: imageUrl,
                data: data,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String messageId,
                required String titleMessage,
                required String bodyMessage,
                required String imageUrl,
                Value<String?> data = const Value.absent(),
              }) => NotificationsCompanion.insert(
                id: id,
                messageId: messageId,
                titleMessage: titleMessage,
                bodyMessage: bodyMessage,
                imageUrl: imageUrl,
                data: data,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppNotificationsDatabase,
      $NotificationsTable,
      Notification,
      $$NotificationsTableFilterComposer,
      $$NotificationsTableOrderingComposer,
      $$NotificationsTableAnnotationComposer,
      $$NotificationsTableCreateCompanionBuilder,
      $$NotificationsTableUpdateCompanionBuilder,
      (
        Notification,
        BaseReferences<
          _$AppNotificationsDatabase,
          $NotificationsTable,
          Notification
        >,
      ),
      Notification,
      PrefetchHooks Function()
    >;

class $AppNotificationsDatabaseManager {
  final _$AppNotificationsDatabase _db;
  $AppNotificationsDatabaseManager(this._db);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db, _db.notifications);
}
