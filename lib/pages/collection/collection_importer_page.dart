import 'dart:io';
import 'package:flutter/material.dart';
import 'package:walls/main.dart';
import 'package:walls/shell_utils.dart' as shell_utils;
import 'package:walls/models/image_entry.dart';
import 'package:walls/importer/image_importer.dart';
import 'package:walls/importer/image_validator.dart';

class CollectionImporter extends StatefulWidget {
  final VoidCallback onRefresh;

  const CollectionImporter({super.key, required this.onRefresh});

  @override
  State<CollectionImporter> createState() => _CollectionImporterState();
}

class _CollectionImporterState extends State<CollectionImporter> {
  final ImageImporter _imageImporter = ImageImporter();
  final ImageValidator _imageValidator = ImageValidator();
  final TextEditingController _textEditingController = TextEditingController();
  String _collectionPath = '';
  Duration _processFilesDuration = Duration.zero;
  int _numFiles = 0;
  int _numValidImages = 0;
  int _numInvalidFiles = 0;
  int _totalProcessedFiles = 0;

  Future<void> _processFiles() async {
    DateTime start = DateTime.now();
    List<String> files = _imageImporter.getFileList(_collectionPath);
    List<ImageEntry> imageEntries = List<ImageEntry>.empty(growable: true);

    setState(() {
      _numFiles = files.length;
    });

    for (String file in files) {
      ImageEntry? imageEntry = _imageValidator.isSupportedImage(file);

      if (imageEntry != null) {
        imageEntries.add(imageEntry);
      }

      setState(() {
        if (imageEntry != null) {
          _numValidImages++;
        } else {
          _numInvalidFiles++;
        }
        _totalProcessedFiles++;
        _processFilesDuration = DateTime.now().difference(start);
      });

      await Future.delayed(const Duration(milliseconds: 10));
    }

    db.insertImages(imageEntries: imageEntries);
    debugPrint('Inserted ${imageEntries.length} images into the database.');
    setState(() {
      _processFilesDuration = DateTime.now().difference(start);
    });
  }

  @override
  void initState() {
    _collectionPath = shell_utils.expandTilde('~/Pictures/Wallpapers');
    _textEditingController.text = _collectionPath;
    _numFiles = 0;
    _numValidImages = 0;
    _numInvalidFiles = 0;
    _totalProcessedFiles = 0;
    _processFilesDuration = Duration.zero;
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Enter wallpaper collection directory:'),
            const SizedBox(height: 10),
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: _collectionPath,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String collectionPath = shell_utils.expandTilde(
                  _textEditingController.text,
                );
                if (FileSystemEntity.typeSync(collectionPath) !=
                        FileSystemEntityType.notFound &&
                    FileSystemEntity.typeSync(collectionPath) ==
                        FileSystemEntityType.directory) {
                  setState(() {
                    _collectionPath = collectionPath;
                  });
                  await _processFiles();
                  //_imageImporter.run(collectionPath);
                } else {
                  debugPrint(
                      'either collectionPath does not exist or is not a directory');
                }
              },
              child: const Text('Import Wallpapers'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                widget.onRefresh();
              },
              child: const Text('Refresh'),
            ),
            const SizedBox(height: 10),
            Text('Process files duration: $_processFilesDuration'),
            Text('Number of valid images: $_numValidImages'),
            Text('Number of invalid files: $_numInvalidFiles'),
            Text('Total processed files: $_totalProcessedFiles / $_numFiles'),
          ],
        ),
      ),
    );
  }
}
