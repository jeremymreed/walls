import 'package:flutter/foundation.dart';
import 'package:dbus/dbus.dart';
import 'package:walls/services/wallsd/get_outputs_settings_response_mapper.dart';

Future<GetOutputsSettingsResponse> sendGetOutputsSettings() async {
  var client = DBusClient.session();
  var object = DBusRemoteObject(
    client,
    name: 'com.thetechforest.WallsD',
    path: DBusObjectPath('/com/thetechforest/WallsD'),
  );

  var response = await object
      .callMethod('com.thetechforest.WallsD', 'GetOutputsSettings', []);

  debugPrint('response: $response');

  debugPrint('response.signature: ${response.signature}');

  await client.close();

  var finalResponse = parseGetOutputsSettingsResponse(response);

  debugPrint('finalResponse: ${finalResponse.toString()}');

  return finalResponse;
}
