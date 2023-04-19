import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer_button.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer_information.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:extended_image/extended_image.dart';

List typeVisibility = [
  {
    "key": 'public',
    "icon": FontAwesomeIcons.earthAsia,
    "label": 'Công khai',
    "subLabel": 'Tất cả mọi người đều có thể xem'
  },
  {
    "key": 'friend',
    "icon": FontAwesomeIcons.user,
    "label": 'Bạn bè',
    "subLabel": 'Chỉ bạn bè của bạn mới xem được'
  },
  {
    "key": 'private',
    "icon": FontAwesomeIcons.lock,
    "label": 'Riêng tư',
    "subLabel": 'Không hiển thị trên bảng tin của người khác'
  }
];

class PostOneMediaDetail extends StatefulWidget {
  final dynamic postMedia;
  final List? medias;
  final int? currentIndex;
  final Function? backFunction;
  final dynamic post;

  const PostOneMediaDetail(
      {Key? key,
      this.postMedia,
      this.medias,
      this.currentIndex,
      this.backFunction,
      this.post})
      : super(key: key);

  @override
  State<PostOneMediaDetail> createState() => _PostOneMediaDetailState();
}

class _PostOneMediaDetailState extends State<PostOneMediaDetail> {
  dynamic postRender;
  bool isShowAction = false;
  int indexRender = 0;
  bool _isDragging = false;
  final PhotoViewController photoViewController = PhotoViewController();
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _imageKeyDrag = GlobalKey();

