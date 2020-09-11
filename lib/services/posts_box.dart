import 'package:hive/hive.dart';
import 'package:iChan/models/post.dart';
import 'package:iChan/services/box_proxy.dart';
import 'package:iChan/services/exports.dart';

class PostsBox extends BoxProxy {
  PostsBox({this.box});

  final Box<Post> box;

  List<Post> get own => box.values
      .where((e) => e.isMine == true)
      .sortedBy((a, b) => b.timestamp.compareTo(a.timestamp))
      .toList();

  List<Post> get replies => box.values
      .where((e) => e.isToMe == true)
      .sortedBy((a, b) => b.timestamp.compareTo(a.timestamp))
      .toList();
}
