import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateMoment/create_moment.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateNewFeed/create_new_feed.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  static const String LICENSE_TOKEN =
      "X4rJTe9UUMvVmF6pYs0grzRKfEC8pkAjGbiOTzWJ/265iR2Bt0IyMX7GHayeHqInma8/JFrzNLUKAnW0QijPG41nwZrcb+OpF9spaODem3MF1qo8R32yiiPuhhzYhrPmQgbuKZButI8U3lCOAjcNQEi7wj9HTvhTjYmrmoHC6hd2a1AlWny4ZU2XfheTVL4sB4ppda8s5dPAaY+4nRWGO1Noc0/7Xab4Bw/Wizvd9F34DPh1mJvoMsNetpoPs3PtgCwgq+lgh72fhfoxt4mq/rl22BtLjVRFzOrsrYAZ0xkGYGzmp+4karFGvT+71KgoExaSTLH77nwRiarZNTDIdr1ZmIDAxUZDOCUAinLnjSs4PgwX1TH72QhIiPxrAkZzWZhF+APv2jml+o7PdkFZZ7Ar9LS8H/OjCgFttKFUdo9gtWoOhwKW3aXEbUxzUYewMCyN7LNIBtH2MpMFhVN2iJn2lGtXpoDg42QFcrZ+rQz7oG1hRGL5U2l6yp1f5gpDBzVeG5FKyHr/TPzu0zqbR/vPfR5mWw0Kc9JRHHn7SXHMNoiL9C7Umwv132bH32tlOJRKj0GitEeVXubQEgp48Fl1AupLQ/+fR2MFHI0jmrDxBVRnk8Q1DMxH6iyOLVoKIw/R97IYS3zEzb4swmAu85WQhJJq1lpXcaUSj/JO5oUMN0oieFonfxZIeWfPOm/RVOLbWOTy0/tIB44IPON7MqtkK6+6EPIutR17a/hXBn57v5nNWdjRWjhLhVd0x1V+V55qa5oO6Q6TZmfOncqlZjchmtZS8HTBqrOgELsaw61H1ZjL02ebvd2UJCSYicMRNcShDc0JEqecOyqBed14qA2G/x9Q8REmFXp2Fp1dk3h6fE1FJYZlnhO8yssuszM0B1HnCANKr+1WAaHKmC9XCQYv1L9Fokj6CAbaEhpa2QdLccgBFKNbJgVH5KD3dlO0qFhIpMya9K80itytoldrVSMS/HFFSdzC5+eK4EkdscxRwfKGlvdSVGDCldiL1748fiUwIh6mLjo6finHLr43HfEvx/Qq19F7+R0N6sY0vdo8wq+OnB84TcMYPwwvSaKkPu8GivrwqFyjg8qdZnxNYMx3pXBfhmvBhilAYl53zqxYcmHxsWUkhzge6yhjcVXTFup/cCQZEryB58uRiF28ZhgOTZmpghpBvkjkhPo2ywJCpFNRzXECs/aerTgSfN2eqYuKc6YMy3Nn2ImxudPmo9ZeXsKG7Qzdkce1Q6d9/balASFONxFiSkpJU++7pTkXGqtpq69ogYYoRqcgXVaaSeMTxa3vP6bPDUNQMtrGWAgE8qkgEKz3+g3yRSjSgz7ViiD3IciTlqyEa71ogSi4UvBOKONDE/ela6zeBtjDPnKugjmCS/CZM/KcO9im8dF516Fg3zRVndqg7T+/m517KJ5wU/HQO75pJRF5YnSXA8/5z3iIzMjTAP0nFtKDxEVzbtYYb5urbey6Ay+q7eCjRfOVKUzkugv897gTDW0BxbiEGA4jkmaQWxSjp985zSUvV63rOsjgpuC7LIdGy5jkoVQAkMyerPIdqw==";

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
                                popToPreviousScreen(context);
                                pushCustomCupertinoPageRoute(
                                    context,
                                    key == 'post'
                                        ? const CreateNewFeed()
                                        : const SizedBox());
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
