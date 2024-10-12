import 'dart:io';
import 'package:flutter/foundation.dart';

class ImageImporter {
  ImageImporter();

  List<String> getFileList(String collectionPath) {
    List<String> files = List.empty(growable: true);
    if (FileSystemEntity.isFileSync(collectionPath)) {
      _processFile(collectionPath, files);
    } else if (FileSystemEntity.isDirectorySync(collectionPath)) {
      _processDirectory(collectionPath, files);
    } else {
      debugPrint('Not a file or directory!');
    }

    return files;
  }

  void _processFile(String filePath, List<String> files) {
    files.add(filePath);
  }

  void _processDirectory(String dirPath, List<String> files) {
    final Directory dir = Directory(dirPath);
    final List<FileSystemEntity> entities = dir.listSync();
    for (final FileSystemEntity entity in entities) {
      if (FileSystemEntity.isDirectorySync(entity.path)) {
        _processDirectory(entity.path, files);
      } else {
        _processFile(entity.path, files);
      }
    }
  }
}
