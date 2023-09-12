import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

class PostLiveStream extends StatefulWidget {
  final dynamic post;
  final String type;
  final dynamic preType;

  const PostLiveStream({Key? key, this.post, required this.type, this.preType})
      : super(key: key);

  @override
  State<PostLiveStream> createState() => _PostLiveStreamState();
}

class _PostLiveStreamState extends State<PostLiveStream> {
  @override
  void initState() {
    super.initState();
  }

  handlePress(media) {}
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List medias = widget.post['media_attachments'];
    return AspectRatio(
      aspectRatio: getAspectMedia(medias[0]),
      child: Center(
        child: buildTextContent("Chưa có live video", false,
            isCenterLeft: false, fontSize: 14),
      ),
    );
  }

  getAspectMedia(media) {
    final size = MediaQuery.sizeOf(context);
    return ((media?['meta']?['original']?['aspect']) ??
        (size.height / size.width));
  }
}
