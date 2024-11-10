import 'package:walls/models/output_setting.dart';

class GetOutputsSettingsResponse {
  final int version;
  final String status;
  final List<OutputSetting> settings;

  GetOutputsSettingsResponse(this.version, this.status, this.settings);

  @override
  String toString() {
    return 'GetOutputsSettingsResponse{version: $version, status: $status, settings: $settings}';
  }
}
