import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_time_ago/get_time_ago.dart';
// import 'package:helpers/helpers/extensions/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/post_current_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
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
import 'package:social_network_app_mobile/widget/video_player.dart';

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

class PostOneMediaDetail extends ConsumerStatefulWidget {
  final dynamic postMedia;
  final List? medias;
  final int? currentIndex;
  final Function? backFunction;
  final Function? reloadFunction;
  final dynamic post;
  final dynamic type;
  final dynamic preType;
  const PostOneMediaDetail(
      {Key? key,
      this.postMedia,
      this.medias,
      this.currentIndex,
      this.backFunction,
      this.reloadFunction,
      this.post,
      this.type,
      this.preType})
      : super(key: key);

  @override
  ConsumerState<PostOneMediaDetail> createState() => _PostOneMediaDetailState();
}

class _PostOneMediaDetailState extends ConsumerState<PostOneMediaDetail> {
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
  double? _dragOffset;
  double? _initialPosition;
  double? _currentPosition;

  double progress = 0;
  dynamic tag;
  @override
  void initState() {
    super.initState();
    opacityValue = 1;
    _dragOffset = 0;
    Future.delayed(Duration.zero, () {
      ref
          .read(currentPostControllerProvider.notifier)
          .saveCurrentPost(widget.post);
    });

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
    _initialPosition = 0;
    _currentPosition = _initialPosition;

    tag = postRender['media_attachments']?[0]?['id'] ?? postRender['id'];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showActionSheet(BuildContext context1, {required objectItem}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              var status = await Permission.storage.status;
              if (!status.isGranted) {
                await Permission.storage.request();
                var photosStatus = await Permission.photos.status;
                if (!photosStatus.isGranted) {
                  await Permission.photos.request();
                }
              }

              String imageUrl = postRender['media_attachments']?[0]?['url'] ??
                  postRender['url'];
              // Get the image data
              var response = await Dio().get(imageUrl,
                  options: Options(responseType: ResponseType.bytes));
              var dir = await getApplicationDocumentsDirectory();
              String fileName = '${Random().nextInt(10000)}.jpg';
              File file = File('${dir.path}/$fileName');
              await file.writeAsBytes(response.data);
              final result =
                  await GallerySaver.saveImage('${dir.path}/$fileName');
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context1).showSnackBar(SnackBar(
                  content: result == true
                      ? const Text("Lưu ảnh thành công")
                      : result == false && status.isGranted
                          ? const Text(
                              "Lưu ảnh thất bại. Vui lòng cấp quyền cho ứng dụng")
                          : const Text("Lưu ảnh thất bại")));
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

  bool isDismissed = false;

  checkPreType() {
    if (widget.preType != null) return widget.preType;
    dynamic type = widget.type;
    if (type != null) {
      if (type == postPageUser) {
        return postDetailFromUserPage;
      }
      if (type == feedPost) {
        return postDetailFromFeed;
      }
      return type;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    userData = ref.watch(currentPostControllerProvider).currentPost.isNotEmpty
        ? ref.watch(currentPostControllerProvider).currentPost
        : userData;
    String path =
        postRender['media_attachments']?[0]?['url'] ?? postRender['url'];
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        widget.backFunction != null ? widget.backFunction!() : null;
        return true;
      },
      child: Scaffold(
        backgroundColor: blackColor.withOpacity(opacityValue! > 1.0
            ? 1.0
            : opacityValue! < 0.0
                ? 0.0
                : opacityValue!),
        body: Opacity(
          opacity: 1,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isShowDetail = !isShowDetail;
                  });
                },
                child: ExtendedImageGesturePageView.builder(
                  itemCount: widget.medias != null
                      ? widget.medias!.length
                      : postRender['media_attachments'] != null
                          ? postRender['media_attachments'].length
                          : 1,
                  itemBuilder: (BuildContext context, int index) {
                    dynamic pathImg = path;
                    if (postRender['media_attachments'] != null &&
                        postRender['media_attachments'].isNotEmpty) {
                      pathImg = postRender['media_attachments'][index]['url'];
                    } else {
                      if (widget.medias != null && widget.medias!.isNotEmpty) {
                        pathImg = widget.medias![index]['url'];
                      }
                    }
                    Widget image = Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Listener(
                        onPointerUp: (details) {
                          if (progress > 0.06) {
                            setState(() {
                              opacityValue = 0.0;
                            });
                            // widget.backFunction != null
                            //     ? widget.backFunction!()
                            //     : null;
                            popToPreviousScreen(context);
                          }
                        },
                        child: Dismissible(
                          direction: DismissDirection.vertical,
                          key: const Key("dismiss"),
                          resizeDuration: const Duration(milliseconds: 0),
                          onDismissed: (direction) {
                            popToPreviousScreen(context);
                          },
                          confirmDismiss: (direction) async {
                            return false;
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
                              if (opacityValue != 0) {
                                opacityValue = 1 - details.progress * 2;
                              }
                              progress = details.progress;
                            });
                          },
                          child: Hero(
                            tag: postRender['media_attachments']?[index]
                                    ?['id'] ??
                                postRender['id'] ??
                                index,
                            child: ExtendedImage.network(
                              pathImg,
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
                                      doubleTapPosition:
                                          state.pointerDownPosition);
                                } else {
                                  state.handleDoubleTap(
                                      scale: 1.0,
                                      doubleTapPosition:
                                          state.pointerDownPosition);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                    return image;
                  },
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
              buildContent(size)
            ],
          ),
        ),
      ),
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

  buildContent(Size size) {
    return _isDragging
        ? const SizedBox()
        : isShowDetail && opacityValue != 0
            ? SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: Container(
                        width: size.width - 40,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // widget.backFunction != null
                                //     ? widget.backFunction!()
                                //     : null;
                                popToPreviousScreen(context);
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
                                maxHeight: size.height * 0.6, minHeight: 10),
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
                                                ? userData["group"]['title'] ??
                                                    ""
                                                : userData["page"] != null
                                                    ? userData["page"]
                                                            ['title'] ??
                                                        ""
                                                    : userData["account"]
                                                            ['display_name'] ??
                                                        "",
                                            true,
                                            colorWord: white,
                                            fontSize: 14, function: () {
                                          pushToScreen();
                                        }),
                                        buildSpacer(height: 7),
                                        Row(
                                          children: [
                                            Text(
                                              GetTimeAgo.parse(DateTime.parse(
                                                  userData['created_at'])),
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
                                                        userData['visibility'],
                                                    orElse: () => {})['icon'],
                                                size: 13,
                                                color: greyColor)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  buildSpacer(height: 7),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: PostContent(
                                      key: _contentKey,
                                      post: userData,
                                      textColor: white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PostFooterInformation(
                            post: userData,
                            preType: checkPreType(),
                            indexImagePost: widget.currentIndex,
                          ),
                          buildDivider(),
                          SizedBox(
                            height: 40,
                            child: PostFooterButton(
                              post: userData,
                              type: postMultipleMedia,
                              preType: checkPreType(),
                              reloadFunction: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  widget.reloadFunction != null
                                      ? widget.reloadFunction!()
                                      : null;
                                });
                              },
                              indexImage: widget.currentIndex,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox();
  }
}
