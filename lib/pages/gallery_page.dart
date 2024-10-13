import 'package:flutter/material.dart';
import 'package:walls/pages/gallery_delegate.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

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
              gridDelegate: CustomGridDelegate(rawDimension: 240.0),
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  header: GridTileBar(
                    title: Text('$index',
                        style: const TextStyle(color: Colors.black)),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(12.0),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      gradient: const RadialGradient(
                        colors: <Color>[Color(0x0F88EEFF), Color(0x2F0099BB)],
                      ),
                    ),
                    child: const Center(
                      child: Text('Foo!'),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
