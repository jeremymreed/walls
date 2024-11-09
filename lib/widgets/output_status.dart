import 'package:flutter/material.dart';
import 'package:walls/services/wallsd/get_outputs_settings_response_mapper.dart';
import 'package:walls/enums/thumbnail_flavor_enum.dart';
import 'package:walls/widgets/thumbnail.dart';

class OutputStatus extends StatefulWidget {
  final OutputSetting _settings;

  const OutputStatus({super.key, required OutputSetting settings})
      : _settings = settings;

  @override
  State<OutputStatus> createState() => _OutputStatusState();
}

class _OutputStatusState extends State<OutputStatus> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Thumbnail(
              imagePath: widget._settings.wallpaper,
              flavor: ThumbnailFlavor.x_large),
        ],
      ),
    );
  }
}
