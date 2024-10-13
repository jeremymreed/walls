import 'package:walls/models/image_entry.dart';

class ImageEntryMapper {
  static List<ImageEntry> mapToImageEntries(
      List<Map<String, Object?>> rawData) {
    return rawData.map((entry) => mapToImageEntry(entry)).toList();
  }

  static ImageEntry mapToImageEntry(Map<String, Object?> rawData) {
    return ImageEntry(
      path: rawData['path'] as String,
      hash: rawData['hash'] as String,
      width: rawData['width'] as int,
      height: rawData['height'] as int,
      imported: DateTime.parse(rawData['imported'] as String),
    );
  }
}
