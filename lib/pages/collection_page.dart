import 'package:flutter/material.dart';
import 'package:walls/main.dart';
import 'package:walls/pages/importer_page.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: db.getWallpapers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, Object?>> wallpaperEntries = snapshot.data!;
            if (wallpaperEntries.isNotEmpty) {
              return const Text('Gallery');
            } else {
              return const CollectionImporter();
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
