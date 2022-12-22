import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class PostMedia extends StatelessWidget {
  final dynamic post;
  const PostMedia({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List medias = post['media_attachments'];

    return renderLayoutMedia(medias);
  }

  checkIsImage(media) {
    return media['type'] == 'image' ? true : false;
  }

  renderLayoutMedia(medias) {
    if (medias.length == 1) {
      if (checkIsImage(medias[0])) {
        return FadeInImage.memoryNetwork(
            placeholder: kTransparentImage, image: medias[0]['url']);
      } else {}
    } else {
      return const SizedBox();
    }
  }
}
