import 'package:flutter/material.dart';
import 'package:walls/models/image_entry.dart';
import 'package:walls/widgets/image_card.dart';
import 'package:walls/pages/gallery_delegate.dart';

class GalleryPage extends StatefulWidget {
  final List<ImageEntry> _wallpaperEntries;

  const GalleryPage({super.key, required List<ImageEntry> wallpaperEntries})
      : _wallpaperEntries = wallpaperEntries;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 8.0,
        child: Scrollbar(
          controller: _controller,
          thickness: 10,
          thumbVisibility: true,
          radius: const Radius.circular(10),
          child: GridView.builder(
              controller: _controller,
              padding: const EdgeInsets.all(12.0),
              gridDelegate: CustomGridDelegate(rawDimension: 310.0),
              itemCount: widget._wallpaperEntries.length,
              itemBuilder: (BuildContext context, int index) {
                return ImageCard(
                    index: index, imageEntry: widget._wallpaperEntries[index]);
              }),
        ),
      ),
    );
  }
}
