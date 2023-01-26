import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageCacheRender extends StatelessWidget {
  final String path;
  final width;
  final height;
  const ImageCacheRender(
      {Key? key, required this.path, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      imageErrorBuilder: (context, error, stackTrace) => const SizedBox(
        child: Text('Lỗi'),
      ),
    );
  }
}
