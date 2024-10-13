import 'package:flutter/material.dart';
import 'package:walls/models/image_entry.dart';
import 'package:walls/widgets/thumbnail.dart';

class ImageCard extends StatefulWidget {
  final int _index;
  final ImageEntry _imageEntry;

  const ImageCard(
      {super.key, required int index, required ImageEntry imageEntry})
      : _index = index,
        _imageEntry = imageEntry;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  @override
  Widget build(BuildContext context) {
    return GridTile(
      header: GridTileBar(
        title: Text('${widget._index}',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: Column(
            children: <Widget>[
              Thumbnail(imagePath: widget._imageEntry.path),
              Text('Name: ${widget._imageEntry.path}'),
            ],
          )),
        ),
      ),
    );
  }
}
