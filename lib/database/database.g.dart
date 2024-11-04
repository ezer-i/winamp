// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TracksTable extends Tracks with TableInfo<$TracksTable, Track> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _artistNameMeta =
      const VerificationMeta('artistName');
  @override
  late final GeneratedColumn<String> artistName = GeneratedColumn<String>(
      'artist_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _albumArtMeta =
      const VerificationMeta('albumArt');
  @override
  late final GeneratedColumn<Uint8List> albumArt = GeneratedColumn<Uint8List>(
      'album_art', aliasedName, true,
      type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _albumTitleMeta =
      const VerificationMeta('albumTitle');
  @override
  late final GeneratedColumn<String> albumTitle = GeneratedColumn<String>(
      'album_title', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, path, title, number, artistName, duration, albumArt, albumTitle];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracks';
  @override
  VerificationContext validateIntegrity(Insertable<Track> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('artist_name')) {
      context.handle(
          _artistNameMeta,
          artistName.isAcceptableOrUnknown(
              data['artist_name']!, _artistNameMeta));
    } else if (isInserting) {
      context.missing(_artistNameMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('album_art')) {
      context.handle(_albumArtMeta,
          albumArt.isAcceptableOrUnknown(data['album_art']!, _albumArtMeta));
    }
    if (data.containsKey('album_title')) {
      context.handle(
          _albumTitleMeta,
          albumTitle.isAcceptableOrUnknown(
              data['album_title']!, _albumTitleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Track map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Track(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      artistName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist_name'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      albumArt: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}album_art']),
      albumTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}album_title']),
    );
  }

  @override
  $TracksTable createAlias(String alias) {
    return $TracksTable(attachedDatabase, alias);
  }
}

class Track extends DataClass implements Insertable<Track> {
  final int id;
  final String path;
  final String title;
  final int number;
  final String artistName;
  final int duration;
  final Uint8List? albumArt;
  final String? albumTitle;
  const Track(
      {required this.id,
      required this.path,
      required this.title,
      required this.number,
      required this.artistName,
      required this.duration,
      this.albumArt,
      this.albumTitle});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    map['title'] = Variable<String>(title);
    map['number'] = Variable<int>(number);
    map['artist_name'] = Variable<String>(artistName);
    map['duration'] = Variable<int>(duration);
    if (!nullToAbsent || albumArt != null) {
      map['album_art'] = Variable<Uint8List>(albumArt);
    }
    if (!nullToAbsent || albumTitle != null) {
      map['album_title'] = Variable<String>(albumTitle);
    }
    return map;
  }

  TracksCompanion toCompanion(bool nullToAbsent) {
    return TracksCompanion(
      id: Value(id),
      path: Value(path),
      title: Value(title),
      number: Value(number),
      artistName: Value(artistName),
      duration: Value(duration),
      albumArt: albumArt == null && nullToAbsent
          ? const Value.absent()
          : Value(albumArt),
      albumTitle: albumTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(albumTitle),
    );
  }

  factory Track.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Track(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      title: serializer.fromJson<String>(json['title']),
      number: serializer.fromJson<int>(json['number']),
      artistName: serializer.fromJson<String>(json['artistName']),
      duration: serializer.fromJson<int>(json['duration']),
      albumArt: serializer.fromJson<Uint8List?>(json['albumArt']),
      albumTitle: serializer.fromJson<String?>(json['albumTitle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'title': serializer.toJson<String>(title),
      'number': serializer.toJson<int>(number),
      'artistName': serializer.toJson<String>(artistName),
      'duration': serializer.toJson<int>(duration),
      'albumArt': serializer.toJson<Uint8List?>(albumArt),
      'albumTitle': serializer.toJson<String?>(albumTitle),
    };
  }

  Track copyWith(
          {int? id,
          String? path,
          String? title,
          int? number,
          String? artistName,
          int? duration,
          Value<Uint8List?> albumArt = const Value.absent(),
          Value<String?> albumTitle = const Value.absent()}) =>
      Track(
        id: id ?? this.id,
        path: path ?? this.path,
        title: title ?? this.title,
        number: number ?? this.number,
        artistName: artistName ?? this.artistName,
        duration: duration ?? this.duration,
        albumArt: albumArt.present ? albumArt.value : this.albumArt,
        albumTitle: albumTitle.present ? albumTitle.value : this.albumTitle,
      );
  Track copyWithCompanion(TracksCompanion data) {
    return Track(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      title: data.title.present ? data.title.value : this.title,
      number: data.number.present ? data.number.value : this.number,
      artistName:
          data.artistName.present ? data.artistName.value : this.artistName,
      duration: data.duration.present ? data.duration.value : this.duration,
      albumArt: data.albumArt.present ? data.albumArt.value : this.albumArt,
      albumTitle:
          data.albumTitle.present ? data.albumTitle.value : this.albumTitle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Track(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('title: $title, ')
          ..write('number: $number, ')
          ..write('artistName: $artistName, ')
          ..write('duration: $duration, ')
          ..write('albumArt: $albumArt, ')
          ..write('albumTitle: $albumTitle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, title, number, artistName, duration,
      $driftBlobEquality.hash(albumArt), albumTitle);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Track &&
          other.id == this.id &&
          other.path == this.path &&
          other.title == this.title &&
          other.number == this.number &&
          other.artistName == this.artistName &&
          other.duration == this.duration &&
          $driftBlobEquality.equals(other.albumArt, this.albumArt) &&
          other.albumTitle == this.albumTitle);
}

class TracksCompanion extends UpdateCompanion<Track> {
  final Value<int> id;
  final Value<String> path;
  final Value<String> title;
  final Value<int> number;
  final Value<String> artistName;
  final Value<int> duration;
  final Value<Uint8List?> albumArt;
  final Value<String?> albumTitle;
  const TracksCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.title = const Value.absent(),
    this.number = const Value.absent(),
    this.artistName = const Value.absent(),
    this.duration = const Value.absent(),
    this.albumArt = const Value.absent(),
    this.albumTitle = const Value.absent(),
  });
  TracksCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    required String title,
    required int number,
    required String artistName,
    required int duration,
    this.albumArt = const Value.absent(),
    this.albumTitle = const Value.absent(),
  })  : path = Value(path),
        title = Value(title),
        number = Value(number),
        artistName = Value(artistName),
        duration = Value(duration);
  static Insertable<Track> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<String>? title,
    Expression<int>? number,
    Expression<String>? artistName,
    Expression<int>? duration,
    Expression<Uint8List>? albumArt,
    Expression<String>? albumTitle,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (title != null) 'title': title,
      if (number != null) 'number': number,
      if (artistName != null) 'artist_name': artistName,
      if (duration != null) 'duration': duration,
      if (albumArt != null) 'album_art': albumArt,
      if (albumTitle != null) 'album_title': albumTitle,
    });
  }

  TracksCompanion copyWith(
      {Value<int>? id,
      Value<String>? path,
      Value<String>? title,
      Value<int>? number,
      Value<String>? artistName,
      Value<int>? duration,
      Value<Uint8List?>? albumArt,
      Value<String?>? albumTitle}) {
    return TracksCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      title: title ?? this.title,
      number: number ?? this.number,
      artistName: artistName ?? this.artistName,
      duration: duration ?? this.duration,
      albumArt: albumArt ?? this.albumArt,
      albumTitle: albumTitle ?? this.albumTitle,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (artistName.present) {
      map['artist_name'] = Variable<String>(artistName.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (albumArt.present) {
      map['album_art'] = Variable<Uint8List>(albumArt.value);
    }
    if (albumTitle.present) {
      map['album_title'] = Variable<String>(albumTitle.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TracksCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('title: $title, ')
          ..write('number: $number, ')
          ..write('artistName: $artistName, ')
          ..write('duration: $duration, ')
          ..write('albumArt: $albumArt, ')
          ..write('albumTitle: $albumTitle')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TracksTable tracks = $TracksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tracks];
}

typedef $$TracksTableCreateCompanionBuilder = TracksCompanion Function({
  Value<int> id,
  required String path,
  required String title,
  required int number,
  required String artistName,
  required int duration,
  Value<Uint8List?> albumArt,
  Value<String?> albumTitle,
});
typedef $$TracksTableUpdateCompanionBuilder = TracksCompanion Function({
  Value<int> id,
  Value<String> path,
  Value<String> title,
  Value<int> number,
  Value<String> artistName,
  Value<int> duration,
  Value<Uint8List?> albumArt,
  Value<String?> albumTitle,
});

class $$TracksTableFilterComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artistName => $composableBuilder(
      column: $table.artistName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get albumArt => $composableBuilder(
      column: $table.albumArt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get albumTitle => $composableBuilder(
      column: $table.albumTitle, builder: (column) => ColumnFilters(column));
}

class $$TracksTableOrderingComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artistName => $composableBuilder(
      column: $table.artistName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get albumArt => $composableBuilder(
      column: $table.albumArt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get albumTitle => $composableBuilder(
      column: $table.albumTitle, builder: (column) => ColumnOrderings(column));
}

class $$TracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get artistName => $composableBuilder(
      column: $table.artistName, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<Uint8List> get albumArt =>
      $composableBuilder(column: $table.albumArt, builder: (column) => column);

  GeneratedColumn<String> get albumTitle => $composableBuilder(
      column: $table.albumTitle, builder: (column) => column);
}

class $$TracksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TracksTable,
    Track,
    $$TracksTableFilterComposer,
    $$TracksTableOrderingComposer,
    $$TracksTableAnnotationComposer,
    $$TracksTableCreateCompanionBuilder,
    $$TracksTableUpdateCompanionBuilder,
    (Track, BaseReferences<_$AppDatabase, $TracksTable, Track>),
    Track,
    PrefetchHooks Function()> {
  $$TracksTableTableManager(_$AppDatabase db, $TracksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> number = const Value.absent(),
            Value<String> artistName = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<Uint8List?> albumArt = const Value.absent(),
            Value<String?> albumTitle = const Value.absent(),
          }) =>
              TracksCompanion(
            id: id,
            path: path,
            title: title,
            number: number,
            artistName: artistName,
            duration: duration,
            albumArt: albumArt,
            albumTitle: albumTitle,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String path,
            required String title,
            required int number,
            required String artistName,
            required int duration,
            Value<Uint8List?> albumArt = const Value.absent(),
            Value<String?> albumTitle = const Value.absent(),
          }) =>
              TracksCompanion.insert(
            id: id,
            path: path,
            title: title,
            number: number,
            artistName: artistName,
            duration: duration,
            albumArt: albumArt,
            albumTitle: albumTitle,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TracksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TracksTable,
    Track,
    $$TracksTableFilterComposer,
    $$TracksTableOrderingComposer,
    $$TracksTableAnnotationComposer,
    $$TracksTableCreateCompanionBuilder,
    $$TracksTableUpdateCompanionBuilder,
    (Track, BaseReferences<_$AppDatabase, $TracksTable, Track>),
    Track,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TracksTableTableManager get tracks =>
      $$TracksTableTableManager(_db, _db.tracks);
}
