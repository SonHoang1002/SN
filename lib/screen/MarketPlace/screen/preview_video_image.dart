import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/video_player.dart';

import '../../../../widget/back_icon_appbar.dart';

class PreviewVideoImage extends ConsumerStatefulWidget {
  final dynamic src;
  final String category;
  const PreviewVideoImage(
      {super.key, required this.src, required this.category});
  @override
  ConsumerState<PreviewVideoImage> createState() =>
      _PreviewVideoImageComsumerState();
}

class _PreviewVideoImageComsumerState extends ConsumerState<PreviewVideoImage> {
  late double width = 0;
  late double height = 0;
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [BackIconAppbar(), SizedBox()],
          ),
        ),
        body: _buildReviewBody());
  }

  Widget _buildReviewBody() {
    return widget.category == "image"
        ? Center(
            child: ImageCacheRender(
              path: widget.src,
              height: 400,
              width: 300,
            ),
          )
        : Center(
            child: Container(
                height: 400,
                width: 300,
                child: VideoPlayerRender(path: widget.src)));
  }
}