  double? opacityValue;
  final GlobalKey _contentKey = GlobalKey();
  dynamic userData;
  bool isShowDetail = true;
  @override
  void initState() {
    super.initState();
    opacityValue = 1;
    if (mounted && widget.postMedia != null) {
      setState(() {
        postRender = widget.postMedia;
        userData = widget.postMedia;
      });
    }
    if (widget.post != null) {
      setState(() {
        userData = widget.post;
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
    final tag = postRender['media_attachments']?[0]?['id'] ?? postRender['id'];
    //down
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

    RenderBox? renderContentBox;
    if (_contentKey.currentContext != null) {
      renderContentBox =
          _contentKey.currentContext!.findRenderObject() as RenderBox;
    }
    return Scaffold(
      backgroundColor: blackColor.withOpacity(opacityValue! > 1.0
          ? 1.0
          : opacityValue! < 0.0
              ? 0.0
              : opacityValue!),
      body: Opacity(
        opacity: opacityValue! > 1.0
            ? 1.0
            : opacityValue! < 0.0
                ? 0.0
                : opacityValue!,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isShowDetail = !isShowDetail;
                });
              },
              child: ExtendedImageGesturePageView.builder(
                itemBuilder: (BuildContext context, int index) {
                  Widget image = Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Dismissible(
                      direction: DismissDirection.vertical,
                      key: const Key('dismiss'),
                      onDismissed: (direction) {
                        widget.backFunction != null
                            ? widget.backFunction!()
                            : null;
                      },
                      onUpdate: (details) {
                        if (details.progress != 0.0) {
                          if (_isDragging == false) {
                            setState(() {
                              _isDragging = true;
                            });
                          }
                        } else {
                          if (_isDragging == true) {
                            setState(() {
                              _isDragging = false;
                              isShowDetail = true;
                            });
                          }
                        }
                        setState(() {
                          opacityValue = 1 - details.progress * 2;
                        });
                      },
                      child: ExtendedImage.network(
                        path,
                        fit: BoxFit.contain,
                        mode: ExtendedImageMode.gesture,
                        initGestureConfigHandler: (handler) {
                          return GestureConfig(
                              minScale: 1.0,
                              maxScale: 3.0,
                              animationMaxScale: 3.5,
                              animationMinScale: 0.8,
                              speed: 1.0,
                              inertialSpeed: 100.0,
                              initialScale: 1.0,
                              cacheGesture: false,
                              inPageView: true);
                        },
                        onDoubleTap: (state) {
                          if (state.gestureDetails!.totalScale == 1.0) {
                            state.handleDoubleTap(
                                scale: 2.0,
                                doubleTapPosition: state.pointerDownPosition);
                          } else {
                            state.handleDoubleTap(
                                scale: 1.0,
                                doubleTapPosition: state.pointerDownPosition);
                          }
                        },
                      ),
                    ),
                  );

                  if (index == indexRender) {
                    return Hero(
                      tag: tag,
                      child: image,
                    );
                  } else {
                    return image;
                  }
                },
                itemCount: widget.medias != null
                    ? widget.medias!.length
                    : postRender['media_attachments'] != null
                        ? postRender['media_attachments'].length
                        : 1,
                onPageChanged: (int value) {
                  setState(() {
                    postRender = widget.medias![value];
                    indexRender = value;
                  });
                },
                controller: ExtendedPageController(
                  initialPage: indexRender,
                ),
                scrollDirection: Axis.horizontal,
              ),
            ),
            _isDragging
                ? const SizedBox()
                : isShowDetail
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 40),
                            child: Container(
                              width: size.width - 40,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  widget.medias != null &&
                                          widget.medias!.length > 1
                                      ? Text(
                                          "${indexRender + 1}/${widget.medias!.length}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
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
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        child: const Icon(
                                          FontAwesomeIcons.ellipsis,
                                          color: Colors.white,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 15),
                            color: blackColor.withOpacity(0.4),
                            width: size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      maxHeight: size.height * 0.6,
                                      minHeight: 10),
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //down
                                              buildTextContentButton(
                                                  userData["group"] != null
                                                      ? userData["group"]
                                                              ['title'] ??
                                                          "Kiểm tra group"
                                                      : userData["page"] != null
                                                          ? userData["page"]
                                                                  ['title'] ??
                                                              "Kiểm tra page"
                                                          : userData["account"][
                                                                  'display_name'] ??
                                                              "hello",
                                                  true,
                                                  colorWord: white,
                                                  fontSize: 14, function: () {
                                                pushToScreen();
                                              }),
                                              buildSpacer(height: 7),
                                              Row(
                                                children: [
                                                  Text(
                                                    GetTimeAgo.parse(
                                                        DateTime.parse(userData[
                                                            'created_at'])),
                                                    style: const TextStyle(
                                                        color: greyColor,
                                                        fontSize: 12),
                                                  ),
                                                  const Text(" · ",
                                                      style: TextStyle(
                                                          color: greyColor)),
                                                  Icon(
                                                      typeVisibility.firstWhere(
                                                          (element) =>
                                                              element['key'] ==
                                                              userData[
                                                                  'visibility'],
                                                          orElse: () =>
                                                              {})['icon'],
                                                      size: 13,
                                                      color: greyColor)
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        buildSpacer(height: 7),
                                        PostContent(
                                          key: _contentKey,
                                          post: userData,
                                          textColor: white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                PostFooterInformation(
                                  post: userData,
                                ),
                                buildDivider(),
                                SizedBox(
                                  height: 40,
                                  child: PostFooterButton(
                                    post: userData,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox()
          ],
        ),
      ),
    );
  }

  dynamic imagePost(dynamic path, double width, double height) {
    return ImageCacheRender(
      key: _imageKeyDrag,
      path: path,
      width: width,
      height: height,
    );
  }

  void pushToScreen() {
    final currentRouter = ModalRoute.of(context)?.settings.name;
    final account = userData['account'] ?? {};
    final page = userData["page"];
    if (userData['place']?['id'] != userData["page"]?['id'] &&
        currentRouter != '/page') {
      Navigator.pushNamed(context, '/page', arguments: page);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserPage(),
            settings: RouteSettings(
              arguments: {'id': account['id']},
            ),
          ));
    }
  }
}



  // double? imageHeight;
    // double? imageWidth;
    // final metaPost =
    //     postRender['media_attachments']?[0]?['meta'] ?? postRender['meta'];
    // if (metaPost["small"] != null) {
    //   imageHeight = double.parse(metaPost["small"]["height"].toString());
    //   imageWidth = double.parse(metaPost["small"]["width"].toString()) >
    //           MediaQuery.of(context).size.width
    //       ? MediaQuery.of(context).size.width
    //       : double.parse(metaPost["small"]["width"].toString());
    // }


// SizedBox(
//   width: size.width * 0.6,
//   child: BlockNamePost(
//     post: postRender,
//     account: postRender["account"] ?? {},
//     description:
//         postRender["description"] ?? "",
//     mentions: postRender["mentions"] ?? [],
//     statusActivity:
//         postRender["statusActivity"] ?? {},
//     group: postRender["group"] ?? [],
//     page: postRender["page"] ?? [],
//     textColor: white,
//   ),
// ),

