import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class WallpaperCollectionLoader {
  static Future<List<Uint8List>> loadCollection(Uint8List data) async {
    List<Uint8List> wallpapers = [];

    return wallpapers;
  }

  static Future<bool> isSupportedImage(Uint8List data) async {
    try {
      if (await _checkImageValidity("JPEG", data, img.decodeJpg)) {
        //debugPrint('Image is a JPEG');
        return true;
      } else if (await _checkImageValidity("PNG", data, img.decodePng)) {
        //debugPrint('Image is a PNG');
        return true;
      } else {
        //debugPrint('Either this is not a supported image, or not an image at all.');
        return false;
      }
    } catch (error) {
      debugPrint('error: $error');
      return false;
    }
  }

  static Future<bool> _checkImageValidity(
      String banner, Uint8List data, Function f) async {
    try {
      //debugPrint('Trying to decode an $banner');
      var image = await f(data);

      if (image != null) {
        return image.isValid;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint('error: $error');
      return false;
    }
  }
}
