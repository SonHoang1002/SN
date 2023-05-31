import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MediaView extends StatelessWidget {
  final String path;
  const MediaView({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Hero(
          tag: path,
          child: PhotoView(
            imageProvider: NetworkImage(path),
          )),
    );
  }
}
