import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/screens/Page/PageDetail/photo_page.dart';

class VideoPage extends ConsumerStatefulWidget {
  final dynamic pageData;
  const VideoPage({super.key, this.pageData});

  @override
  ConsumerState<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends ConsumerState<VideoPage> {
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> paramsConfig = {"limit": 20, 'media_type': 'video'};
    if (ref.read(pageControllerProvider).pageVideo.isEmpty) {
      Future.delayed(
          Duration.zero,
          () => ref
              .read(pageControllerProvider.notifier)
              .getListPageMedia(paramsConfig, widget.pageData['id']));
    }
  }

  @override
  Widget build(BuildContext context) {
    List videoPage = ref.watch(pageControllerProvider).pageVideo;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Tất cả video',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
          ),
          const SizedBox(height: 8),
          RenderPhoto(
            photoData: videoPage,
            hasTitle: false,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
