import 'package:flutter/material.dart';
import 'package:walls/enums/mode.dart';
import 'package:walls/models/output_setting.dart';
import 'package:walls/enums/thumbnail_flavor_enum.dart';
import 'package:walls/widgets/thumbnail.dart';

class OutputStatus extends StatelessWidget {
  final OutputSetting _settings;

  const OutputStatus({super.key, required OutputSetting settings})
      : _settings = settings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Thumbnail(
            imagePath: _settings.wallpaper,
            flavor: ThumbnailFlavor.x_large,
          ),
          const SizedBox(height: 10),
          Text('Name: ${_settings.name}'),
          const SizedBox(height: 10),
          Text('Mode: ${_settings.mode.toShortString()}'),
          const SizedBox(height: 10),
          Text(
              'Resolution: ${_settings.resolution.width}x${_settings.resolution.height}'),
        ],
      ),
    );
  }
}
