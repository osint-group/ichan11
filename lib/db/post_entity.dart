import 'package:iChan/services/enums.dart';
import 'package:moor/moor.dart';

class PostEntity extends Table {
  String get tableName => 'posts';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get platform => intEnum<Platform>()();
  TextColumn get outerId => text().withLength(min: 1)();
  TextColumn get threadId => text().withLength(min: 1)();
  TextColumn get boardName => text().withLength(min: 1)();
  TextColumn get body => text()();
  TextColumn get name => text().nullable()();
  TextColumn get parentId => text().nullable()();
  TextColumn get tripcode => text().nullable()();
  BoolColumn get my => boolean().withDefault(const Constant(false))();
  BoolColumn get sage => boolean().withDefault(const Constant(false))();
  BoolColumn get op => boolean().withDefault(const Constant(false))();
  IntColumn get counter => integer().nullable()();
  IntColumn get timestamp => integer()();

  // @override
  // List<String> get customConstraints =>
  //     ['UNIQUE (outerId, threadId, boardName, platform)'];
}
