// Needed for ThumbnailFlavor enum.
// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:walls/shell_utils.dart' as shell_utils;
import 'package:walls/services/thumbnailer.dart';

enum ThumbnailStatus {
  idle,
  loading,
  loaded,
  error,
}

enum ThumbnailFlavor {
  normal,
  large,
  x_large,
  xx_large,
}

String toHyphenString(String input) {
  return input.replaceAll('_', '-');
}

class Thumbnail extends StatefulWidget {
  final String _imagePath;

  const Thumbnail({super.key, required String imagePath})
      : _imagePath = imagePath;

  @override
  State<Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  late Future<void> _thumbnailFuture;
  ThumbnailStatus _thumbnailStatus = ThumbnailStatus.idle;
  String _thumbnailPath = '';
  // This should be a user setting.
  final String _selectedFlavor = toHyphenString(ThumbnailFlavor.large.name);

  @override
  void initState() {
    _thumbnailFuture = _requestThumbnail();
    super.initState();
  }

  Future<void> _requestThumbnail() async {
    String imagePath = shell_utils.expandTilde(widget._imagePath);
    debugPrint('_imagePath: ${widget._imagePath}');
    File file = File(imagePath);

    if (!FileSystemEntity.isFileSync(imagePath) &&
        !FileSystemEntity.isDirectorySync(imagePath)) {
      debugPrint('File does not exist');
      setState(() {
        _thumbnailStatus = ThumbnailStatus.error;
      });
      return;
    }

    if (FileSystemEntity.isDirectorySync(imagePath)) {
      debugPrint('Cannot thumbnail a directory.');
      setState(() {
        _thumbnailStatus = ThumbnailStatus.error;
      });
    }

    String thumbnailPath =
        '~/.cache/thumbnails/$_selectedFlavor/${generateThumbnailFilename(file)}';
    thumbnailPath = shell_utils.expandTilde(thumbnailPath);

    if (File(thumbnailPath).existsSync()) {
      debugPrint('Thumbnail already exists');
      setState(() {
        _thumbnailPath = thumbnailPath;
        _thumbnailStatus = ThumbnailStatus.loaded;
      });
    } else {
      debugPrint('Thumbnail does not exist');
      setState(() {
        _thumbnailStatus = ThumbnailStatus.loading;
      });

      await requestThumbnail(file, _selectedFlavor);

      if (File(thumbnailPath).existsSync()) {
        setState(() {
          _thumbnailPath = thumbnailPath;
          _thumbnailStatus = ThumbnailStatus.loaded;
        });
        debugPrint('_thumbnailPath: $_thumbnailPath');
      } else {
        debugPrint('Thumbnail not created');
        setState(() {
          _thumbnailStatus = ThumbnailStatus.error;
        });
      }
    }
  }

  Widget _generateThumbnail() {
    switch (_thumbnailStatus) {
      case ThumbnailStatus.idle:
        return const SizedBox();
      case ThumbnailStatus.loading:
        return const CircularProgressIndicator();
      case ThumbnailStatus.loaded:
        return Image.file(
          File(_thumbnailPath),
        );
      case ThumbnailStatus.error:
        return const Icon(Icons.error_outline, color: Colors.red, size: 128.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _thumbnailFuture,
        builder: (context, snapshot) {
          return _generateThumbnail();
        });
  }
}
