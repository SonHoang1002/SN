import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/screens/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/header_tabs.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

import '../../../apis/post_api.dart';
import '../../../constant/post_type.dart';
import '../../../helper/push_to_new_screen.dart';

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
              photoData: widget.typeMedia == 'image' ? photoPage : albumPage,
              action: widget.typeMedia == 'image'
                  ? null
                  : (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RenderPageAlbum(
                                    idAlbum: value['id'],
                                    nameAlbum: value['title'],
                                  )));
                    },
              hasTitle: widget.typeMedia == 'image' ? false : true)
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RenderPhoto extends StatefulWidget {
  final List photoData;
  final Function? action;
  final bool hasTitle;
  final dynamic type;
  const RenderPhoto(
      {super.key,
      required this.photoData,
      this.action,
      this.type,
      required this.hasTitle});

  @override
  State<RenderPhoto> createState() => _RenderPhotoState();
}

class _RenderPhotoState extends State<RenderPhoto> {
  fetchApiPostMedia(id, index) async {
    var response = await PostApi().getPostDetailMedia(id);
    if (response != null) {
      // ignore: use_build_context_synchronously
      pushCustomVerticalPageRoute(
          context,
          PostOneMediaDetail(
              currentIndex: index,
              medias: widget.photoData,
              post: response,
              postMedia: widget.photoData[index],
              type: imagePhotoPage,
              backFunction: () {
                popToPreviousScreen(context);
              }),
          opaque: false);
    }
  }

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
        itemCount: widget.photoData.length + (widget.type != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (widget.type != null && index == 0) {
            if (widget.type != null) {
              return ElevatedButton(
                onPressed: () {
                  // Xử lý sự kiện khi nhấn nút "Thêm ảnh"
                },
                child: const Icon(Icons.add),
              );
            } else {
              return const SizedBox.shrink(); // Ẩn nút "Thêm ảnh" cho loại khác
            }
          } else {
            final photoItem =
                widget.photoData[widget.type != null ? index - 1 : index];
            final previewUrl = photoItem?['preview_url'] ??
                photoItem?['url'] ??
                photoItem?['media_attachment']?['preview_url'] ??
                photoItem?['media_attachment']['url'];
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: theme.themeMode == ThemeMode.dark
                      ? Theme.of(context).cardColor
                      : const Color(0xfff1f2f5)),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: InkWell(
                  onTap: () {
                    if (widget.action != null) {
                      widget.action!(widget.photoData[index]);
                    } else {
                      fetchApiPostMedia(widget.photoData[index]['id'], index);
                    }
                  },
                  child: !widget.hasTitle
                      ? ImageCacheRender(
                          height: size.width / 3 - 20,
                          width: size.width / 3 - 20,
                          path: previewUrl)
                      : Stack(
                          alignment: Alignment.bottomCenter,
                          fit: StackFit.expand,
                          children: [
                            SizedBox(
                              child: ImageCacheRender(
                                  height: size.width / 3 - 20,
                                  width: size.width / 3 - 20,
                                  path: previewUrl),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                  width: size.width / 3,
                                  height: 33,
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 11, 0, 2),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(0xFFFFFFFF)
                                            .withOpacity(0.05),
                                        const Color(0xFF000000).withOpacity(0.3)
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    photoItem['title'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  )),
                            )
                          ],
                        ),
                ),
              ),
            );
          }
        });
  }
}

class RenderPageAlbum extends StatefulWidget {
  final List? photoAlbum;
  final int? idAlbum;
  final String? nameAlbum;
  const RenderPageAlbum(
      {super.key, this.photoAlbum, this.idAlbum, this.nameAlbum});

  @override
  State<RenderPageAlbum> createState() => _RenderPageAlbumState();
}

class _RenderPageAlbumState extends State<RenderPageAlbum> {
  List listPhoto = [];
  @override
  void initState() {
    super.initState();
    if (widget.photoAlbum == null && widget.idAlbum != null) {
      fetchListPhotoAlbum();
    }
  }

  fetchListPhotoAlbum() async {
    var response =
        await PageApi().getListPhotoAlbumPageApi({'limit': 25}, widget.idAlbum);
    if (response != null && mounted) {
      setState(() {
        listPhoto = response;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FontAwesomeIcons.angleLeft,
              size: 18,
              color: Theme.of(context).textTheme.titleLarge?.color,
            )),
        title: Text(
          widget.nameAlbum ?? "Album của bạn",
          style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RenderPhoto(
            photoData: widget.photoAlbum ?? listPhoto, hasTitle: false),
      ),
    );
  }
}
