import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_feed_menu.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_feed_status.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/checkin.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/emoji_activity.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/friend_tag.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/gif.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/life_event_categories.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/gallery_view.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

class CreateNewFeed extends ConsumerStatefulWidget {
  const CreateNewFeed({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateNewFeed> createState() => _CreateNewFeedState();
}

class _CreateNewFeedState extends ConsumerState<CreateNewFeed> {
  List friendSelected = [];
  List files = [];

  String content = '';
  String gifLink = '';

  dynamic menuSelected;
  dynamic visibility;
  dynamic backgroundSelected;
  dynamic statusActivity;
  dynamic statusQuestion;
  dynamic checkin;

  @override
  void initState() {
    super.initState();
    setState(() {
      visibility = typeVisibility[0];
    });
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

  handleGetFiles(file) async {
    if (file.isEmpty) {
      setState(() {
        files = [];
      });
    }

    List newFiles =
        file.map((element) => functionConvertFile(element)).toList();

    print('newFiles $newFiles');

    setState(() {
      files = newFiles;
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
    }
  }

  handlePress() {}

  handleCreateUpdatePost() async {
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

    var response = await PostApi().createStatus(data);

    if (response != null) {
      ref
          .read(postControllerProvider.notifier)
          .createUpdatePost(feedPost, response);
      if (context.mounted) {
        context.loaderOverlay.hide();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tạo bài viết thành công")));
      }
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
                  const AppBarTitle(title: "Tạo bài viết"),
                  ButtonPrimary(
                    label: "Đăng",
                    handlePress:
                        checkVisiblePress() ? handleCreateUpdatePost : null,
                  )
                ],
              ),
            ),
            bottomSheet: getBottomSheet(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CreateFeedStatus(
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
                          ? ClipRect(
                              child: Align(
                                alignment: Alignment.topCenter,
                                heightFactor:
                                    files[0].width / files[0].height < 0.4
                                        ? 0.6
                                        : 1,
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Image.memory(
                                      files[0].pickedThumbData,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Text(
                                              'Hình ảnh không được hiển thị'),
                                    )),
                              ),
                            )
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
                            ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  checkisShowBackground() {
    if (gifLink.isNotEmpty || files.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  handleChooseMenu(menu) {
    if (menu == null) return;

    if (menu['key'] == 'media') {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => Expanded(
                      child: GalleryView(
                    isMutipleFile: true,
                    handleGetFiles: handleGetFiles,
                    filesSelected: const [],
                  ))));
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
            statusActivity: statusActivity, handleUpdateData: handleUpdateData);
        break;
      case 'checkin':
        body = Checkin(checkin: checkin, handleUpdateData: handleUpdateData);
        break;
      case 'tag-people':
        body =
            FriendTag(handleUpdateSelectedFriend: handleUpdateSelectedFriend);
        buttonAppbar = const ButtonPrimary(label: "Xong");
        break;
      case 'gif':
        body = Gif(handleUpdateData: handleUpdateData);
        break;
      case 'life-event':
        body = const LifeEventCategories();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            BackIconAppbar(),
            AppBarTitle(title: "Tạo bài post"),
            ButtonPrimary(label: "Đăng")
          ],
        ),
      ),
      body: Column(
        children: [
          const CreateFeedStatus(),
          CreateFeedMenu(
            handleChooseMenu: handleChooseMenu,
          )
        ],
      ),
    );
  }
}
