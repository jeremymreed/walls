import 'package:dbus/dbus.dart';

class OutputSetting {
  final String name;
  final int mode;
  final String oncalendar;
  final String wallpaper;
  final int numWallpapers;

  OutputSetting(this.name, this.mode, this.oncalendar, this.wallpaper,
      this.numWallpapers);

  @override
  String toString() {
    return 'OutputSetting{name: $name, mode: $mode, oncalendar: $oncalendar, wallpaper: $wallpaper, numWallpapers: $numWallpapers}';
  }
}

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

GetOutputsSettingsResponse parseGetOutputsSettingsResponse(
    DBusMethodSuccessResponse response) {
  if (response.values.length != 3) {
    throw Exception('Invalid number of values in response');
  }

  var version = (response.values[0] as DBusUint32).value;
  var status = (response.values[1] as DBusString).value;
  var settings = <OutputSetting>[];
  for (var value in (response.values[2] as DBusArray).children) {
    var struct = value as DBusStruct;

    if (struct.children.length != 5) {
      throw Exception('Invalid number of children in struct');
    }

    var name = (struct.children[0] as DBusString).value;
    var mode = (struct.children[1] as DBusUint32).value;
    var oncalendar = (struct.children[2] as DBusString).value;
    var wallpaper = (struct.children[3] as DBusString).value;
    var numWallpapers = (struct.children[4] as DBusUint64).value;
    settings
        .add(OutputSetting(name, mode, oncalendar, wallpaper, numWallpapers));
  }

  return GetOutputsSettingsResponse(version, status, settings);
}
