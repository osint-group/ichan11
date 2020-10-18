import 'package:gallery_saver/gallery_saver.dart';
import 'package:iChan/models/media.dart';
import 'package:iChan/services/exceptions.dart';
import 'package:iChan/services/my.dart' as my;
import 'package:iChan/services/exports.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

mixin MediaActions {
  Future<void> shareMedia(Media media) async {
    if (await Permission.photos.request().isGranted == false) {
      throw MyException("Please allow access to photos");
    }
  }

  Future<bool> saveMedia(Media media) async {
    if (await Permission.photos.request().isGranted == false) {
      throw MyException("Please allow access to photos");
    }

    if (await Permission.storage.request().isGranted == false) {
      throw MyException("Please allow access to photos");
    }

    final album = my.prefs.getString('media_album').presence;

    if (media.isVideo) {
      final file = await my.cacheManager.getSingleFile(media.url);

      if (!isIos && media.ext == 'webm') {
        await ImageGallerySaver.saveFile(file.path);
      } else {
        await GallerySaver.saveVideo(file.path, albumName: album);
      }
      return Future.value(true);
    } else {
      final file = await my.cacheManager.getSingleFile(media.url);
      print('media.ext = ${media.ext}');
      // final file = await my.cacheManager.putFile(media.url, bytes, fileExtension: media.ext);

      if (album != null || isIos) {
        print('file.path = ${file.path}');
        return await GallerySaver.saveImage(file.path, albumName: album);
      } else {
        await ImageGallerySaver.saveFile(file.path);
      }
      return Future.value(true);
    }
  }
}
