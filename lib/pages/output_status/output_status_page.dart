import 'package:dbus/dbus.dart';
import 'package:flutter/material.dart';
import 'package:walls/services/wallsd/wallsd_commands.dart';
import 'package:walls/services/wallsd/get_outputs_settings_response_mapper.dart';
import 'package:walls/enums/thumbnail_flavor_enum.dart';
import 'package:walls/widgets/thumbnail.dart';

class OutputStatusPage extends StatefulWidget {
  const OutputStatusPage({super.key});

  @override
  State<OutputStatusPage> createState() => _OutputStatusPageState();
}

class _OutputStatusPageState extends State<OutputStatusPage> {
  late Future<GetOutputsSettingsResponse> _outputsSettingsFuture;
  late List<DropdownMenuEntry<int>> _outputItems;
  late OutputSetting? _selectedOutput;

  List<DropdownMenuEntry<int>> _buildDropdownMenuItems(
      List<OutputSetting> settings) {
    List<DropdownMenuEntry<int>> entries = <DropdownMenuEntry<int>>[];

    for (int i = 0; i < settings.length; i++) {
      entries.add(DropdownMenuEntry<int>(
        label: settings[i].name,
        value: i,
      ));
    }

    return entries;
  }

  @override
  void initState() {
    super.initState();
    _outputsSettingsFuture = sendGetOutputsSettings();
    _outputItems = <DropdownMenuEntry<int>>[];
    _selectedOutput = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _outputsSettingsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          debugPrint('snapshot.data: ${snapshot.data}');
          _outputItems = _buildDropdownMenuItems(snapshot.data!.settings);
          _selectedOutput ??= snapshot.data!.settings[0];

          if (_outputItems.isEmpty) {
            return const Text('No data');
          }

          return Center(
            child: Column(
              children: [
                DropdownMenu<int>(
                  initialSelection: 0,
                  dropdownMenuEntries: _outputItems,
                  onSelected: (int? value) {
                    setState(() {
                      _selectedOutput = snapshot.data!.settings[value!];
                    });

                    debugPrint(
                        'Output setting: ${snapshot.data!.settings[value!]}');
                  },
                ),
                const SizedBox(height: 10),
                Thumbnail(
                    imagePath: _selectedOutput!.wallpaper,
                    flavor: ThumbnailFlavor.x_large),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          if (snapshot.error is DBusServiceUnknownException) {
            return const Center(
              child: Text(
                'Error: Cannot connect with daemon.  Is wallsd running?',
                style: TextStyle(fontSize: 50, color: Colors.red),
              ),
            );
          } else {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 50, color: Colors.red),
              ),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Text('No data!');
        }
      },
    );
  }
}
