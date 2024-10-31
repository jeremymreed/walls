import 'package:flutter/material.dart';
import 'package:walls/services/wallsd/wallsd_commands.dart';
import 'package:walls/services/wallsd/get_outputs_settings_response_mapper.dart';

class OutputStatusPage extends StatefulWidget {
  const OutputStatusPage({super.key});

  @override
  State<OutputStatusPage> createState() => _OutputStatusPageState();
}

class _OutputStatusPageState extends State<OutputStatusPage> {
  late Future<GetOutputsSettingsResponse> _outputsSettingsFuture;
  late List<DropdownMenuEntry<int>> _outputItems;
  late int? _selectedOutput;

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
    _selectedOutput = 0;
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

          if (_outputItems.isEmpty) {
            return const Text('No data');
          }

          return Center(
            child: DropdownMenu<int>(
              initialSelection: 0,
              dropdownMenuEntries: _outputItems,
              onSelected: (int? value) {
                setState(() {
                  _selectedOutput = value;
                });
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
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
