import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:dbus/dbus.dart';
import 'package:walls/shell_utils.dart' as shell_utils;

// What happens if the thumbnailer never returns a signal?
// We're assuming we'll be getting a Finished signal for every request.
// Also assuming that if there is an Error, we'll also get a Finished signal.
// Need to have a time out.
Future<bool> requestThumbnail(File file, String thumbnailFlavor) async {
  var client = DBusClient.session();
  var object = DBusRemoteObject(client,
      name: 'org.freedesktop.thumbnails.Thumbnailer1',
      path: DBusObjectPath('/org/freedesktop/thumbnails/Thumbnailer1'));
  var objectManager = DBusRemoteObjectManager(client,
      name: 'org.freedesktop.thumbnails.Thumbnailer1',
      path: DBusObjectPath('/org/freedesktop/thumbnails/Thumbnailer1'));
  var values = [
    DBusArray(DBusSignature('s'),
        [DBusString('file://${shell_utils.expandTilde(file.path)}')]),
    // TODO: Does the thumbnailer even look at this?  It seems to ignore it.
    DBusArray(DBusSignature('s'), [const DBusString('image/jpeg')]),
    DBusString(thumbnailFlavor),
    const DBusString('foreground'),
    const DBusUint32(0),
  ];
  bool complete = false;
  try {
    debugPrint('Requesting thumbnail for ${file.path}');
    objectManager.signals.listen((signal) {
      debugPrint('Signal received: ${signal.name}');

      if (signal.name == 'Finished') {
        var id = signal.values[0];
        debugPrint('Finished signal received: ${id.toNative()}');
        complete = true;
      }
    });
    var result = await object.callMethod(
        'org.freedesktop.thumbnails.Thumbnailer1', 'Queue', values,
        replySignature: DBusSignature('u'));
    var id = result.returnValues[0];
    debugPrint('Query response: ${id.toNative()}');

    // Wait for the Finished signal.  Add a time out here.
    int milliseconds = 10000;
    while (!complete && milliseconds > 0) {
      await Future.delayed(const Duration(milliseconds: 100));
      milliseconds -= 100;
    }
  } on DBusServiceUnknownException {
    debugPrint('Thumbnailer service not available');
    return false;
  }
  await client.close();
  return complete;
}

String generateThumbnailFilename(File file) {
  String fullPath = 'file://${file.path}';

  var data = utf8.encode(fullPath);
  var hash = md5.convert(data);

  debugPrint('Thumbnail file name: ${hash.toString()}.png');

  return '${hash.toString()}.png';
}
