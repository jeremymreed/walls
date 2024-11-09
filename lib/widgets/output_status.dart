import 'package:flutter/material.dart';
import 'package:walls/services/wallsd/get_outputs_settings_response_mapper.dart';
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
              imagePath: _settings.wallpaper, flavor: ThumbnailFlavor.x_large),
        ],
      ),
    );
  }
}
