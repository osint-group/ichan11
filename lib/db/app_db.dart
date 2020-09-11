import 'dart:io';

import 'package:iChan/db/post_entity.dart';
import 'package:iChan/db/thread_entity.dart';
import 'package:iChan/models/thread.dart';
import 'package:iChan/services/enums.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// import 'package:iChan/services/my.dart' as my;

part 'app_db.g.dart';

@UseMoor(tables: [PostEntity, ThreadEntity])
class AppDb extends _$AppDb {
  AppDb()
      : super(
          LazyDatabase(() async {
            final dbFolder = await getApplicationDocumentsDirectory();
            final file = File(p.join(dbFolder.path, 'ichandb.sqlite'));
            return VmDatabase(file);
          }),
        );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            // we added the dueDate property in the change from version 1
            await m.addColumn(postEntity, postEntity.op);
          }
        },
      );

  Future insertPost(PostEntityData post) => into(postEntity).insert(post);

  Future upsertPost(PostEntityData post) => into(postEntity).insert(post);

  Future deletePost({Thread thread, String postId}) {
    return (delete(postEntity)..where((t) => t.outerId.equals(postId))).go();
  }

  Future updatePost({Thread thread, String postId, bool isMine}) {
    return (update(postEntity)..where((t) => t.outerId.equals(postId))).write(PostEntityCompanion(
      my: Value(isMine),
    ));
  }

  Future insertThread(ThreadEntityData thread) => into(threadEntity).insert(thread);

  Future<List<PostEntityData>> getMyPosts() {
    return (select(postEntity)..where((p) => p.my.equals(true))).get();
  }

  Future<List<PostEntityData>> getAllPosts() {
    return (select(postEntity)).get();
  }

  Future<List<PostEntityData>> getPostsInThread(Thread thread) {
    assert(thread != null);

    return (select(postEntity)
          ..where((p) => p.boardName.equals(thread.boardName))
          ..where((p) => p.threadId.equals(thread.outerId))
          ..where((p) => p.my.equals(true)))
        .get();
  }
}
