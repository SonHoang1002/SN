import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_network_app_mobile/apis/create_post_apis/preview_url_post_api.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/data/background_post.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/providers/posts/processing_post_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateNewFeed/create_feed_status.dart';
import 'package:social_network_app_mobile/screens/CreatePost/MenuBody/checkin.dart';
import 'package:social_network_app_mobile/screens/CreatePost/MenuBody/emoji_activity.dart';
import 'package:social_network_app_mobile/screens/CreatePost/MenuBody/friend_tag.dart';
import 'package:social_network_app_mobile/screens/CreatePost/MenuBody/gif.dart';
import 'package:social_network_app_mobile/screens/CreatePost/MenuBody/life_event_categories.dart';
import 'package:social_network_app_mobile/screens/CreatePost/MenuBody/poll_body.dart';
import 'package:social_network_app_mobile/screens/CreatePost/MenuBody/question_anwer.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screens/CreatePost/page_edit_media_upload.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/PostType/avatar_banner.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/PostType/post_course.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/PostType/post_poll.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/PostType/post_product.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/PostType/post_project.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/PostType/post_recruit.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/PostType/post_share_event.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/PostType/post_share_group.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/PostType/post_share_page.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/PostType/post_target.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/post_life_event.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/post_share.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/EditImage/edit_img_main.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/Map/map_widget_item.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/gallery/src/gallery_view.dart';
import 'package:social_network_app_mobile/widgets/Posts/drag_bottom_sheet.dart';
import 'package:social_network_app_mobile/widgets/Posts/drag_icon.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/grid_layout_image.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

import '../../../providers/create_feed/feed_draft_provider.dart';
import 'package:dio/src/multipart_file.dart';

const EDIT_POST = "edit_post";

class CreateNewFeed extends ConsumerStatefulWidget {
  final dynamic post;
  final String? type;
  final dynamic postDiscussion;
  final dynamic pageData;
  final Function? reloadFunction;
  const CreateNewFeed(
      {Key? key,
      this.post,
      this.type,
      this.postDiscussion,
      this.reloadFunction,
      this.pageData})
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
  bool showMap = true;

  bool _isShow = true;
  bool isActiveBackground = false;
  double height = 0;
  double width = 0;
  dynamic postDiscussion;
  dynamic previewUrlData;
  bool showPreviewImage = true;
  ScrollController menuController = ScrollController();
  bool isMenuMinExtent = true;