// PageView.builder(
//   physics: const BouncingScrollPhysics(),
//   onPageChanged: (value) {
//     setState(() {
//       postRender = widget.medias![value];
//       indexRender = value;
//     });
//   },
//   scrollDirection: Axis.horizontal,
//   controller: pageController,
// itemCount: widget.medias != null
//     ? widget.medias!.length
//     : postRender['media_attachments'] != null
//         ? postRender['media_attachments'].length
//         : 1,
//   itemBuilder: (context, index) {
//     return Container(
//       color: Colors.black.withOpacity(opacityValue!),
//       child: Draggable(
//         axis: Axis.vertical,
//         dragAnchorStrategy: (draggable, context, position) {
//           return position -
//               Offset(MediaQuery.of(context).size.width / 2,
//                   MediaQuery.of(context).size.height / 2);
//         },
//         feedback: Container(
//             height: MediaQuery.of(context).size.width,
//             width: MediaQuery.of(context).size.width,
//             transform: Matrix4.translationValues(
//                 -MediaQuery.of(context).size.width / 2, -200, 0.0),
//             child:
//                 //  Hero(
//                 //     tag: tag,
//                 //     child:
//                 isVideo
//                     ? VideoPlayerRender(
//                         path: path,
//                       )
//                     : imageWidth! > imageHeight!
//                         ? imagePost(path, imageWidth, imageHeight)
//                             as ImageCacheRender
//                         : Image.network(
//                             path,
//                             key: _imageKeyDrag,
//                           )),
//         // ),
//         onDragStarted: () {
//           setState(() {
//             _isDragging = true;
//           });
//         },
//         childWhenDragging: const SizedBox(),
//         onDragUpdate: (details) {
//           _dragAnchor ??= Offset(
//               details.globalPosition.dx, details.globalPosition.dy);
//           _dragOffset = details.globalPosition.dy - _dragAnchor!.dy;
//           double differY = (details.globalPosition.dy -
//                   MediaQuery.of(context).size.height / 2)
//               .abs();
//           if (_imageKey.currentContext != null) {
//             final RenderBox renderBox = _imageKey.currentContext!
//                 .findRenderObject() as RenderBox;
//             final size = renderBox.size;
//           }
//           setState(() {
//             opacityValue = (0.5 -
//                     differY /
//                         MediaQuery.of(context).size.height /
//                         2)
//                 .abs();
//             _dragOffset += details.delta.dy;
//           });
//         },
//         onDragEnd: (details) {
//           if (_dragOffset.abs() > 100) {
//             // popToPreviousScreen(context);
//             widget.backFunction != null
//                 ? widget.backFunction!()
//                 : null;
//           }
//           setState(() {
//             _isDragging = false;
//           });
//         },
//         child: Container(
//             color: Colors.black,
//             child: GestureDetector(
//                 onScaleStart: (ScaleStartDetails details) {
//                   setState(() {
//                     _previousScale = _scale;
//                   });
//                 },
//                 onScaleUpdate: (ScaleUpdateDetails details) {
//                   setState(() {
//                     _scale = _previousScale * details.scale;
//                   });
//                 },
//                 onScaleEnd: (ScaleEndDetails details) {
//                   setState(() {
//                     _previousScale = 1.0;
//                     _scale = 1.0;
//                   });
//                 },
//                 onHorizontalDragEnd: (details) {
//                   double velocityX =
//                       details.velocity.pixelsPerSecond.dx;
//                   if (velocityX > 0) {
//                     handleUpdateData('prev');
//                   } else if (velocityX < 0) {
//                     handleUpdateData('next');
//                   }
//                 },
//                 child: Hero(
//                   tag: tag,
//                   child: isVideo
//                       ? VideoPlayerRender(
//                           path: path,
//                         )
//                       //  Image.network(
//                       //       path,
//                       //       key: _imageKeyDrag,
//                       //       scale: _scale,
//                       //     ),
//                       //   )),
//                       : PhotoView(
//                           key: _imageKey,
//                           imageProvider: NetworkImage(path),
//                           backgroundDecoration: const BoxDecoration(
//                               color: Colors.black),
//                           initialScale:
//                               PhotoViewComputedScale.contained *
//                                   1.0,
//                           minScale:
//                               PhotoViewComputedScale.contained *
//                                   1.0,
//                           maxScale:
//                               PhotoViewComputedScale.covered * 2.0,
//                           enableRotation: true,
//                           enablePanAlways: true,
//                           onScaleEnd: (context, details,
//                               controllerValue) {},
//                           onTapUp: (context, details,
//                               controllerValue) {},
//                         ),
//                 ))
//             // : imagePost(path, imageWidth, imageHeight)
//             //     as ImageCacheRender),
//             ),
//       ),
//     );
//   },
// ),
