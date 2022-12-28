import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_media.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';

class MomentVideo extends StatefulWidget {
  const MomentVideo({Key? key, this.moment}) : super(key: key);
  final dynamic moment;

  @override
  // ignore: library_private_types_in_public_api
  _MomentVideoState createState() => _MomentVideoState();
}

class _MomentVideoState extends State<MomentVideo> {
  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(bottom: BorderSide(width: 0.3, color: greyColor))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: widget.moment['media_attachments'][0]['meta']['small']
                        ['aspect'] <
                    0.58
                ? size.height - 66
                : null,
            child: FeedVideo(
                type: postMoment,
                path: widget.moment['media_attachments'][0]['url'],
                flickMultiManager: flickMultiManager,
                image: widget.moment['media_attachments'][0]['preview_url']),
          ),
        ],
      ),
    );
  }
}
