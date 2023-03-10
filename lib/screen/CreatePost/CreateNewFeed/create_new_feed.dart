import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_feed_menu.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_feed_status.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/checkin.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/emoji_activity.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/friend_tag.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/gif.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/life_event_categories.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/question_anwer.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/CreatePost/page_edit_media_upload.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/PostType/post_target.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_life_event.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/gallery_view.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/grid_layout_image.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/map_widget_item.dart';

class CreateNewFeed extends ConsumerStatefulWidget {
  final dynamic post;
  final String? type;
  const CreateNewFeed({Key? key, this.post, this.type}) : super(key: key);

  @override
  ConsumerState<CreateNewFeed> createState() => _CreateNewFeedState();
}

class _CreateNewFeedState extends ConsumerState<CreateNewFeed> {
  List friendSelected = [];
  List files = [];

  String content = '';
  String gifLink = '';

  dynamic menuSelected;
  dynamic visibility = typeVisibility[0];
  dynamic backgroundSelected;
  dynamic statusActivity;
  dynamic statusQuestion;
  dynamic checkin;
  dynamic lifeEvent;

  bool isUploadVideo = false;

  @override
  void initState() {
    super.initState();
    if (mounted && widget.post != null) {
      setState(() {
        checkin = widget.post['place'];
        statusActivity = widget.post['status_activity'];
        content = widget.post['content'];
        gifLink = widget.post['card']?['link'] ?? '';
        backgroundSelected = widget.post['status_background'];
        visibility = typeVisibility.firstWhere(
            (element) => element['key'] == widget.post['visibility']);
        lifeEvent = widget.post['life_event'];
        // statusQuestion =
        //     widget.post['status_question'] ?? widget.post['status_target'];
      });
    }
  }

  functionConvertFile(file) async {
    if (file == null) return;
    Uint8List? bytes;
    if (file.pickedThumbData == null) {
      bytes = await file.thumbnailData;
    } else {
      bytes = file.pickedThumbData;
    }

    file = file.copyWith(
      pickedThumbData: bytes,
    );

    return await file;
  }

  handleUpdateData(type, data) {
    switch (type) {
      case 'update_visibility':
        setState(() {
          visibility = data;
        });
        break;
      case 'update_content':
        setState(() {
          content = data;
        });

        if (data.length > 150) {
          setState(() {
            backgroundSelected = null;
          });
        }
        break;
      case 'update_friend':
        setState(() {
          friendSelected = data;
        });
        break;
      case 'update_background':
        setState(() {
          backgroundSelected = data;
        });
        break;
      case 'update_gif':
        setState(() {
          gifLink = data;
        });
        break;
      case 'update_status_activity':
        setState(() {
          statusActivity = data;
        });
        break;
      case 'update_status_question':
        setState(() {
          statusQuestion = data;
        });
        break;
      case 'update_checkin':
        setState(() {
          checkin = data;
        });
        break;
      case 'update_file':
        List listPath = [];
        List newFiles = [];

        for (var item in [...files, ...data]) {
          if (!listPath.contains(item['file'].path)) {
            newFiles.add(item);
            listPath.add(item['file'].path);
          }
        }

        setState(() {
          files = newFiles;
        });
        break;
      case 'update_file_description':
        setState(() {
          files = data;
        });
        break;
      case 'updateLifeEvent':
        setState(() {
          setState(() {
            lifeEvent = data;
          });
        });
    }
  }

