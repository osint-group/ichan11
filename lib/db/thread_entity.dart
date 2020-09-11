import 'package:iChan/services/enums.dart';
import 'package:moor/moor.dart';

class ThreadEntity extends Table {
  String get tableName => 'threads';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get platform => intEnum<Platform>()();
  TextColumn get outerId => text().withLength(min: 1)();
  TextColumn get boardName => text().withLength(min: 1)();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get opcode => text().withDefault(const Constant(''))();
  TextColumn get tripcode => text().withDefault(const Constant(''))();
  BoolColumn get my => boolean().withDefault(const Constant(false))();
  IntColumn get timestamp => integer()();
}
