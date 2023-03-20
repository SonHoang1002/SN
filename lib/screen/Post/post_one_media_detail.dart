import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PostOneMediaDetail extends StatefulWidget {
  final dynamic postMedia;
  final List? medias;
  final int? currentIndex;
  const PostOneMediaDetail(
      {Key? key, this.postMedia, this.medias, this.currentIndex})
      : super(key: key);

  @override
  State<PostOneMediaDetail> createState() => _PostOneMediaDetailState();
}

class _PostOneMediaDetailState extends State<PostOneMediaDetail> {
  dynamic postRender;
  bool isShowAction = false;
  int indexRender = 0;
  late double _scale;
  late double _previousScale;

  @override
  void initState() {
    super.initState();
    _scale = 1.0;
    _previousScale = 1.0;
    if (mounted && widget.postMedia != null) {
      setState(() {
        postRender = widget.postMedia;
      });
    }

    if (widget.currentIndex != null) {
      setState(() {
        indexRender = widget.currentIndex ?? 0;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String path =
        postRender['media_attachments']?[0]?['url'] ?? postRender['url'];
    final size = MediaQuery.of(context).size;

    void showActionSheet(BuildContext context, {required objectItem}) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Lưu ảnh',
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Hủy",
                style: TextStyle(fontWeight: FontWeight.w700),
              )),
        ),
      );
    }

    handleUpdateData(type) {
      if (type == 'prev' && indexRender >= 1) {
        setState(() {
          postRender = widget.medias![indexRender - 1];
          indexRender = indexRender - 1;
        });
      } else if (indexRender + 1 < widget.medias!.length) {
        setState(() {
          postRender = widget.medias![indexRender + 1];
          indexRender = indexRender + 1;
        });
      } else {
        return;
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () {
          setState(() {
            isShowAction = !isShowAction;
          });
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            handleUpdateData('prev');
          } else if (details.primaryVelocity! < 0) {
            handleUpdateData('next');
          }
        },
        child: Stack(
          children: [
            GestureDetector(
              onScaleStart: (ScaleStartDetails details) {
                _previousScale = _scale;
              },
              onScaleUpdate: (ScaleUpdateDetails details) {
                setState(() {
                  _scale = _previousScale * details.scale;
                });
              },
              onScaleEnd: (ScaleEndDetails details) {
                _previousScale = 1.0;
              },
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.black,
                child: PhotoView(
                  imageProvider: NetworkImage(path),
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: widget.postMedia['id']),
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.black),
                  initialScale: PhotoViewComputedScale.contained * 1.0,
                  minScale: PhotoViewComputedScale.contained * 1.0,
                  maxScale: PhotoViewComputedScale.covered * 2.0,
                  // scaleStateChangedCallback: (scaleState) {
                  //   if (scaleState == PhotoViewScaleState.initial) {
                  //     Navigator.pop(context);
                  //   }
                  // },
                  scaleStateController: PhotoViewScaleStateController(),
                ),
              ),
            ),
            isShowAction
                ? Positioned(
                    top: 70,
                    child: Container(
                      width: size.width - 40,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.5)),
                              child: const Icon(
                                FontAwesomeIcons.xmark,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          widget.medias != null && widget.medias!.length > 1
                              ? Text(
                                  "${indexRender + 1}/${widget.medias!.length}",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                )
                              : const SizedBox(),
                          GestureDetector(
                              onTap: () {
                                showActionSheet(context,
                                    objectItem: postRender);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withOpacity(0.5)),
                                child: const Icon(
                                  FontAwesomeIcons.ellipsis,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