  GlobalKey _heightKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _isShow = false;
    }
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
        // if (widget.post['media_attachments'].isNotEmpty) {
        files = widget.post['media_attachments'];
        // .map((ele) {
        //     return ele['id'];
        //   }).toList();
        // }
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

  handleUpdateData(
    String type,
    dynamic data,
  ) {
    switch (type) {
      case 'update_visibility':
        setState(() {
          visibility = data;
          _isShow = false;
        });
        break;
      case 'update_content':
        setState(() {
          content = data;
          _isShow = false;
        });

        if (data.length > 150) {
          setState(() {
            backgroundSelected = null;
            _isShow = false;
          });
        }
        break;
      case 'update_friend':
        setState(() {
          friendSelected = data;
          _isShow = false;
        });
        break;
      case 'update_background':
        setState(() {
          backgroundSelected = data;
          _isShow = false;
        });
        break;
      case 'update_gif':
        setState(() {
          gifLink = data;
          _isShow = false;
        });
        break;
      case 'update_status_activity':
        setState(() {
          statusActivity = data;
          _isShow = false;
        });
        break;
      case 'update_status_question':
        setState(() {
          statusQuestion = data;
          _isShow = false;
        });
        break;
      case 'update_checkin':
        setState(() {
          checkin = data;
          _isShow = false;
        });
        break;
      case 'update_file':
        List listPath = [];
        List newFiles = [];

        for (var item in data) {
          if (!listPath.contains(item?['id'])) {
            newFiles.add(item);
            listPath.add(item?['id']);
          } else if (item['file'] != null) {
            if (item['file'].path != null &&
                (!listPath.contains(item['file']!.path))) {
              newFiles.add(item);
              listPath.add(item['file']!.path);
            }
          }
        }
        setState(() {
          files = newFiles;
          _isShow = false;
        });
        break;
      case 'update_file_description':
        setState(() {
          if (files.length == 1) {
            files = [data];
          } else {
            files = data;
          }
          _isShow = false;
        });

        break;
      case 'update_poll':
        setState(() {
          poll = data;
          _isShow = false;
        });
        break;
      case 'updateLifeEvent':
        setState(() {
          lifeEvent = data;
          _isShow = false;
        });
    }
  }

  handleEditOneImage() {
    pushToNextScreen(
        context,
        EditImageMain(
            imageData: files,
            index: 0,
            updateData: (String type, dynamic newData) async {
              handleUpdateData(type, newData);
            }));
  }

  Future<File> overrideImage(Uint8List data, String imagePath) async {
    // Tạo một thư mục tạm để lưu trữ ảnh ghi đè
    try {
      final tempDir = await getTemporaryDirectory();
      final tempImagePath = '${tempDir.path}/temp_image.png';

      // Ghi dữ liệu từ Uint8List vào file ảnh tạm
      final tempFile = File(tempImagePath);
      await tempFile.writeAsBytes(data);
      // Đọc ảnh gốc từ đường dẫn imagePath
      // final originalImageFile = File(imagePath);

      // Kiểm tra nếu ảnh gốc tồn tại
      // if (await originalImageFile.exists()) {
      //   // Ghi đè ảnh gốc bằng ảnh từ Uint8List
      //   await originalImageFile.writeAsBytes(await tempFile.readAsBytes());
      //   await tempFile.delete();
      return tempFile;
    } catch (e) {
      throw e.toString();
    }
  }

  handleUploadMedia(index, file) async {
    if (file['file'] != null) {
      var fileData;
      if (file['newUint8ListFile'] != null) {
        fileData =
            await overrideImage(file['newUint8ListFile'], file['file'].path);
      } else {
        fileData = file['file'];
      }
      String fileName = fileData!.path.split('/').last;
      FormData formData;
      dynamic response;
      if (file['type'] == 'image') {
        formData = FormData.fromMap({
          "description": file['description'] ?? '',
          "position": index + 1,
          "file":
              await MultipartFile.fromFile(fileData.path, filename: fileName),
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
    } else {
      return file;
    }
  }

  dynamic _createFakeData() {
    dynamic meData = ref.watch(meControllerProvider)[0];
    dynamic _fakeData = {
      "created_at": "${DateTime.now()}+07:00",
      "backdated_time": "${DateTime.now()}+07:00",
      "processing": "isProcessing",
      "account": {
        "id": meData['id'],
        "username": meData['username'],
        "display_name": meData['display_name'],
        "avatar_static": meData['avatar_static'],
        "gender": meData['gender'],
        "earn_money": meData['earn_money'],
        "certified": meData['certified'],
        "avatar_media": meData['avatar_media'],
        "banner": meData['banner'],
      },
    };
    if (widget.pageData != null) {
      _fakeData['page'] = {
        "id": widget.pageData['id'],
        'title': widget.pageData['title'],
        'username': widget.pageData['username'],
        'avatar_media': widget.pageData['avatar_media'],
        'location': widget.pageData['location'],
        'follow_count': widget.pageData['follow_count'],
        'rating_product_count': widget.pageData['rating_product_count'] ?? 0,
        'page_relationship': widget.pageData['page_relationship'],
        'page_categories': widget.pageData['page_categories'],
        'banner': widget.pageData['banner'],
      };
      _fakeData['page_owner'] = _fakeData['page'];
    }

    if (files.isNotEmpty) {
      _fakeData['media_attachments'] = files;
    }
    if (checkin != null) {
      _fakeData['place'] = checkin;
    }
    if (statusActivity != null) {
      _fakeData['status_activity'] = statusActivity;
    }
    if (content != null) {
      _fakeData['content'] = content;
    }
    if (gifLink != null && gifLink != "") {
      _fakeData['card']['link'] = gifLink;
    }
    if (backgroundSelected != null) {
      _fakeData['status_background'] = backgroundSelected;
    }
    if (visibility != null) {
      _fakeData['visibility'] = visibility['key'];
    }
    if (lifeEvent != null) {
      _fakeData['life_event'] = lifeEvent;
    }
    if (poll != null) {
      _fakeData['poll'] = poll;
    }
    return _fakeData;
  }

  handleCreatePost() async {
    double processingPostHeight = _heightKey.currentContext!.size!.height;
    ref
        .read(processingPostController.notifier)
        .setPostionPost(processingPostHeight);
    String? type = widget.type ?? feedPost;
    if (type == postPage) {
      ref
          .read(pageControllerProvider.notifier)
          .createPostFeedPage(_createFakeData());
      widget.reloadFunction != null ? widget.reloadFunction!(null, null) : null;
    } else if (type == postLearnSpace) {
      ref
          .read(learnSpaceStateControllerProvider.notifier)
          .createPostLearnSpace(type, _createFakeData());
      widget.reloadFunction != null ? widget.reloadFunction!(null, null) : null;
    } else {
      ref
          .read(postControllerProvider.notifier)
          .createUpdatePost(type, _createFakeData());
      widget.reloadFunction != null ? widget.reloadFunction!(null, null) : null;
    }

    Navigator.pop(context);
    // prepare data for api
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
    if (widget.pageData != null) {
      data['page_id'] = widget.pageData['id'];
      data['page_owner_id'] = widget.pageData['id'];
    }
    var response = await PostApi().createStatus(data);
    if (response != null) {
      if (isUploadVideo) {
        setState(() {
          isUploadVideo = false;
        });
      } else {
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   ref
        //       .read(postControllerProvider.notifier)
        //       .createUpdatePost(type, response);
        // });
        widget.reloadFunction != null
            ? widget.reloadFunction!(type, response)
            : null;
      }
    }
  }

  handleUpdatePost() async {
    context.loaderOverlay.show();
// Trong đó: backdated_time: khi edit date sẽ lưu dữ liệu vào trường này và dùng trường này để sắp xếp thứ tự status
//           off_comment: tắt bật tính năng bình luận bài viết
//           comment_moderation: Bao gồm các giá trị public, friend, tag mặc định là public
//           Nếu để friend thì chỉ có bạn bè mới đc comment, tag thì chỉ có người đc tag mới
//           được comment. Chỉ có bài post trong trang cá nhân mới cập đc đc field này. Trường hợp bài
//           viết trong page thì không có giá trị friend mà thay vào là follow, khi ở chế độ follow
//           thì chỉ những người follow page trước 24h mới đc comment
//           hidden : tắt bật tính năng ẩn hiện bài viết
    dynamic newData = {
      "id": widget.post['id'],
      "media_ids": [],
      "sensitive": false,
      "visibility": null,
      "extra_body": {},
      "place_id": null,
      "mention_ids": null,
      "post_type": null,
      "status_question": {
        "content": "Hãy viết câu hỏi của bạn...",
        "color": {}
      },
      'comment_moderation': 'public',
      "tags": [],
      "status": content,
      "scheduled_at": null,
      'hidden': null,
      'status_background_id': widget.post['status_background']?['id'] ?? null
    };
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
      newData['media_ids'] = mediasId;
    }
    if (widget.post['visibility'] != visibility['key']) {
      newData['visibility'] = visibility['key'];
    }
    // if (backgroundSelected != null &&
    //     widget.post['status_background']?['id'] != backgroundSelected['id']) {
    //   if (files.isNotEmpty ||
    //       checkin == null ||
    //       poll == null ||
    //       lifeEvent == null ||
    //       widget.post['shared_event'] == null ||
    //       widget.post['shared_recruit'] == null ||
    //       widget.post['shared_project'] == null ||
    //       widget.post['shared_course'] == null ||
    //       widget.post['shared_product'] == null ||
    //       widget.post['shared_page'] == null ||
    //       widget.post['shared_group'] == null) {
    //     newData['status_background_id'] = backgroundSelected['id'];
    //   }
    // } else {}
    newData['status_background_id'] =
        backgroundSelected != null ? backgroundSelected['id'] : null;

    if (gifLink.isNotEmpty) {
      newData["extra_body"] = {"description": "", "link": gifLink, "title": ""};
    }

    if (statusActivity != null &&
        widget.post['status_activity']?['id'] != statusActivity['id']) {
      newData = {...newData, 'status_activity_id': statusActivity['id']};
    }
    dynamic response = await PostApi().updatePost(widget.post['id'], newData);
    if(widget.type == postPage){
      ref
        .read(pageControllerProvider.notifier)
        .actionUpdateDetailInPost(widget.type, response);
    }else if(widget.type ==postLearnSpace){
      ref
        .read(learnSpaceStateControllerProvider.notifier)
        .actionUpdateDetailInPost(widget.type, response);
    }else{
      ref
        .read(postControllerProvider.notifier)
        .actionUpdateDetailInPost(widget.type, response);
    }

    if (response != null && mounted) {
      context.loaderOverlay.hide();
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cập nhật thành công")));
    }
  }

  checkVisiblePress() {
    if (gifLink.isNotEmpty ||
        files.isNotEmpty ||
        content.trim().isNotEmpty ||
        checkin != null ||
        previewUrlData != null ||
        poll != null ||
        statusQuestion != null) {
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
        poll != null ||
        statusQuestion != null) {
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
                  type: widget.post != null &&
                          widget.post['media_attachments'].isNotEmpty
                      ? "edit_post"
                      : null,
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
      if (widget.post == null) {
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
                    height: 195,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(children: [
                      CupertinoButton(
                          child: buildTextContent("Lưu bản nháp", false,
                              fontSize: 13, isCenterLeft: false),
                          onPressed: () {
                            ref
                                .read(draftFeedController.notifier)
                                .saveDraftFeed(DraftFeed(
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
                              fontSize: 13,
                              colorWord: red,
                              isCenterLeft: false),
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
                          child: buildTextContent("Hủy", false,
                              fontSize: 13, isCenterLeft: false),
                          onPressed: () {
                            popToPreviousScreen(context);
                          }),
                    ]),
                  )
                ],
              );
            });
      } else {
        return showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: buildTextContent("Bỏ thay đổi?", false,
                    fontSize: 18, isCenterLeft: false),
                content: buildTextContent(
                    "Nếu bạn hủy bây giờ, thay đổi của bạn sẽ bị hủy bỏ", false,
                    fontSize: 14, isCenterLeft: false),
                actions: [
                  Container(
                    height: 97,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(children: [
                      CupertinoButton(
                          child: buildTextContent("Bỏ", false,
                              fontSize: 13,
                              isCenterLeft: false,
                              colorWord: red),
                          onPressed: () {
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
                    ]),
                  )
                ],
              );
            });
      }
    } else {
      popToPreviousScreen(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget.type  ${widget.type}");
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
      key: _heightKey,
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
                handleGetPreviewUrl: handleGetPreviewUrl,
                pageData: widget.pageData),
            previewUrlData != null
                ? PreviewUrlPost(
                    detailData: previewUrlData,
                    resetPreview: handleResetPreviewUrl,
                    deleteImagePreview: handleHidePreviewUrl,
                    showImage: showPreviewImage,
                  )
                : const SizedBox(),
            Stack(
              children: [
                Column(
                  children: [
                    files.isNotEmpty
                        ? GridLayoutImage(
                            post: widget.post,
                            medias: files,
                            handlePress: (media) {
                              if (files.length > 1) {
                                pushCustomCupertinoPageRoute(
                                    context,
                                    PageEditMediaUpload(
                                        post: widget.post,
                                        files: files,
                                        handleUpdateData: handleUpdateData));
                              }
                            })
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
                    checkin != null &&
                            (files.isEmpty &&
                                gifLink == "" &&
                                poll == null &&
                                statusQuestion == null &&
                                lifeEvent == null) &&
                            showMap
                        ? MapWidgetItem(checkin: checkin)
                        : const SizedBox(),
                    lifeEvent != null
                        ? PostLifeEvent(
                            post: {'life_event': lifeEvent},
                          )
                        : const SizedBox(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    files.length == 1 && widget.post == null
                        ? Container(
                            margin: const EdgeInsets.only(
                              top: 2,
                              left: 10,
                            ),
                            child: SizedBox(
                              child: ButtonPrimary(
                                isPrimary: true,
                                label: "Chỉnh sửa",
                                handlePress: handleEditOneImage,
                                colorButton: blackColor,
                                fontSize: 12,
                                icon: Image.asset(
                                  "assets/icons/edit_create_feed_icon.png",
                                  height: 12,
                                  width: 12,
                                ),
                              ),
                            ))
                        : const SizedBox(),
                    if ((gifLink.isNotEmpty ||
                        files.isNotEmpty ||
                        statusQuestion != null ||
                        (checkin != null && showMap)))
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
                                lifeEvent = null;
                                menuSelected = null;
                                showMap = false;
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
                  ],
                )
              ],
            ),

            widget.post != null && widget.post?['shared_course'] != null
                ? PostCourse(
                    post: widget.post,
                    type: EDIT_POST,
                  )
                : const SizedBox(),
            widget.post != null && widget.post?['shared_project'] != null
                ? PostProject(
                    post: widget.post,
                    type: EDIT_POST,
                  )
                : const SizedBox(),
            widget.post != null && widget.post?['shared_recruit'] != null
                ? PostRecruit(
                    post: widget.post,
                    type: EDIT_POST,
                  )
                : const SizedBox(),
            widget.post != null && widget.post['shared_group'] != null
                ? PostShareGroup(
                    post: widget.post,
                    type: EDIT_POST,
                  )
                : const SizedBox(),
            widget.post != null && widget.post['shared_page'] != null
                ? PostSharePage(
                    post: widget.post,
                    type: EDIT_POST,
                  )
                : const SizedBox(),
            widget.post != null && widget.post['reblog'] != null
                ? PostShare(
                    post: widget.post,
                    type: EDIT_POST,
                  )
                : const SizedBox(),
            // add navi to product when have market place
            widget.post != null && widget.post?['shared_product'] != null
                ? PostProduct(
                    post: widget.post,
                    type: EDIT_POST,
                  )
                : const SizedBox(),
            widget.post != null && widget.post?['shared_event'] != null
                ? PostShareEvent(
                    post: widget.post,
                    type: EDIT_POST,
                  )
                : const SizedBox(),
            widget.post != null && widget.post['post_type'] != null
                ? ([postAvatarAccount, postBannerAccount]
                        .contains(widget.post['post_type'])
                    ? AvatarBanner(
                        postType: widget.post['post_type'], post: widget.post)
                    : [postTarget, postVisibleQuestion]
                            .contains(widget.post['post_type'])
                        ? PostTarget(
                            post: widget.post,
                            type:
                                widget.post['post_type'] == postVisibleQuestion
                                    ? postQuestionAnwer
                                    : postTarget,
                            statusQuestion: widget.post['status_question'],
                          )
                        : const SizedBox())
                : const SizedBox(),
            Container(
              height: 80,
              color: transparent,
            )
          ],
        ),
      ),
    );
  }

  // color
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
                                    showCustomBottomSheet(
                                        context, 500, "Chọn màu nền",
                                        isHaveCloseButton: false,
                                        widget: PostBackground(
                                          backgroundSelected:
                                              backgroundSelected,
                                          updateBackgroundSelected:
                                              (background) {
                                            handleUpdateData(
                                                'update_background',
                                                background);
                                          },
                                        ));
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
            height: 60 + 30,
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
                    fit: BoxFit.cover,
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
