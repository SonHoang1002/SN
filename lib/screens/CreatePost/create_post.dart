import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/disable_moment_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateNewFeed/create_new_feed.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

import 'CreateMoment/camera_moment_controller.dart';

class CreatePost extends ConsumerStatefulWidget {
  final Function? callbackFunction;
  const CreatePost({Key? key, this.callbackFunction}) : super(key: key);

  @override
  ConsumerState<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost> {
  List postTypeCreate = [
    {"key": "post", "icon": "assets/story.svg", "title": "Post"},
    {"key": "moment", "image": "assets/MomentMenu.png", "title": "Khoảnh khắc"},
    {"key": "live", "icon": "assets/Live.svg", "title": "Phát trực tiếp"}
  ];

  // static const String LICENSE_TOKEN = tokenBanuba;

  // static const channelName = 'startActivity/VideoEditorChannel';

  // static const methodInitVideoEditor = 'InitBanubaVideoEditor';
  // static const methodStartVideoEditor = 'StartBanubaVideoEditor';
  // static const methodDemoPlayExportedVideo = 'PlayExportedVideo';

  // static const errEditorNotInitializedCode = 'ERR_VIDEO_EDITOR_NOT_INITIALIZED';
  // static const errEditorNotInitializedMessage =
  //     'Banuba Video Editor SDK is not initialized: license token is unknown or incorrect.\nPlease check your license token or contact Banuba';
  // static const errEditorLicenseRevokedCode = 'ERR_VIDEO_EDITOR_LICENSE_REVOKED';
  // static const errEditorLicenseRevokedMessage =
  //     'License is revoked or expired. Please contact Banuba https://www.banuba.com/faq/kb-tickets/new';

  // static const argExportedVideoFile = 'exportedVideoFilePath';
  // static const argExportedVideoCoverPreviewPath =
  //     'exportedVideoCoverPreviewPath';

  // static const platform = MethodChannel(channelName);

  // String _errorMessage = '';

  // Future<void> _initVideoEditor() async {
  //   await platform.invokeMethod(methodInitVideoEditor, LICENSE_TOKEN);
  // }

  // Future<void> _startVideoEditorDefault() async {
  //   try {
  //     await _initVideoEditor();

  //     final result = await platform.invokeMethod(methodStartVideoEditor);

  //     _handleExportResult(result);
  //   } on PlatformException catch (e) {
  //     _handlePlatformException(e);
  //   }
  // }

  // void _handleExportResult(dynamic result) {
  //   debugPrint('Export result = $result');

  //   // You can use any kind of export result passed from platform.
  //   // Map is used for this sample to demonstrate playing exported video file.
  //   if (result is Map) {
  //     final exportedVideoFilePath = result[argExportedVideoFile];

  //     // Use video cover preview to meet your requirements
  //     final exportedVideoCoverPreviewPath =
  //         result[argExportedVideoCoverPreviewPath];

  //     // _showConfirmation(context, "Play exported video file?", () {
  //     //   platform.invokeMethod(
  //     //       methodDemoPlayExportedVideo, exportedVideoFilePath);
  //     // });
  //     if (exportedVideoCoverPreviewPath != null &&
  //         exportedVideoFilePath != null &&
  //         mounted) {
  //       Navigator.push(
  //           context,
  //           CupertinoPageRoute(
  //               builder: (context) => CreateMoment(
  //                   imageCover: exportedVideoCoverPreviewPath,
  //                   videoPath: exportedVideoFilePath)));
  //     }
  //   }
  // }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                              popToPreviousScreen(context);
                              if (['moment', "live"].contains(key)) {
                                /// moment
                                // _startVideoEditorDefault();
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const CameraMomentController()));
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  ref
                                      .read(disableMomentController.notifier)
                                      .setDisableMoment(false);
                                });
                              } else {
                                pushCustomCupertinoPageRoute(
                                    context,
                                    CreateNewFeed(
                                      beforeHasVideo: true,
                                      reloadFunction: (type, newData) {
                                        widget.callbackFunction != null
                                            ? widget.callbackFunction!(
                                                type, newData)
                                            : null;
                                      },
                                    ));
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  ref
                                      .read(disableMomentController.notifier)
                                      .setDisableMoment(true);
                                });
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

  // // Handle exceptions thrown on Android, iOS platform while opening Video Editor SDK
  // void _handlePlatformException(PlatformException exception) {
  //   debugPrint("Error: '${exception.message}'.");

  //   String errorMessage = '';
  //   switch (exception.code) {
  //     case errEditorLicenseRevokedCode:
  //       errorMessage = errEditorLicenseRevokedMessage;
  //       break;
  //     case errEditorNotInitializedCode:
  //       errorMessage = errEditorNotInitializedMessage;
  //       break;
  //     default:
  //       errorMessage = 'unknown error';
  //   }

  //   _errorMessage = errorMessage;
  //   setState(() {});
  // }
}
