import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/image_cache.dart';
import 'package:market_place/widgets/video_render_player.dart';

class PreviewVideoImage extends StatefulWidget {
  final List<dynamic> src;
  int? index;
  PreviewVideoImage({super.key, required this.src, this.index});
  @override
  State<PreviewVideoImage> createState() => _PreviewVideoImageComsumerState();
}

class _PreviewVideoImageComsumerState extends State<PreviewVideoImage> {
  late double width = 0;
  late double height = 0;
  int? _currentPage;
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();
    _currentPage = widget.index ?? 0;
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
    return PreloadPageView.builder(
      controller: PreloadPageController(initialPage: _currentPage!),
      itemCount: widget.src.length,
      itemBuilder: (context, index) {
        final data = widget.src[index];
        return data.endsWith(".mp4")
            ? Center(
                child: SizedBox(
                    height: 350,
                    width: 250,
                    child: VideoPlayerRender(path: data)),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageCacheRender(
                    path: data,
                    height: 400.0,
                    width: width,
                  ),
                ],
              );
      },
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }
}
