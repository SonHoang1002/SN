import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateMoment/create_moment.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_new_feed.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  static const String LICENSE_TOKEN =
      "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";

  static const channelName = 'startActivity/VideoEditorChannel';

  static const methodInitVideoEditor = 'InitBanubaVideoEditor';
  static const methodStartVideoEditor = 'StartBanubaVideoEditor';
  static const methodDemoPlayExportedVideo = 'PlayExportedVideo';

  static const errEditorNotInitializedCode = 'ERR_VIDEO_EDITOR_NOT_INITIALIZED';
  static const errEditorNotInitializedMessage =
      'Banuba Video Editor SDK is not initialized: license token is unknown or incorrect.\nPlease check your license token or contact Banuba';
  static const errEditorLicenseRevokedCode = 'ERR_VIDEO_EDITOR_LICENSE_REVOKED';
  static const errEditorLicenseRevokedMessage =
      'License is revoked or expired. Please contact Banuba https://www.banuba.com/faq/kb-tickets/new';

  static const argExportedVideoFile = 'exportedVideoFilePath';
  static const argExportedVideoCoverPreviewPath =
      'exportedVideoCoverPreviewPath';

  static const platform = MethodChannel(channelName);

  String _errorMessage = '';

  Future<void> _initVideoEditor() async {
    await platform.invokeMethod(methodInitVideoEditor, LICENSE_TOKEN);
  }

  Future<void> _startVideoEditorDefault() async {
    try {
      await _initVideoEditor();

      final result = await platform.invokeMethod(methodStartVideoEditor);

      _handleExportResult(result);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  void _handleExportResult(dynamic result) {
    debugPrint('Export result = $result');

    // You can use any kind of export result passed from platform.
    // Map is used for this sample to demonstrate playing exported video file.
    if (result is Map) {
      final exportedVideoFilePath = result[argExportedVideoFile];

      // Use video cover preview to meet your requirements
      final exportedVideoCoverPreviewPath =
          result[argExportedVideoCoverPreviewPath];

      // _showConfirmation(context, "Play exported video file?", () {
      //   platform.invokeMethod(
      //       methodDemoPlayExportedVideo, exportedVideoFilePath);
      // });
      print('response, $exportedVideoCoverPreviewPath');
      print('response, $exportedVideoFilePath');
      if (exportedVideoCoverPreviewPath != null &&
          exportedVideoFilePath != null) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => CreateMoment(
                    imageCover: exportedVideoCoverPreviewPath,
                    videoPath: exportedVideoFilePath)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List postTypeCreate = [
      {"key": "post", "icon": "assets/story.svg", "title": "Post"},
      {
        "key": "moment",
        "image": "assets/MomentMenu.png",
        "title": "Khoảnh khắc"
      },
      {"key": "live", "icon": "assets/Live.svg", "title": "Phát trực tiếp"}
    ];

    return Container(
        margin: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppBarTitle(title: "Tạo bài viết"),
              const SizedBox(
                height: 12,
              ),
              const Text(
                  "Bạn muốn tạo bài viết gì? Hãy chọn loại bài viết muốn tạo."),
              const SizedBox(
                height: 12,
              ),
              Column(
                  children: List.generate(
                      postTypeCreate.length,
                      (index) => GestureDetector(
                            onTap: () {
                              String key = postTypeCreate[index]['key'];
                              if (key == 'moment') {
                                _startVideoEditorDefault();
                              } else {
                                Navigator.push(context,
                                    CupertinoPageRoute(builder: ((context) {
                                  return key == 'post'
                                      ? const CreateNewFeed()
                                      : const SizedBox();
                                })));
                              }
                            },
                            child: Container(
                              height: 60,
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 0.2, color: greyColor)),
                              child: Row(
                                children: [
                                  if (postTypeCreate[index]?['icon'] != null)
                                    SvgPicture.asset(
                                        postTypeCreate[index]['icon']),
                                  if (postTypeCreate[index]?['image'] != null)
                                    Image.asset(
                                      postTypeCreate[index]?['image'],
                                      width: 31,
                                      height: 31,
                                    ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    postTypeCreate[index]['title'],
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          )))
            ],
          ),
        ));
  }

  // Handle exceptions thrown on Android, iOS platform while opening Video Editor SDK
  void _handlePlatformException(PlatformException exception) {
    debugPrint("Error: '${exception.message}'.");

    String errorMessage = '';
    switch (exception.code) {
      case errEditorLicenseRevokedCode:
        errorMessage = errEditorLicenseRevokedMessage;
        break;
      case errEditorNotInitializedCode:
        errorMessage = errEditorNotInitializedMessage;
        break;
      default:
        errorMessage = 'unknown error';
    }

    _errorMessage = errorMessage;
    setState(() {});
  }
}
