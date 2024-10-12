import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:walls/image_entry.dart';

class LocalDatabase {
  final String dbPath;
  late final Database _db;

  LocalDatabase({required this.dbPath});

  Future<void> openLocalDatabase() async {
    debugPrint('Opening database at $dbPath');
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

  Future<List<Map<String, Object?>>> getWallpapers() async {
    var wallpaperList = await _db.rawQuery('SELECT * FROM wallpapers');

    for (var wallpaper in wallpaperList) {
      debugPrint('Wallpaper: $wallpaper');
    }

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
    } catch (ex) {
      debugPrint('Error inserting data: $ex');
    }
  }

  Future<void> closeLocalDatabase() async {
    await _db.close();
  }
}