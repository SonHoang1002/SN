import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/create_post_apis/preview_url_post_api.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/data/background_post.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_feed_status.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/checkin.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/emoji_activity.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/friend_tag.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/gif.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/life_event_categories.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/poll_body.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/question_anwer.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/CreatePost/page_edit_media_upload.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/PostType/post_poll.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/PostType/post_target.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_life_event.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/Map/map_widget_item.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/gallery_view.dart';
import 'package:social_network_app_mobile/widget/Posts/drag_bottom_sheet.dart';
import 'package:social_network_app_mobile/widget/Posts/drag_icon.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/grid_layout_image.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../providers/create_feed/feed_draft_provider.dart';
import 'package:dio/src/multipart_file.dart';

class CreateNewFeed extends ConsumerStatefulWidget {
  final dynamic post;
  final String? type;
  final dynamic postDiscussion;
  const CreateNewFeed({Key? key, this.post, this.type, this.postDiscussion})
      : super(key: key);

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
  dynamic poll;

  bool isUploadVideo = false;

  bool _isShow = true;
  bool isActiveBackground = false;
  double height = 0;
  double width = 0;
  dynamic postDiscussion;
  dynamic previewUrlData;
  bool showPreviewImage = true;
  ScrollController menuController = ScrollController();
  bool isMenuMinExtent = true;
  @override
  void initState() {
    super.initState();
    final draftContent = ref.read(draftFeedController);
    gifLink = draftContent.gifLink;
    files = draftContent.files;
    content = draftContent.content;
    checkin = draftContent.checkin;
    previewUrlData = draftContent.previewUrlData;
    poll = draftContent.poll;
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
        poll = widget.post["poll"];
        // statusQuestion =
        //     widget.post['status_question'] ?? widget.post['status_target'];
      });
    }
    if (mounted && widget.postDiscussion != null) {
      setState(() {
        postDiscussion = widget.postDiscussion!;
      });
    }
    menuController.addListener(() {
      if (menuController.offset <= menuController.position.minScrollExtent) {
        setState(() {
          isMenuMinExtent = true;
        });
      } else {
        setState(() {
          isMenuMinExtent = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  Future handleGetPreviewUrl(dynamic value) async {
    dynamic firstUrl = "";
    RegExp regExp =
        RegExp(r"(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+");
    final matches = regExp.allMatches(value).toList();
    for (Match match in matches) {
      firstUrl = match.group(0);
    }
    if (firstUrl != "") {
      final response = await PreviewUrlPostApi().getPreviewUrlPost(firstUrl);
      if (response != null && response.isNotEmpty) {
        if (previewUrlData == null) {
          if (response[0]["url"] == null) {
            setState(() {
              previewUrlData = response[0];
              showPreviewImage = false;
            });
          }
          setState(() {
            previewUrlData = response[0];
          });
        }
      }
    }
  }

  handleResetPreviewUrl() {
    setState(() {
      previewUrlData = null;
      showPreviewImage = true;
    });
  }

  handleHidePreviewUrl() {
    setState(() {
      showPreviewImage = false;
    });
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
      case 'update_poll':
        setState(() {
          poll = data;
        });
        break;
      case 'updateLifeEvent':
        setState(() {
          lifeEvent = data;
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
    if (poll != null) {
      data = {...data, 'poll': poll};
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
    if (postDiscussion != null) {
      data = {...data, ...postDiscussion};
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
        String? type = widget.type ?? feedPost;
        ref
            .read(postControllerProvider.notifier)
            .createUpdatePost(type, response);
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

  bool checkisShowBackground() {
    if (gifLink.isNotEmpty ||
        files.isNotEmpty ||
        content.length > 150 ||
        checkin != null ||
        previewUrlData != null ||
        poll != null) {
      return false;
    } else {
      return true;
    }
  }

  bool checkHasContent() {
    if (gifLink.isNotEmpty ||
        files.isNotEmpty ||
        content.isNotEmpty ||
        checkin != null ||
        previewUrlData != null ||
        poll != null) {
      return true;
    } else {
      return false;
    }
  }

  handleChooseMenu(menu, subType) {
    if (menu == null) return;

    if (menu['key'] == 'media') {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => GalleryView(
                  isMutipleFile: true,
                  handleGetFiles: handleUpdateData,
                  filesSelected: files)));
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
      case 'live-video':
        break;
      case 'bg-color':
        break;
      case 'camera':
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
              Navigator.of(context).pop();
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
      case 'poll':
        body = PollBody(
            type: subType, poll: poll, handleUpdateData: handleUpdateData);
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

  checkSaveDraft() {
    if (checkHasContent()) {
      return showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: buildTextContent(
                  "Lưu bài viết này dưới dạng bản nháp ?", false,
                  fontSize: 18, isCenterLeft: false),
              content: buildTextContent(
                  "Nếu bỏ bây giờ, bạn sẽ mất bài viết này.", false,
                  fontSize: 14, isCenterLeft: false),
              actions: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(children: [
                    CupertinoButton(
                        child: buildTextContent("Lưu bản nháp", false,
                            fontSize: 13, isCenterLeft: false),
                        onPressed: () {
                          ref.read(draftFeedController.notifier).saveDraftFeed(
                              DraftFeed(
                                  gifLink: gifLink,
                                  files: files,
                                  content: content,
                                  checkin: checkin,
                                  previewUrlData: previewUrlData,
                                  poll: poll));
                          popToPreviousScreen(context);
                          popToPreviousScreen(context);
                        }),
                    buildDivider(color: greyColor),
                    CupertinoButton(
                        child: buildTextContent("Bỏ bài viết", false,
                            fontSize: 13, colorWord: red, isCenterLeft: false),
                        onPressed: () {
                          ref
                              .read(draftFeedController.notifier)
                              .saveDraftFeed(DraftFeed(
                                gifLink: "",
                                files: [],
                                content: "",
                                checkin: null,
                                previewUrlData: null,
                              ));
                          popToPreviousScreen(context);
                          popToPreviousScreen(context);
                        }),
                    buildDivider(color: greyColor),
                    CupertinoButton(
                        child: buildTextContent("Tiếp tục chỉnh sửa", false,
                            fontSize: 13, isCenterLeft: false),
                        onPressed: () {
                          popToPreviousScreen(context);
                        }),
                    buildDivider(color: greyColor),
                    CupertinoButton(
                        child: const Text("Hủy"),
                        onPressed: () {
                          popToPreviousScreen(context);
                        }),
                  ]),
                )
              ],
            );
          });
    } else {
      popToPreviousScreen(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return WillPopScope(
      onWillPop: () async {
        return checkSaveDraft();
      },
      child: LoaderOverlay(
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
                      GestureDetector(
                        onTap: () {
                          // ignore: void_checks
                          return checkSaveDraft();
                        },
                        child: Icon(
                          FontAwesomeIcons.chevronLeft,
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                        ),
                      ),
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
                body: _isShow
                    ? CustomDraggableBottomSheet(
                        previewWidget: _menuOptions(),
                        backgroundWidget: mainBody(),
                        expandedWidget: _menuOptions(),
                        onDragging: (pos) {},
                        maxExtent: MediaQuery.of(context).size.height * 0.8,
                        minExtent: height / 2,
                        useSafeArea: false,
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 300),
                        onClose: () {
                          setState(() {
                            _isShow = false;
                          });
                        })
                    : Stack(
                        children: [
                          mainBody(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [const SizedBox(), getBottomSheet()],
                          )
                        ],
                      )),
          )),
    );
  }

  Widget mainBody() {
    final size = MediaQuery.of(context).size;
    return Container(
      // decoration: getDecoration(Theme.of(context).scaffoldBackgroundColor),
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
                backgroundSelected: files.isNotEmpty || checkin != null
                    ? null
                    : backgroundSelected,
                handleUpdateData: handleUpdateData,
                handleGetPreviewUrl: handleGetPreviewUrl),
            previewUrlData != null
                ? PreviewUrlPost(
                    detailData: previewUrlData,
                    resetPreview: handleResetPreviewUrl,
                    deleteImagePreview: handleHidePreviewUrl,
                    showImage: showPreviewImage,
                  )
                : const SizedBox(),
            Column(
              children: [
                files.isNotEmpty
                    ? GridLayoutImage(medias: files, handlePress: (media) {})
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
                poll != null
                    ? PostPoll(
                        pollData: poll,
                        functionClose: () {
                          setState(() {
                            poll = null;
                          });
                        },
                        functionAdditional: () {
                          pushCustomCupertinoPageRoute(
                              context,
                              CreateModalBaseMenu(
                                  title: "Thăm dò ý kiến",
                                  body: PollBody(
                                      handleUpdateData: handleUpdateData,
                                      poll: poll,
                                      type: widget.type!),
                                  buttonAppbar: const SizedBox()));
                        },
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
                  Container(
                      margin: EdgeInsets.only(
                          top: statusQuestion != null ? 20 : 10,
                          right: statusQuestion != null ? 20 : 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            files = [];
                            gifLink = '';
                            statusQuestion = null;
                            checkin = null;
                            lifeEvent = null;
                            menuSelected = null;
                          });
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black.withOpacity(0.5)),
                          child: const Icon(
                            FontAwesomeIcons.xmark,
                            color: white,
                            size: 20,
                          ),
                        ),
                      )),
                if (files.isNotEmpty)
                  Container(
                      margin: const EdgeInsets.only(
                        top: 2,
                        left: 10,
                      ),
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
            Container(
              height: 80,
              color: transparent,
            )
          ],
        ),
      ),
    );
  }

  Widget getBottomSheet() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //choose colors
              !checkisShowBackground() && previewUrlData != null
                  ? const SizedBox(
                      height: 25,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isActiveBackground = !isActiveBackground;
                            });
                          },
                          child: isActiveBackground
                              ? const Padding(
                                  padding: EdgeInsets.only(left: 7),
                                  child: WrapBackground(
                                    widgetChild: Icon(
                                        FontAwesomeIcons.chevronLeft,
                                        color: greyColor,
                                        size: 20),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Image.asset(
                                    "assets/post_background.png",
                                    width: 28,
                                  ),
                                ),
                        ),
                        isActiveBackground
                            ? SizedBox(
                                width: width - 75,
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          handleUpdateData(
                                              'update_background', null);
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          width: 27,
                                          height: 27,
                                          decoration: BoxDecoration(
                                              color: white,
                                              border: Border.all(
                                                  width: 0.4, color: greyColor),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                            backgroundPost
                                                .sublist(0, 15)
                                                .length,
                                            (index) => BackgroundItem(
                                                  updateBackgroundSelected:
                                                      (background) {
                                                    handleUpdateData(
                                                        'update_background',
                                                        background);
                                                  },
                                                  backgroundSelected:
                                                      backgroundSelected,
                                                  background:
                                                      backgroundPost[index],
                                                )),
                                      ),
                                    ],
                                  ),
                                ))
                            : const SizedBox(),
                        isActiveBackground
                            ? Padding(
                                padding: const EdgeInsets.only(right: 7),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isActiveBackground = false;
                                    });
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        barrierColor: Colors.transparent,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(10))),
                                        builder: (BuildContext context) {
                                          return PostBackground(
                                            backgroundSelected:
                                                backgroundSelected,
                                            updateBackgroundSelected:
                                                (background) {
                                              handleUpdateData(
                                                  'update_background',
                                                  background);
                                            },
                                          );
                                        });
                                  },
                                  child: const WrapBackground(
                                    widgetChild: Icon(
                                      FontAwesomeIcons.box,
                                      size: 20,
                                      color: greyColor,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
            ],
          ),
        ),
        // zoom in options
        Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration:
                getDecoration(Theme.of(context).scaffoldBackgroundColor),
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
                              setState(() {
                                _isShow = false;
                              });
                              Future.delayed(
                                  const Duration(milliseconds: 50),
                                  () => setState(() {
                                        _isShow = true;
                                      }));
                            }
                          },
                          child: index != 4
                              ? listMenuPost[index]['image'] != null
                                  ? IconButton(
                                      onPressed: (menuSelected?['disabled'] ??
                                                  [])
                                              ?.contains('media')
                                          ? null
                                          : () {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          GalleryView(
                                                            typePage:
                                                                'page_edit',
                                                            isMutipleFile: true,
                                                            handleGetFiles:
                                                                handleUpdateData,
                                                            filesSelected:
                                                                files,
                                                          )));
                                            },
                                      icon: listMenuPost[index]['image']
                                              .endsWith(".svg")
                                          ? SvgPicture.asset(
                                              listMenuPost[index]['image'],
                                              height: 28,
                                              width: 28,
                                              fit: BoxFit.scaleDown,
                                              color:
                                                  (menuSelected?['disabled'] ??
                                                              [])
                                                          ?.contains('media')
                                                      ? greyColor
                                                      : null,
                                            )
                                          : Image.asset(
                                              listMenuPost[index]['image'],
                                              height: 28,
                                              width: 28,
                                              fit: BoxFit.scaleDown,
                                              color:
                                                  (menuSelected?['disabled'] ??
                                                              [])
                                                          ?.contains('media')
                                                      ? greyColor
                                                      : null,
                                            ),
                                    )
                                  : GestureDetector(
                                      onTap: (menuSelected?['disabled'] ?? [])
                                              ?.contains(
                                                  listMenuPost[index]['key'])
                                          ? null
                                          : () {
                                              handleChooseMenu(
                                                  listMenuPost[index],
                                                  'menu_out');
                                            },
                                      child: Icon(
                                        listMenuPost[index]['icon'],
                                        color: (menuSelected?['disabled'] ?? [])
                                                ?.contains(
                                                    listMenuPost[index]['key'])
                                            ? greyColor
                                            : Color(
                                                listMenuPost[index]['color']),
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
                    )))
      ],
    );
  }

  BoxDecoration getDecoration(Color color) {
    return BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        color: color);
  }

  Widget _menuOptions() {
    List<dynamic> menuDisabled = menuSelected?['disabled'] ?? [];
    return Container(
      decoration: getDecoration(Theme.of(context).scaffoldBackgroundColor),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              controller: menuController,
              physics: const NeverScrollableScrollPhysics(),
              //  MediaQuery.of(context).size.height * 0.8 > 550
              //     ? const NeverScrollableScrollPhysics()
              //     : const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: listMenuPost.length,
              itemBuilder: (context, index) {
                bool isDisabled =
                    menuDisabled.contains(listMenuPost[index]['key']);
                return InkWell(
                  onTap: isDisabled
                      ? null
                      : () {
                          handleChooseMenu(listMenuPost[index], 'menu_in');
                        },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        listMenuPost[index]['image'] != null
                            ? Container(
                                // padding: const EdgeInsets.only(left: 10),
                                child: listMenuPost[index]['image']
                                        .endsWith(".svg")
                                    ? SvgPicture.asset(
                                        listMenuPost[index]['image'],
                                        width: 20,
                                        color: isDisabled ? greyColor : null,
                                      )
                                    : Image.asset(
                                        listMenuPost[index]['image'],
                                        height: 20,
                                        width: 20,
                                        color: isDisabled ? greyColor : null,
                                      ),
                              )
                            : const SizedBox(),
                        listMenuPost[index]['icon'] != null
                            ? Icon(
                                listMenuPost[index]['icon'],
                                color: isDisabled
                                    ? greyColor
                                    : Color(listMenuPost[index]['color']),
                                size: 20,
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          listMenuPost[index]['label'],
                          style: TextStyle(
                              fontSize: 16,
                              color: isDisabled ? greyColor : null),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          buildDragIcon()
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PreviewUrlPost extends StatelessWidget {
  dynamic detailData;
  Function resetPreview;
  Function deleteImagePreview;
  final bool showImage;
  PreviewUrlPost(
      {required this.detailData,
      required this.resetPreview,
      required this.deleteImagePreview,
      required this.showImage,
      super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return CupertinoActionSheet(
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    onPressed: () {
                      resetPreview();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Gỡ liên kết',
                    ),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {
                      deleteImagePreview();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Gỡ hình thu nhỏ',
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
              );
            });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: size.width,
        child: Column(
          children: [
            showImage
                ? Image.network(
                    detailData["url"] ?? linkBannerDefault,
                    height: 200.0,
                    width: size.width,
                  )
                : const SizedBox(),
            Container(
              color: Colors.grey.withOpacity(0.2),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width - 80,
                        child: Text(
                          detailData["title"] != ""
                              ? detailData["title"]
                              : (detailData["link"].split("//"))[1]
                                  .split("/")
                                  .first
                                  .toString(),
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      SizedBox(
                        width: size.width - 80,
                        child: buildTextContent(
                            detailData['description'] ?? '', false,
                            colorWord: greyColor,
                            fontSize: 12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
