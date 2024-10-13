import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:dbus/dbus.dart';
import 'package:walls/shell_utils.dart' as shell_utils;

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
