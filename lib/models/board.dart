import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:iChan/services/enums.dart';

part 'board.g.dart';

@HiveType(typeId: 3)
class Board extends HiveObject {
  Board(
    this.id, {
    this.name,
    @required this.platform,
    this.category = '',
    this.bumpLimit = 0,
    this.isFavorite = false,
  });

  factory Board.fromMap(Map<String, dynamic> json) {
    return Board(
      json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      bumpLimit: json['bump_limit'] as int,
      platform: json['platform'],
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final int bumpLimit;

  @HiveField(4)
  Platform platform;

  @HiveField(5)
  bool isFavorite;

  bool equalsTo(Board otherBoard) {
    return id == otherBoard.id && platform == otherBoard.platform;
  }

  String toString() => "Board: $id, name: $name, platform: ${platform.toString()}";
}