  handlePress() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: ((context) => PageEditMediaUpload(
                files: files, handleUpdateData: handleUpdateData))));
  }

  handleUploadMedia(index, file) async {
    var fileData = file['file'];
    String fileName = fileData!.path.split('/').last;
    FormData formData;

    dynamic response;
    if (file['type'] == 'image') {
      formData = FormData.fromMap({
        "description": file['description'] ?? '',
        "position": index + 1,
        "file": await MultipartFile.fromFile(fileData.path, filename: fileName),
      });
      response = await MediaApi().uploadMediaEmso(formData);
    } else {
      setState(() {
        isUploadVideo = true;
      });

      var userToken = await SecureStorage().getKeyStorage("token");
      formData = FormData.fromMap({
        "token": userToken,
        "channelId": '2',
        "privacy": '1',
        "name": fileName,
        "mimeType": "video/mp4",
        "position": index + 1,
        "videofile":
            await MultipartFile.fromFile(fileData.path, filename: fileName),
      });
      response = await ApiMediaPetube().uploadMediaPetube(formData);
    }
    return response;
  }

  handleCreatePost() async {
    context.loaderOverlay.show();
    var data = {"status": content, "visibility": visibility['key']};

    if (backgroundSelected != null) {
      data = {...data, 'status_background_id': backgroundSelected['id']};
    }

    if (gifLink.isNotEmpty) {
      data = {
        ...data,
        "extra_body": {"description": "", "link": gifLink, "title": ""}
      };
    }

    if (statusActivity != null) {
      data = {...data, 'status_activity_id': statusActivity['id']};
    }

    if (friendSelected.isNotEmpty) {
      data = {
        ...data,
        'mention_ids': friendSelected.map((e) => e['id']).toList()
      };
    }

    if (statusQuestion != null) {
      data = {
        ...data,
        "post_type": statusQuestion['postType'],
        statusQuestion['postType'] == 'target'
            ? 'status_target'
            : 'status_question': {
          "color": statusQuestion['color'],
          "content": statusQuestion['content'],
        }
      };
    }

    if (checkin != null) {
      data = {...data, 'place_id': checkin['id']};
    }

    if (files.isNotEmpty) {
      List<Future> listUpload = [];
      for (var i = 0; i < files.length; i++) {
        listUpload.add(handleUploadMedia(i, files[i]));
      }
      var results = await Future.wait(listUpload);
      List mediasId = [];
      if (results.isNotEmpty) {
        mediasId = results.map((e) => e['id']).toList();
      }

      data = {...data, "media_ids": mediasId};
    }

    if (lifeEvent != null) {
      data = {...data, "life_event": lifeEvent};
    }

    var response = await PostApi().createStatus(data);

    if (response != null) {
      if (context.mounted) {
        context.loaderOverlay.hide();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(isUploadVideo
                ? "Video trong bài viết đang được xử lý"
                : "Tạo bài viết thành công")));
      }
      if (isUploadVideo) {
        setState(() {
          isUploadVideo = false;
        });
      } else {
        ref
            .read(postControllerProvider.notifier)
            .createUpdatePost(feedPost, response);
      }
    } else {}
  }

  handleUpdatePost() async {
    context.loaderOverlay.show();

    dynamic data = {"content": content};

    if (widget.post['visibility'] != visibility['key']) {
      data['visibility'] = visibility['key'];
    }

    if (backgroundSelected != null &&
        widget.post['status_background']?['id'] != backgroundSelected['id']) {
      data['status_background_id'] = backgroundSelected['id'];
    }

    if (gifLink.isNotEmpty) {
      data["extra_body"] = {"description": "", "link": gifLink, "title": ""};
    }

    if (statusActivity != null &&
        widget.post['status_activity']?['id'] != statusActivity['id']) {
      data = {...data, 'status_activity_id': statusActivity['id']};
    }
    dynamic response = await PostApi().updatePost(widget.post['id'], data);

    ref
        .read(postControllerProvider.notifier)
        .actionUpdateDetailInPost(widget.type, response);

    if (response != null && mounted) {
      context.loaderOverlay.hide();
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cập nhật thành công")));
    }
  }

  checkVisiblePress() {
    if (content.trim().isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(
          child: CupertinoActivityIndicator(),
        ),
        child: GestureDetector(
          onTap: () {
            hiddenKeyboard(context);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const BackIconAppbar(),
                  AppBarTitle(
                      title: widget.post != null
                          ? "Chỉnh sửa bài viết"
                          : "Tạo bài viết"),
                  ButtonPrimary(
                    label: widget.post != null ? 'Lưu' : "Đăng",
                    handlePress: checkVisiblePress()
                        ? widget.post != null
                            ? handleUpdatePost
                            : handleCreatePost
                        : null,
                  )
                ],
              ),
            ),
            // bottomSheet: getBottomSheet(),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CreateFeedStatus(
                            content: content,
                            checkin: checkin,
                            friendSelected: friendSelected,
                            statusActivity: statusActivity,
                            isShowBackground: checkisShowBackground(),
                            visibility: visibility,
                            backgroundSelected: backgroundSelected,
                            handleUpdateData: handleUpdateData),
                        Stack(
                          children: [
                            files.isNotEmpty
                                ? GridLayoutImage(
                                    medias: files, handlePress: (media) {})
                                : const SizedBox(),
                            gifLink.isNotEmpty
                                ? ImageCacheRender(
                                    path: gifLink,
                                    width: size.width,
                                  )
                                : const SizedBox(),
                            statusQuestion != null
                                ? PostTarget(
                                    type: statusQuestion['postType'] == 'target'
                                        ? 'target_create'
                                        : postCreateQuestionAnwer,
                                    statusQuestion: statusQuestion,
                                  )
                                : const SizedBox(),
                            checkin != null
                                ? MapWidgetItem(checkin: checkin)
                                : const SizedBox(),
                            lifeEvent != null
                                ? PostLifeEvent(
                                    post: {'life_event': lifeEvent},
                                  )
                                : const SizedBox(),
                            if (gifLink.isNotEmpty ||
                                files.isNotEmpty ||
                                statusQuestion != null ||
                                checkin != null)
                              Positioned(
                                  top: statusQuestion != null ? 20 : 10,
                                  right: statusQuestion != null ? 20 : 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        files = [];
                                        gifLink = '';
                                        statusQuestion = null;
                                        checkin = null;
                                        lifeEvent = null;
                                      });
                                    },
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.black.withOpacity(0.5)),
                                      child: const Icon(
                                        FontAwesomeIcons.xmark,
                                        color: white,
                                        size: 20,
                                      ),
                                    ),
                                  )),
                            if (files.isNotEmpty)
                              Positioned(
                                  top: 2,
                                  left: 10,
                                  child: SizedBox(
                                    width: 100,
                                    child: ButtonPrimary(
                                      isPrimary: true,
                                      label: "Chỉnh sửa",
                                      handlePress: handlePress,
                                    ),
                                  ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: getBottomSheet(),
                )
              ],
            ),
          ),
        ));
  }

  checkisShowBackground() {
    if (gifLink.isNotEmpty ||
        files.isNotEmpty ||
        content.length > 150 ||
        checkin != null ||
        files.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  handleChooseMenu(menu, subType) {
    if (menu == null) return;

    if (menu['key'] == 'media') {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => Expanded(
                  child: GalleryView(
                      isMutipleFile: true,
                      handleGetFiles: handleUpdateData,
                      filesSelected: files))));
      return;
    }
    setState(() {
      menuSelected = menu;
    });

    Widget body = const SizedBox();
    Widget buttonAppbar = const SizedBox();

    switch (menu['key']) {
      case 'emoji-activity':
        body = EmojiActivity(
            type: subType,
            statusActivity: statusActivity,
            handleUpdateData: handleUpdateData);
        break;
      case 'checkin':
        body = Checkin(
            type: subType,
            checkin: checkin,
            handleUpdateData: handleUpdateData);
        break;
      case 'tag-people':
        body = FriendTag(
            friendsPrePage: friendSelected, handleUpdateData: handleUpdateData);
        buttonAppbar = ButtonPrimary(
          label: "Xong",
          handlePress: () {
            if (subType == 'menu_out') {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context)
                ..pop()
                ..pop();
            }
          },
        );
        break;
      case 'gif':
        body = Gif(handleUpdateData: handleUpdateData);
        break;
      case 'life-event':
        body = LifeEventCategories(handleUpdateData: handleUpdateData);
        break;
      case 'answer':
        body =
            QuestionAnwer(handleUpdateData: handleUpdateData, type: 'question');
        break;
      case 'target':
        body =
            QuestionAnwer(handleUpdateData: handleUpdateData, type: 'target');
        break;
      default:
    }

    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => CreateModalBaseMenu(
                title: menu['label'], body: body, buttonAppbar: buttonAppbar)));
  }

  getBottomSheet() {
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ], color: Theme.of(context).scaffoldBackgroundColor),
        child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, childAspectRatio: 1),
            itemCount: 5,
            itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  child: InkWell(
                      onTap: () {
                        if (index == 4) {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15))),
                              builder: (BuildContext context) {
                                return CreateFeedMenu(
                                    handleChooseMenu: handleChooseMenu);
                              });
                        }
                      },
                      child: index != 4
                          ? listMenuPost[index]['image'] != null
                              ? IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => Expanded(
                                                    child: GalleryView(
                                                  typePage: 'page_edit',
                                                  isMutipleFile: true,
                                                  handleGetFiles:
                                                      handleUpdateData,
                                                  filesSelected: files,
                                                ))));
                                  },
                                  icon: SvgPicture.asset(
                                    listMenuPost[index]['image'],
                                    height: 28,
                                    width: 28,
                                    fit: BoxFit.scaleDown,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    handleChooseMenu(
                                        listMenuPost[index], 'menu_out');
                                  },
                                  child: Icon(
                                    listMenuPost[index]['icon'],
                                    color: Color(listMenuPost[index]['color']),
                                    size: 24,
                                  ),
                                )
                          : IconButton(
                              onPressed: null,
                              icon: Container(
                                width: 26,
                                height: 26,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: greyColor,
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.ellipsis,
                                  color: white,
                                  size: 18,
                                ),
                              ),
                            )),
                )));
  }
}
