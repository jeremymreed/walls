import 'package:walls/enums/mode.dart';
import 'package:walls/models/resolution.dart';

class OutputSetting {
  final String name;
  final Resolution resolution;
  final Mode mode;
  final String oncalendar;
  final String wallpaper;
  final int currentIndex;
  final int numWallpapers;
  final List<String> images;

  OutputSetting(this.name, this.resolution, this.mode, this.oncalendar,
      this.wallpaper, this.currentIndex, this.numWallpapers, this.images);

  @override
  String toString() {
    return 'OutputSetting{name: $name, resolution: $resolution, mode: $mode, oncalendar: $oncalendar, wallpaper: $wallpaper, currentIndex: $currentIndex, numWallpapers: $numWallpapers, images: $images}';
  }
}
