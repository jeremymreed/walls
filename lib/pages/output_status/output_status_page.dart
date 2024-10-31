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

  @override
  void initState() {
    _outputsSettingsFuture = sendGetOutputsSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _outputsSettingsFuture,
      builder: (context, snapshot) {
        return const Text('Testing!');
      },
    );
  }
}
