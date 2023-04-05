import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/header_tabs.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PhotoPage extends ConsumerStatefulWidget {
  final dynamic pageData;
  final Function? handleTypeMedia;
  final String typeMedia;
  const PhotoPage(
      {super.key,
      this.handleTypeMedia,
      required this.typeMedia,
      this.pageData});

  @override
  ConsumerState<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends ConsumerState<PhotoPage> {
  List listAboutPage = [];
  bool? quickShow = false;
  String type = 'image';

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> paramsConfig = {
      "limit": 30,
      'media_type': widget.typeMedia
    };
    if (ref.read(pageControllerProvider).pagePhoto.isEmpty && type == 'image') {
      Future.delayed(
          Duration.zero,
          () => ref
              .read(pageControllerProvider.notifier)
              .getListPageMedia(paramsConfig, widget.pageData['id']));
    }
  }

  @override
  Widget build(BuildContext context) {
    List photoPage = ref.watch(pageControllerProvider).pagePhoto;
    List albumPage = ref.watch(pageControllerProvider).pageAlbum;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Tất cả ảnh',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HeaderTabs(
                chooseTab: (tab) {
                  if (mounted && widget.handleTypeMedia != null) {
                    widget.handleTypeMedia!(tab);
                    type = tab;
                    if (ref.read(pageControllerProvider).pageAlbum.isEmpty &&
                        type == 'album') {
                      Future.delayed(
                          Duration.zero,
                          () => ref
                              .read(pageControllerProvider.notifier)
                              .getListPageAlbum(
                                  {'limit': 30}, widget.pageData['id']));
                    }
                  }
                },
                listTabs: const [
                  {
                    "key": "image",
                    "label": "Ảnh",
                  },
                  {
                    "key": "album",
                    "label": "Album",
                  },
                ],
                tabCurrent: widget.typeMedia,
              ),
            ),
          ),
          const SizedBox(height: 8),
          RenderPhoto(
              photoData: widget.typeMedia == 'image' ? photoPage : albumPage)
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RenderPhoto extends StatelessWidget {
  final List photoData;
  const RenderPhoto({super.key, required this.photoData});

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    final size = MediaQuery.of(context).size;

    return GridView.builder(
        shrinkWrap: true,
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5,
            mainAxisSpacing: 7,
            crossAxisCount: 3,
            childAspectRatio: 0.8),
        itemCount: photoData.length,
        itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: theme.themeMode == ThemeMode.dark
                      ? Theme.of(context).cardColor
                      : const Color(0xfff1f2f5)),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: ImageCacheRender(
                    height: size.width / 3 - 20,
                    width: size.width / 3 - 20,
                    path: photoData[index]?['preview_url'] ??
                        photoData[index]?['url'] ??
                        photoData[index]?['media_attachment']['preview_url'] ??
                        photoData[index]?['media_attachment']['url']),
              ),
            ));
  }
}
