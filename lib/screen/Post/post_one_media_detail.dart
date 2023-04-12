import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/widget/video_player.dart';

class PostOneMediaDetail extends StatefulWidget {
  final dynamic postMedia;
  final List? medias;
  final int? currentIndex;
  final Function? backFunction;

  const PostOneMediaDetail(
      {Key? key,
      this.postMedia,
      this.medias,
      this.currentIndex,
      this.backFunction})
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
  bool _isDragging = false;
  double _dragOffset = 0.0;
  PageController? pageController;
  Offset? _dragAnchor;
  final PhotoViewController photoViewController = PhotoViewController();
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _imageKeyDrag = GlobalKey();

  double? opacityValue;
  @override
  void initState() {
    super.initState();
    opacityValue = 1;
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
    pageController = PageController(initialPage: indexRender);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String path =
        postRender['media_attachments']?[0]?['url'] ?? postRender['url'];
    bool isVideo = path.endsWith(".mp4");
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
      if (type == 'prev') {
        if (indexRender >= 1) {
          setState(() {
            postRender = widget.medias![indexRender - 1];
            indexRender = indexRender - 1;
          });
        } else {
          return;
        }
      }
      if (type == 'next') {
        if (indexRender < widget.medias!.length - 1) {
          setState(() {
            postRender = widget.medias![indexRender + 1];
            indexRender = indexRender + 1;
          });
        } else {
          return;
        }
      }
    }

    return Scaffold(
      backgroundColor: _isDragging
          ? Colors.black.withOpacity(0.2)
          : Theme.of(context).scaffoldBackgroundColor,
      body: Opacity(
        opacity: 1,
        child: Stack(
          children: [
            PageView.builder(
              physics: const BouncingScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  postRender = widget.medias![value];
                  indexRender = value;
                });
              },
              scrollDirection: Axis.horizontal,
              controller: pageController,
              itemCount: widget.medias != null
                  ? widget.medias!.length
                  : postRender['media_attachments'] != null
                      ? postRender['media_attachments'].length
                      : 1,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.black.withOpacity(opacityValue!),
                  child: Draggable(
                    axis: Axis.vertical,
                    dragAnchorStrategy: (draggable, context, position) {
                      return position -
                          Offset(MediaQuery.of(context).size.width / 2,
                              MediaQuery.of(context).size.height / 2);
                    },
                    feedback: Container(
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        transform: Matrix4.translationValues(
                            -MediaQuery.of(context).size.width / 2, -200, 0.0),
                        child: isVideo
                            ? VideoPlayerRender(
                                path: path,
                              )
                            : Image.network(
                                path,
                                key: _imageKeyDrag,
                              )),
                    onDragStarted: () {
                      setState(() {
                        _isDragging = true;
                      });
                    },
                    childWhenDragging: const SizedBox(),
                    onDragUpdate: (details) {
                      _dragAnchor ??= Offset(
                          details.globalPosition.dx, details.globalPosition.dy);
                      _dragOffset = details.globalPosition.dy - _dragAnchor!.dy;
                      double differY = (details.globalPosition.dy -
                              MediaQuery.of(context).size.height / 2)
                          .abs();
                      if (_imageKey.currentContext != null) {
                        final RenderBox renderBox = _imageKey.currentContext!
                            .findRenderObject() as RenderBox;
                        final size = renderBox.size;
                      }

                      setState(() {
                        opacityValue = (0.5 -
                                differY /
                                    MediaQuery.of(context).size.height /
                                    2)
                            .abs();
                        _dragOffset += details.delta.dy;
                      });
                    },
                    onDragEnd: (details) {
                      if (_dragOffset.abs() > 100) {
                        // popToPreviousScreen(context);
                        widget.backFunction != null
                            ? widget.backFunction!()
                            : null;
                      }
                      setState(() {
                        _isDragging = false;
                      });
                    },
                    child: Container(
                      color: Colors.black,
                      child: GestureDetector(
                          onScaleStart: (ScaleStartDetails details) {
                            setState(() {
                              _previousScale = _scale;
                            });
                          },
                          onScaleUpdate: (ScaleUpdateDetails details) {
                            setState(() {
                              _scale = _previousScale * details.scale;
                            });
                          },
                          onScaleEnd: (ScaleEndDetails details) {
                            setState(() {
                              _previousScale = 1.0;
                              _scale = 1.0;
                            });
                          },
                          onHorizontalDragEnd: (details) {
                            double velocityX =
                                details.velocity.pixelsPerSecond.dx;
                            if (velocityX > 0) {
                              handleUpdateData('prev');
                            } else if (velocityX < 0) {
                              handleUpdateData('next');
                            }
                          },
                          child: isVideo
                              ? VideoPlayerRender(
                                  path: path,
                                )
                              : Image.network(
                                  path,
                                  key: _imageKey,
                                )),
                    ),
                  ),
                );
              },
            ),
            _isDragging
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.only(top: 70),
                    child: Container(
                      width: size.width - 40,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              widget.backFunction != null
                                  ? widget.backFunction!()
                                  : null;
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
          ],
        ),
      ),
    );
  }
}


                          //   PhotoView(
                          //   key: _imageKey,
                          //   imageProvider: NetworkImage(path),
                          //   heroAttributes: PhotoViewHeroAttributes(
                          //       tag: widget.postMedia['id']),
                          //   backgroundDecoration:
                          //       const BoxDecoration(color: Colors.black),
                          //   initialScale:
                          //       PhotoViewComputedScale.contained * 1.0,
                          //   minScale: PhotoViewComputedScale.contained * 1.0,
                          //   maxScale: PhotoViewComputedScale.covered * 2.0,
                          //   enableRotation: true,
                          //   enablePanAlways: true,
                          //   onScaleEnd: (context, details, controllerValue) {},
                          //   onTapUp: (context, details, controllerValue) {},
                          // ),