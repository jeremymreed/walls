import 'package:flutter/material.dart';
import 'package:walls/main.dart';
import 'package:walls/models/image_entry.dart';
import 'package:walls/pages/collection/collection_importer_page.dart';
import 'package:walls/pages/collection/gallery_page.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<ImageEntry> _wallpaperEntries = List.empty(growable: true);

  Future<void> _reload() async {
    List<ImageEntry> entries = await db.getWallpapers();
    setState(() {
      _wallpaperEntries = entries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: db.getWallpapers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _wallpaperEntries = snapshot.data!;
            if (_wallpaperEntries.isNotEmpty) {
              return GalleryPage(
                wallpaperEntries: _wallpaperEntries,
              );
            } else {
              return CollectionImporter(onRefresh: _reload);
            }
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
