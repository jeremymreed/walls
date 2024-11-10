import 'package:dbus/dbus.dart';
import 'package:walls/models/resolution.dart';
import 'package:walls/models/get_outputs_settings_response.dart';
import 'package:walls/models/output_setting.dart';

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

    if (struct.children.length != 8) {
      throw Exception('Invalid number of children in struct');
    }

    var name = (struct.children[0] as DBusString).value;
    var width = (struct.children[1] as DBusUint64).value;
    var height = (struct.children[2] as DBusUint64).value;
    var mode = (struct.children[3] as DBusUint32).value;
    var oncalendar = (struct.children[4] as DBusString).value;
    var wallpaper = (struct.children[5] as DBusString).value;
    var numWallpapers = (struct.children[6] as DBusUint64).value;
    var images = (struct.children[7] as DBusArray)
        .children
        .map((e) => (e as DBusString).value)
        .toList();
    settings.add(OutputSetting(name, Resolution(width: width, height: height),
        mode, oncalendar, wallpaper, numWallpapers, images));
  }

  return GetOutputsSettingsResponse(version, status, settings);
}
