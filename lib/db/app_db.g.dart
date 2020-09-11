// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class PostEntityData extends DataClass implements Insertable<PostEntityData> {
  final int id;
  final Platform platform;
  final String outerId;
  final String threadId;
  final String boardName;
  final String body;
  final String name;
  final String parentId;
  final String tripcode;
  final bool my;
  final bool sage;
  final bool op;
  final int counter;
  final int timestamp;
  PostEntityData(
      {@required this.id,
      @required this.platform,
      @required this.outerId,
      @required this.threadId,
      @required this.boardName,
      @required this.body,
      this.name,
      this.parentId,
      this.tripcode,
      @required this.my,
      @required this.sage,
      @required this.op,
      this.counter,
      @required this.timestamp});
  factory PostEntityData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return PostEntityData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      platform: $PostEntityTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}platform'])),
      outerId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}outer_id']),
      threadId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}thread_id']),
      boardName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}board_name']),
      body: stringType.mapFromDatabaseResponse(data['${effectivePrefix}body']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      parentId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}parent_id']),
      tripcode: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}tripcode']),
      my: boolType.mapFromDatabaseResponse(data['${effectivePrefix}my']),
      sage: boolType.mapFromDatabaseResponse(data['${effectivePrefix}sage']),
      op: boolType.mapFromDatabaseResponse(data['${effectivePrefix}op']),
      counter:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}counter']),
      timestamp:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}timestamp']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || platform != null) {
      final converter = $PostEntityTable.$converter0;
      map['platform'] = Variable<int>(converter.mapToSql(platform));
    }
    if (!nullToAbsent || outerId != null) {
      map['outer_id'] = Variable<String>(outerId);
    }
    if (!nullToAbsent || threadId != null) {
      map['thread_id'] = Variable<String>(threadId);
    }
    if (!nullToAbsent || boardName != null) {
      map['board_name'] = Variable<String>(boardName);
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || tripcode != null) {
      map['tripcode'] = Variable<String>(tripcode);
    }
    if (!nullToAbsent || my != null) {
      map['my'] = Variable<bool>(my);
    }
    if (!nullToAbsent || sage != null) {
      map['sage'] = Variable<bool>(sage);
    }
    if (!nullToAbsent || op != null) {
      map['op'] = Variable<bool>(op);
    }
    if (!nullToAbsent || counter != null) {
      map['counter'] = Variable<int>(counter);
    }
    if (!nullToAbsent || timestamp != null) {
      map['timestamp'] = Variable<int>(timestamp);
    }
    return map;
  }

  PostEntityCompanion toCompanion(bool nullToAbsent) {
    return PostEntityCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      platform: platform == null && nullToAbsent
          ? const Value.absent()
          : Value(platform),
      outerId: outerId == null && nullToAbsent
          ? const Value.absent()
          : Value(outerId),
      threadId: threadId == null && nullToAbsent
          ? const Value.absent()
          : Value(threadId),
      boardName: boardName == null && nullToAbsent
          ? const Value.absent()
          : Value(boardName),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      tripcode: tripcode == null && nullToAbsent
          ? const Value.absent()
          : Value(tripcode),
      my: my == null && nullToAbsent ? const Value.absent() : Value(my),
      sage: sage == null && nullToAbsent ? const Value.absent() : Value(sage),
      op: op == null && nullToAbsent ? const Value.absent() : Value(op),
      counter: counter == null && nullToAbsent
          ? const Value.absent()
          : Value(counter),
      timestamp: timestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(timestamp),
    );
  }

  factory PostEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PostEntityData(
      id: serializer.fromJson<int>(json['id']),
      platform: serializer.fromJson<Platform>(json['platform']),
      outerId: serializer.fromJson<String>(json['outerId']),
      threadId: serializer.fromJson<String>(json['threadId']),
      boardName: serializer.fromJson<String>(json['boardName']),
      body: serializer.fromJson<String>(json['body']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String>(json['parentId']),
      tripcode: serializer.fromJson<String>(json['tripcode']),
      my: serializer.fromJson<bool>(json['my']),
      sage: serializer.fromJson<bool>(json['sage']),
      op: serializer.fromJson<bool>(json['op']),
      counter: serializer.fromJson<int>(json['counter']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'platform': serializer.toJson<Platform>(platform),
      'outerId': serializer.toJson<String>(outerId),
      'threadId': serializer.toJson<String>(threadId),
      'boardName': serializer.toJson<String>(boardName),
      'body': serializer.toJson<String>(body),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String>(parentId),
      'tripcode': serializer.toJson<String>(tripcode),
      'my': serializer.toJson<bool>(my),
      'sage': serializer.toJson<bool>(sage),
      'op': serializer.toJson<bool>(op),
      'counter': serializer.toJson<int>(counter),
      'timestamp': serializer.toJson<int>(timestamp),
    };
  }

  PostEntityData copyWith(
          {int id,
          Platform platform,
          String outerId,
          String threadId,
          String boardName,
          String body,
          String name,
          String parentId,
          String tripcode,
          bool my,
          bool sage,
          bool op,
          int counter,
          int timestamp}) =>
      PostEntityData(
        id: id ?? this.id,
        platform: platform ?? this.platform,
        outerId: outerId ?? this.outerId,
        threadId: threadId ?? this.threadId,
        boardName: boardName ?? this.boardName,
        body: body ?? this.body,
        name: name ?? this.name,
        parentId: parentId ?? this.parentId,
        tripcode: tripcode ?? this.tripcode,
        my: my ?? this.my,
        sage: sage ?? this.sage,
        op: op ?? this.op,
        counter: counter ?? this.counter,
        timestamp: timestamp ?? this.timestamp,
      );
  @override
  String toString() {
    return (StringBuffer('PostEntityData(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('outerId: $outerId, ')
          ..write('threadId: $threadId, ')
          ..write('boardName: $boardName, ')
          ..write('body: $body, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('tripcode: $tripcode, ')
          ..write('my: $my, ')
          ..write('sage: $sage, ')
          ..write('op: $op, ')
          ..write('counter: $counter, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          platform.hashCode,
          $mrjc(
              outerId.hashCode,
              $mrjc(
                  threadId.hashCode,
                  $mrjc(
                      boardName.hashCode,
                      $mrjc(
                          body.hashCode,
                          $mrjc(
                              name.hashCode,
                              $mrjc(
                                  parentId.hashCode,
                                  $mrjc(
                                      tripcode.hashCode,
                                      $mrjc(
                                          my.hashCode,
                                          $mrjc(
                                              sage.hashCode,
                                              $mrjc(
                                                  op.hashCode,
                                                  $mrjc(
                                                      counter.hashCode,
                                                      timestamp
                                                          .hashCode))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PostEntityData &&
          other.id == this.id &&
          other.platform == this.platform &&
          other.outerId == this.outerId &&
          other.threadId == this.threadId &&
          other.boardName == this.boardName &&
          other.body == this.body &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.tripcode == this.tripcode &&
          other.my == this.my &&
          other.sage == this.sage &&
          other.op == this.op &&
          other.counter == this.counter &&
          other.timestamp == this.timestamp);
}

class PostEntityCompanion extends UpdateCompanion<PostEntityData> {
  final Value<int> id;
  final Value<Platform> platform;
  final Value<String> outerId;
  final Value<String> threadId;
  final Value<String> boardName;
  final Value<String> body;
  final Value<String> name;
  final Value<String> parentId;
  final Value<String> tripcode;
  final Value<bool> my;
  final Value<bool> sage;
  final Value<bool> op;
  final Value<int> counter;
  final Value<int> timestamp;
  const PostEntityCompanion({
    this.id = const Value.absent(),
    this.platform = const Value.absent(),
    this.outerId = const Value.absent(),
    this.threadId = const Value.absent(),
    this.boardName = const Value.absent(),
    this.body = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.tripcode = const Value.absent(),
    this.my = const Value.absent(),
    this.sage = const Value.absent(),
    this.op = const Value.absent(),
    this.counter = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  PostEntityCompanion.insert({
    this.id = const Value.absent(),
    @required Platform platform,
    @required String outerId,
    @required String threadId,
    @required String boardName,
    @required String body,
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.tripcode = const Value.absent(),
    this.my = const Value.absent(),
    this.sage = const Value.absent(),
    this.op = const Value.absent(),
    this.counter = const Value.absent(),
    @required int timestamp,
  })  : platform = Value(platform),
        outerId = Value(outerId),
        threadId = Value(threadId),
        boardName = Value(boardName),
        body = Value(body),
        timestamp = Value(timestamp);
  static Insertable<PostEntityData> custom({
    Expression<int> id,
    Expression<int> platform,
    Expression<String> outerId,
    Expression<String> threadId,
    Expression<String> boardName,
    Expression<String> body,
    Expression<String> name,
    Expression<String> parentId,
    Expression<String> tripcode,
    Expression<bool> my,
    Expression<bool> sage,
    Expression<bool> op,
    Expression<int> counter,
    Expression<int> timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (platform != null) 'platform': platform,
      if (outerId != null) 'outer_id': outerId,
      if (threadId != null) 'thread_id': threadId,
      if (boardName != null) 'board_name': boardName,
      if (body != null) 'body': body,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (tripcode != null) 'tripcode': tripcode,
      if (my != null) 'my': my,
      if (sage != null) 'sage': sage,
      if (op != null) 'op': op,
      if (counter != null) 'counter': counter,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  PostEntityCompanion copyWith(
      {Value<int> id,
      Value<Platform> platform,
      Value<String> outerId,
      Value<String> threadId,
      Value<String> boardName,
      Value<String> body,
      Value<String> name,
      Value<String> parentId,
      Value<String> tripcode,
      Value<bool> my,
      Value<bool> sage,
      Value<bool> op,
      Value<int> counter,
      Value<int> timestamp}) {
    return PostEntityCompanion(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      outerId: outerId ?? this.outerId,
      threadId: threadId ?? this.threadId,
      boardName: boardName ?? this.boardName,
      body: body ?? this.body,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      tripcode: tripcode ?? this.tripcode,
      my: my ?? this.my,
      sage: sage ?? this.sage,
      op: op ?? this.op,
      counter: counter ?? this.counter,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (platform.present) {
      final converter = $PostEntityTable.$converter0;
      map['platform'] = Variable<int>(converter.mapToSql(platform.value));
    }
    if (outerId.present) {
      map['outer_id'] = Variable<String>(outerId.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (boardName.present) {
      map['board_name'] = Variable<String>(boardName.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (tripcode.present) {
      map['tripcode'] = Variable<String>(tripcode.value);
    }
    if (my.present) {
      map['my'] = Variable<bool>(my.value);
    }
    if (sage.present) {
      map['sage'] = Variable<bool>(sage.value);
    }
    if (op.present) {
      map['op'] = Variable<bool>(op.value);
    }
    if (counter.present) {
      map['counter'] = Variable<int>(counter.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostEntityCompanion(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('outerId: $outerId, ')
          ..write('threadId: $threadId, ')
          ..write('boardName: $boardName, ')
          ..write('body: $body, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('tripcode: $tripcode, ')
          ..write('my: $my, ')
          ..write('sage: $sage, ')
          ..write('op: $op, ')
          ..write('counter: $counter, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $PostEntityTable extends PostEntity
    with TableInfo<$PostEntityTable, PostEntityData> {
  final GeneratedDatabase _db;
  final String _alias;
  $PostEntityTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _platformMeta = const VerificationMeta('platform');
  GeneratedIntColumn _platform;
  @override
  GeneratedIntColumn get platform => _platform ??= _constructPlatform();
  GeneratedIntColumn _constructPlatform() {
    return GeneratedIntColumn(
      'platform',
      $tableName,
      false,
    );
  }

  final VerificationMeta _outerIdMeta = const VerificationMeta('outerId');
  GeneratedTextColumn _outerId;
  @override
  GeneratedTextColumn get outerId => _outerId ??= _constructOuterId();
  GeneratedTextColumn _constructOuterId() {
    return GeneratedTextColumn('outer_id', $tableName, false, minTextLength: 1);
  }

  final VerificationMeta _threadIdMeta = const VerificationMeta('threadId');
  GeneratedTextColumn _threadId;
  @override
  GeneratedTextColumn get threadId => _threadId ??= _constructThreadId();
  GeneratedTextColumn _constructThreadId() {
    return GeneratedTextColumn('thread_id', $tableName, false,
        minTextLength: 1);
  }

  final VerificationMeta _boardNameMeta = const VerificationMeta('boardName');
  GeneratedTextColumn _boardName;
  @override
  GeneratedTextColumn get boardName => _boardName ??= _constructBoardName();
  GeneratedTextColumn _constructBoardName() {
    return GeneratedTextColumn('board_name', $tableName, false,
        minTextLength: 1);
  }

  final VerificationMeta _bodyMeta = const VerificationMeta('body');
  GeneratedTextColumn _body;
  @override
  GeneratedTextColumn get body => _body ??= _constructBody();
  GeneratedTextColumn _constructBody() {
    return GeneratedTextColumn(
      'body',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      true,
    );
  }

  final VerificationMeta _parentIdMeta = const VerificationMeta('parentId');
  GeneratedTextColumn _parentId;
  @override
  GeneratedTextColumn get parentId => _parentId ??= _constructParentId();
  GeneratedTextColumn _constructParentId() {
    return GeneratedTextColumn(
      'parent_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _tripcodeMeta = const VerificationMeta('tripcode');
  GeneratedTextColumn _tripcode;
  @override
  GeneratedTextColumn get tripcode => _tripcode ??= _constructTripcode();
  GeneratedTextColumn _constructTripcode() {
    return GeneratedTextColumn(
      'tripcode',
      $tableName,
      true,
    );
  }

  final VerificationMeta _myMeta = const VerificationMeta('my');
  GeneratedBoolColumn _my;
  @override
  GeneratedBoolColumn get my => _my ??= _constructMy();
  GeneratedBoolColumn _constructMy() {
    return GeneratedBoolColumn('my', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _sageMeta = const VerificationMeta('sage');
  GeneratedBoolColumn _sage;
  @override
  GeneratedBoolColumn get sage => _sage ??= _constructSage();
  GeneratedBoolColumn _constructSage() {
    return GeneratedBoolColumn('sage', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _opMeta = const VerificationMeta('op');
  GeneratedBoolColumn _op;
  @override
  GeneratedBoolColumn get op => _op ??= _constructOp();
  GeneratedBoolColumn _constructOp() {
    return GeneratedBoolColumn('op', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _counterMeta = const VerificationMeta('counter');
  GeneratedIntColumn _counter;
  @override
  GeneratedIntColumn get counter => _counter ??= _constructCounter();
  GeneratedIntColumn _constructCounter() {
    return GeneratedIntColumn(
      'counter',
      $tableName,
      true,
    );
  }

  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  GeneratedIntColumn _timestamp;
  @override
  GeneratedIntColumn get timestamp => _timestamp ??= _constructTimestamp();
  GeneratedIntColumn _constructTimestamp() {
    return GeneratedIntColumn(
      'timestamp',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        platform,
        outerId,
        threadId,
        boardName,
        body,
        name,
        parentId,
        tripcode,
        my,
        sage,
        op,
        counter,
        timestamp
      ];
  @override
  $PostEntityTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'posts';
  @override
  final String actualTableName = 'posts';
  @override
  VerificationContext validateIntegrity(Insertable<PostEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    context.handle(_platformMeta, const VerificationResult.success());
    if (data.containsKey('outer_id')) {
      context.handle(_outerIdMeta,
          outerId.isAcceptableOrUnknown(data['outer_id'], _outerIdMeta));
    } else if (isInserting) {
      context.missing(_outerIdMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(_threadIdMeta,
          threadId.isAcceptableOrUnknown(data['thread_id'], _threadIdMeta));
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('board_name')) {
      context.handle(_boardNameMeta,
          boardName.isAcceptableOrUnknown(data['board_name'], _boardNameMeta));
    } else if (isInserting) {
      context.missing(_boardNameMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body'], _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id'], _parentIdMeta));
    }
    if (data.containsKey('tripcode')) {
      context.handle(_tripcodeMeta,
          tripcode.isAcceptableOrUnknown(data['tripcode'], _tripcodeMeta));
    }
    if (data.containsKey('my')) {
      context.handle(_myMeta, my.isAcceptableOrUnknown(data['my'], _myMeta));
    }
    if (data.containsKey('sage')) {
      context.handle(
          _sageMeta, sage.isAcceptableOrUnknown(data['sage'], _sageMeta));
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op'], _opMeta));
    }
    if (data.containsKey('counter')) {
      context.handle(_counterMeta,
          counter.isAcceptableOrUnknown(data['counter'], _counterMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp'], _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostEntityData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PostEntityData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PostEntityTable createAlias(String alias) {
    return $PostEntityTable(_db, alias);
  }

  static TypeConverter<Platform, int> $converter0 =
      const EnumIndexConverter<Platform>(Platform.values);
}

class ThreadEntityData extends DataClass
    implements Insertable<ThreadEntityData> {
  final int id;
  final Platform platform;
  final String outerId;
  final String boardName;
  final String title;
  final String body;
  final String name;
  final String opcode;
  final String tripcode;
  final bool my;
  final int timestamp;
  ThreadEntityData(
      {@required this.id,
      @required this.platform,
      @required this.outerId,
      @required this.boardName,
      @required this.title,
      @required this.body,
      @required this.name,
      @required this.opcode,
      @required this.tripcode,
      @required this.my,
      @required this.timestamp});
  factory ThreadEntityData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return ThreadEntityData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      platform: $ThreadEntityTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}platform'])),
      outerId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}outer_id']),
      boardName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}board_name']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      body: stringType.mapFromDatabaseResponse(data['${effectivePrefix}body']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      opcode:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}opcode']),
      tripcode: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}tripcode']),
      my: boolType.mapFromDatabaseResponse(data['${effectivePrefix}my']),
      timestamp:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}timestamp']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || platform != null) {
      final converter = $ThreadEntityTable.$converter0;
      map['platform'] = Variable<int>(converter.mapToSql(platform));
    }
    if (!nullToAbsent || outerId != null) {
      map['outer_id'] = Variable<String>(outerId);
    }
    if (!nullToAbsent || boardName != null) {
      map['board_name'] = Variable<String>(boardName);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || opcode != null) {
      map['opcode'] = Variable<String>(opcode);
    }
    if (!nullToAbsent || tripcode != null) {
      map['tripcode'] = Variable<String>(tripcode);
    }
    if (!nullToAbsent || my != null) {
      map['my'] = Variable<bool>(my);
    }
    if (!nullToAbsent || timestamp != null) {
      map['timestamp'] = Variable<int>(timestamp);
    }
    return map;
  }

  ThreadEntityCompanion toCompanion(bool nullToAbsent) {
    return ThreadEntityCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      platform: platform == null && nullToAbsent
          ? const Value.absent()
          : Value(platform),
      outerId: outerId == null && nullToAbsent
          ? const Value.absent()
          : Value(outerId),
      boardName: boardName == null && nullToAbsent
          ? const Value.absent()
          : Value(boardName),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      opcode:
          opcode == null && nullToAbsent ? const Value.absent() : Value(opcode),
      tripcode: tripcode == null && nullToAbsent
          ? const Value.absent()
          : Value(tripcode),
      my: my == null && nullToAbsent ? const Value.absent() : Value(my),
      timestamp: timestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(timestamp),
    );
  }

  factory ThreadEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ThreadEntityData(
      id: serializer.fromJson<int>(json['id']),
      platform: serializer.fromJson<Platform>(json['platform']),
      outerId: serializer.fromJson<String>(json['outerId']),
      boardName: serializer.fromJson<String>(json['boardName']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      name: serializer.fromJson<String>(json['name']),
      opcode: serializer.fromJson<String>(json['opcode']),
      tripcode: serializer.fromJson<String>(json['tripcode']),
      my: serializer.fromJson<bool>(json['my']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'platform': serializer.toJson<Platform>(platform),
      'outerId': serializer.toJson<String>(outerId),
      'boardName': serializer.toJson<String>(boardName),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'name': serializer.toJson<String>(name),
      'opcode': serializer.toJson<String>(opcode),
      'tripcode': serializer.toJson<String>(tripcode),
      'my': serializer.toJson<bool>(my),
      'timestamp': serializer.toJson<int>(timestamp),
    };
  }

  ThreadEntityData copyWith(
          {int id,
          Platform platform,
          String outerId,
          String boardName,
          String title,
          String body,
          String name,
          String opcode,
          String tripcode,
          bool my,
          int timestamp}) =>
      ThreadEntityData(
        id: id ?? this.id,
        platform: platform ?? this.platform,
        outerId: outerId ?? this.outerId,
        boardName: boardName ?? this.boardName,
        title: title ?? this.title,
        body: body ?? this.body,
        name: name ?? this.name,
        opcode: opcode ?? this.opcode,
        tripcode: tripcode ?? this.tripcode,
        my: my ?? this.my,
        timestamp: timestamp ?? this.timestamp,
      );
  @override
  String toString() {
    return (StringBuffer('ThreadEntityData(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('outerId: $outerId, ')
          ..write('boardName: $boardName, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('name: $name, ')
          ..write('opcode: $opcode, ')
          ..write('tripcode: $tripcode, ')
          ..write('my: $my, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          platform.hashCode,
          $mrjc(
              outerId.hashCode,
              $mrjc(
                  boardName.hashCode,
                  $mrjc(
                      title.hashCode,
                      $mrjc(
                          body.hashCode,
                          $mrjc(
                              name.hashCode,
                              $mrjc(
                                  opcode.hashCode,
                                  $mrjc(
                                      tripcode.hashCode,
                                      $mrjc(my.hashCode,
                                          timestamp.hashCode)))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ThreadEntityData &&
          other.id == this.id &&
          other.platform == this.platform &&
          other.outerId == this.outerId &&
          other.boardName == this.boardName &&
          other.title == this.title &&
          other.body == this.body &&
          other.name == this.name &&
          other.opcode == this.opcode &&
          other.tripcode == this.tripcode &&
          other.my == this.my &&
          other.timestamp == this.timestamp);
}

class ThreadEntityCompanion extends UpdateCompanion<ThreadEntityData> {
  final Value<int> id;
  final Value<Platform> platform;
  final Value<String> outerId;
  final Value<String> boardName;
  final Value<String> title;
  final Value<String> body;
  final Value<String> name;
  final Value<String> opcode;
  final Value<String> tripcode;
  final Value<bool> my;
  final Value<int> timestamp;
  const ThreadEntityCompanion({
    this.id = const Value.absent(),
    this.platform = const Value.absent(),
    this.outerId = const Value.absent(),
    this.boardName = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.name = const Value.absent(),
    this.opcode = const Value.absent(),
    this.tripcode = const Value.absent(),
    this.my = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ThreadEntityCompanion.insert({
    this.id = const Value.absent(),
    @required Platform platform,
    @required String outerId,
    @required String boardName,
    @required String title,
    @required String body,
    this.name = const Value.absent(),
    this.opcode = const Value.absent(),
    this.tripcode = const Value.absent(),
    this.my = const Value.absent(),
    @required int timestamp,
  })  : platform = Value(platform),
        outerId = Value(outerId),
        boardName = Value(boardName),
        title = Value(title),
        body = Value(body),
        timestamp = Value(timestamp);
  static Insertable<ThreadEntityData> custom({
    Expression<int> id,
    Expression<int> platform,
    Expression<String> outerId,
    Expression<String> boardName,
    Expression<String> title,
    Expression<String> body,
    Expression<String> name,
    Expression<String> opcode,
    Expression<String> tripcode,
    Expression<bool> my,
    Expression<int> timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (platform != null) 'platform': platform,
      if (outerId != null) 'outer_id': outerId,
      if (boardName != null) 'board_name': boardName,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (name != null) 'name': name,
      if (opcode != null) 'opcode': opcode,
      if (tripcode != null) 'tripcode': tripcode,
      if (my != null) 'my': my,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ThreadEntityCompanion copyWith(
      {Value<int> id,
      Value<Platform> platform,
      Value<String> outerId,
      Value<String> boardName,
      Value<String> title,
      Value<String> body,
      Value<String> name,
      Value<String> opcode,
      Value<String> tripcode,
      Value<bool> my,
      Value<int> timestamp}) {
    return ThreadEntityCompanion(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      outerId: outerId ?? this.outerId,
      boardName: boardName ?? this.boardName,
      title: title ?? this.title,
      body: body ?? this.body,
      name: name ?? this.name,
      opcode: opcode ?? this.opcode,
      tripcode: tripcode ?? this.tripcode,
      my: my ?? this.my,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (platform.present) {
      final converter = $ThreadEntityTable.$converter0;
      map['platform'] = Variable<int>(converter.mapToSql(platform.value));
    }
    if (outerId.present) {
      map['outer_id'] = Variable<String>(outerId.value);
    }
    if (boardName.present) {
      map['board_name'] = Variable<String>(boardName.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (opcode.present) {
      map['opcode'] = Variable<String>(opcode.value);
    }
    if (tripcode.present) {
      map['tripcode'] = Variable<String>(tripcode.value);
    }
    if (my.present) {
      map['my'] = Variable<bool>(my.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThreadEntityCompanion(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('outerId: $outerId, ')
          ..write('boardName: $boardName, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('name: $name, ')
          ..write('opcode: $opcode, ')
          ..write('tripcode: $tripcode, ')
          ..write('my: $my, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $ThreadEntityTable extends ThreadEntity
    with TableInfo<$ThreadEntityTable, ThreadEntityData> {
  final GeneratedDatabase _db;
  final String _alias;
  $ThreadEntityTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _platformMeta = const VerificationMeta('platform');
  GeneratedIntColumn _platform;
  @override
  GeneratedIntColumn get platform => _platform ??= _constructPlatform();
  GeneratedIntColumn _constructPlatform() {
    return GeneratedIntColumn(
      'platform',
      $tableName,
      false,
    );
  }

  final VerificationMeta _outerIdMeta = const VerificationMeta('outerId');
  GeneratedTextColumn _outerId;
  @override
  GeneratedTextColumn get outerId => _outerId ??= _constructOuterId();
  GeneratedTextColumn _constructOuterId() {
    return GeneratedTextColumn('outer_id', $tableName, false, minTextLength: 1);
  }

  final VerificationMeta _boardNameMeta = const VerificationMeta('boardName');
  GeneratedTextColumn _boardName;
  @override
  GeneratedTextColumn get boardName => _boardName ??= _constructBoardName();
  GeneratedTextColumn _constructBoardName() {
    return GeneratedTextColumn('board_name', $tableName, false,
        minTextLength: 1);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _bodyMeta = const VerificationMeta('body');
  GeneratedTextColumn _body;
  @override
  GeneratedTextColumn get body => _body ??= _constructBody();
  GeneratedTextColumn _constructBody() {
    return GeneratedTextColumn(
      'body',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        defaultValue: const Constant(''));
  }

  final VerificationMeta _opcodeMeta = const VerificationMeta('opcode');
  GeneratedTextColumn _opcode;
  @override
  GeneratedTextColumn get opcode => _opcode ??= _constructOpcode();
  GeneratedTextColumn _constructOpcode() {
    return GeneratedTextColumn('opcode', $tableName, false,
        defaultValue: const Constant(''));
  }

  final VerificationMeta _tripcodeMeta = const VerificationMeta('tripcode');
  GeneratedTextColumn _tripcode;
  @override
  GeneratedTextColumn get tripcode => _tripcode ??= _constructTripcode();
  GeneratedTextColumn _constructTripcode() {
    return GeneratedTextColumn('tripcode', $tableName, false,
        defaultValue: const Constant(''));
  }

  final VerificationMeta _myMeta = const VerificationMeta('my');
  GeneratedBoolColumn _my;
  @override
  GeneratedBoolColumn get my => _my ??= _constructMy();
  GeneratedBoolColumn _constructMy() {
    return GeneratedBoolColumn('my', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  GeneratedIntColumn _timestamp;
  @override
  GeneratedIntColumn get timestamp => _timestamp ??= _constructTimestamp();
  GeneratedIntColumn _constructTimestamp() {
    return GeneratedIntColumn(
      'timestamp',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        platform,
        outerId,
        boardName,
        title,
        body,
        name,
        opcode,
        tripcode,
        my,
        timestamp
      ];
  @override
  $ThreadEntityTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'threads';
  @override
  final String actualTableName = 'threads';
  @override
  VerificationContext validateIntegrity(Insertable<ThreadEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    context.handle(_platformMeta, const VerificationResult.success());
    if (data.containsKey('outer_id')) {
      context.handle(_outerIdMeta,
          outerId.isAcceptableOrUnknown(data['outer_id'], _outerIdMeta));
    } else if (isInserting) {
      context.missing(_outerIdMeta);
    }
    if (data.containsKey('board_name')) {
      context.handle(_boardNameMeta,
          boardName.isAcceptableOrUnknown(data['board_name'], _boardNameMeta));
    } else if (isInserting) {
      context.missing(_boardNameMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body'], _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    }
    if (data.containsKey('opcode')) {
      context.handle(_opcodeMeta,
          opcode.isAcceptableOrUnknown(data['opcode'], _opcodeMeta));
    }
    if (data.containsKey('tripcode')) {
      context.handle(_tripcodeMeta,
          tripcode.isAcceptableOrUnknown(data['tripcode'], _tripcodeMeta));
    }
    if (data.containsKey('my')) {
      context.handle(_myMeta, my.isAcceptableOrUnknown(data['my'], _myMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp'], _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ThreadEntityData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ThreadEntityData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ThreadEntityTable createAlias(String alias) {
    return $ThreadEntityTable(_db, alias);
  }

  static TypeConverter<Platform, int> $converter0 =
      const EnumIndexConverter<Platform>(Platform.values);
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $PostEntityTable _postEntity;
  $PostEntityTable get postEntity => _postEntity ??= $PostEntityTable(this);
  $ThreadEntityTable _threadEntity;
  $ThreadEntityTable get threadEntity =>
      _threadEntity ??= $ThreadEntityTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [postEntity, threadEntity];
}
