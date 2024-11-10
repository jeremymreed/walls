import 'package:dbus/dbus.dart';
import 'package:flutter/material.dart';
import 'package:walls/services/wallsd/wallsd_commands.dart';
import 'package:walls/models/output_setting.dart';
import 'package:walls/models/get_outputs_settings_response.dart';
import 'package:walls/widgets/output_status.dart';

class OutputStatusPage extends StatefulWidget {
  const OutputStatusPage({super.key});

  @override
  State<OutputStatusPage> createState() => _OutputStatusPageState();
}

class _OutputStatusPageState extends State<OutputStatusPage> {
  late Future<GetOutputsSettingsResponse> _outputsSettingsFuture;
  late List<DropdownMenuEntry<int>> _outputItems;
  late int _selectedOutputIndex;

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
    _selectedOutputIndex = 0;
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

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownMenu<int>(
                      initialSelection: 0,
                      dropdownMenuEntries: _outputItems,
                      onSelected: (int? value) {
                        setState(() {
                          _selectedOutputIndex = value!;
                        });

                        debugPrint(
                            'Output setting: ${snapshot.data!.settings[value!]}');
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _outputsSettingsFuture = sendGetOutputsSettings();
                      });
                    },
                    child: const Icon(Icons.refresh),
                  ),
                ],
              ),
              OutputStatus(
                settings: snapshot.data!.settings[_selectedOutputIndex],
              ),
            ],
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
