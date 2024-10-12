class ImageEntry {
  final String path;
  final String hash;
  final int width;
  final int height;
  final DateTime imported;

  ImageEntry(
      {required this.path,
      required this.hash,
      required this.width,
      required this.height,
      required this.imported});

  @override
  String toString() {
    return '''
ImageEntry{
  path: $path,
  hash: $hash,
  width: $width,
  height: $height
  imported: $imported
}
''';
  }
}
