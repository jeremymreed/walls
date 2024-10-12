import 'dart:io';

String expandTilde(String path) {
  String? homedir = Platform.environment['HOME'];

  if (homedir == null) {
    throw Exception('homedir was null!');
  }

  // If first char is not a tilde, do nothing.
  if (!path.startsWith('~')) {
    return path;
  }

  return path.replaceFirst('~', homedir);
}
