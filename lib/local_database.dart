import 'package:walls/main.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:walls/mappers/image_entry_mapper.dart';
import 'package:walls/models/image_entry.dart';

class LocalDatabase {
  final String dbPath;
  late final Database _db;

  LocalDatabase({required this.dbPath});

  Future<void> openLocalDatabase() async {
    loggerWrapper.info('Opening database at $dbPath');
    _db = await openDatabase(dbPath, version: 2, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE wallpapers(
          id INTEGER NOT NULL PRIMARY KEY UNIQUE,
          path TEXT NOT NULL UNIQUE,
          hash TEXT NOT NULL,
          width INTEGER NOT NULL,
          height INTEGER NOT NULL,
          imported DATETIME NOT NULL
        )
      ''');
    });
  }

  bool isOpen() {
    return _db.isOpen;
  }

  Future<List<ImageEntry>> getWallpapers() async {
    var wallpaperList = ImageEntryMapper.mapToImageEntries(
        await _db.rawQuery('SELECT * FROM wallpapers'));

    return wallpaperList;
  }

  Future<void> insertImages({required List<ImageEntry> imageEntries}) async {
    try {
      var batch = _db.batch();

      for (ImageEntry imageEntry in imageEntries) {
        batch.rawInsert(
            'INSERT OR IGNORE INTO wallpapers (path, hash, width, height, imported) VALUES (?, ?, ?, ?, ?)',
            [
              imageEntry.path,
              imageEntry.hash,
              imageEntry.width,
              imageEntry.height,
              imageEntry.imported.toIso8601String()
            ]);
      }
      await batch.commit(noResult: true);
    } catch (ex, stackTrace) {
      loggerWrapper.error('Error inserting data: $ex',
          error: ex, stackTrace: stackTrace);
    }
  }

  Future<void> closeLocalDatabase() async {
    await _db.close();
  }
}
