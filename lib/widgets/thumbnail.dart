import 'package:walls/main.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:walls/shell_utils.dart' as shell_utils;
import 'package:walls/enums/thumbnail_flavor_enum.dart';
import 'package:walls/services/thumbnailer/thumbnailer.dart';

enum ThumbnailStatus {
  idle,
  loading,
  loaded,
  error,
}

class Thumbnail extends StatefulWidget {
  final String _imagePath;
  final ThumbnailFlavor _flavor;

  const Thumbnail(
      {super.key,
      required String imagePath,
      ThumbnailFlavor flavor = ThumbnailFlavor.large})
      : _imagePath = imagePath,
        _flavor = flavor;

  @override
  State<Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  late Future<void> _thumbnailFuture;
  ThumbnailStatus _thumbnailStatus = ThumbnailStatus.idle;
  String _thumbnailPath = '';
  // This should be a user setting.
  //final ThumbnailFlavor _selectedFlavor = ThumbnailFlavor.large;

  @override
  void initState() {
    super.initState();
    _thumbnailFuture = _requestThumbnail();
  }

  @override
  void didUpdateWidget(covariant Thumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._imagePath != widget._imagePath ||
        oldWidget._flavor != widget._flavor) {
      _thumbnailFuture = _requestThumbnail();
    }
  }

  Future<void> _requestThumbnail() async {
    String imagePath = shell_utils.expandTilde(widget._imagePath);
    loggerWrapper.info('_imagePath: ${widget._imagePath}');
    File file = File(imagePath);

    if (!file.existsSync()) {
      loggerWrapper.error('File does not exist');
      setState(() {
        _thumbnailStatus = ThumbnailStatus.error;
      });
      return;
    }

    // In the future this function should return a folder icon.
    // There are no directories in the database, but we'll have a
    // a file picker for importing individual files.
    // For now, this is ok.
    if (FileSystemEntity.isDirectorySync(imagePath)) {
      loggerWrapper.error('Cannot thumbnail a directory.');
      setState(() {
        _thumbnailStatus = ThumbnailStatus.error;
      });
    }

    String thumbnailPath =
        '~/.cache/thumbnails/${toHyphenString(widget._flavor.name)}/${generateThumbnailFilename(file)}';
    thumbnailPath = shell_utils.expandTilde(thumbnailPath);

    if (File(thumbnailPath).existsSync()) {
      loggerWrapper.info('Thumbnail already exists');
      setState(() {
        _thumbnailPath = thumbnailPath;
        _thumbnailStatus = ThumbnailStatus.loaded;
      });
    } else {
      loggerWrapper.info('Thumbnail does not exist');
      setState(() {
        _thumbnailStatus = ThumbnailStatus.loading;
      });

      await requestThumbnail(file, toHyphenString(widget._flavor.name));

      if (File(thumbnailPath).existsSync()) {
        setState(() {
          _thumbnailPath = thumbnailPath;
          _thumbnailStatus = ThumbnailStatus.loaded;
        });
        loggerWrapper.info('_thumbnailPath: $_thumbnailPath');
      } else {
        loggerWrapper.error('Thumbnail not created');
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
