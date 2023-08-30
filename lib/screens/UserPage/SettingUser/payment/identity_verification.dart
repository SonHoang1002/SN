import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';
import 'package:social_network_app_mobile/widgets/video_player.dart';
import 'package:video_player/video_player.dart';

class IdentityVerification extends ConsumerStatefulWidget {
  const IdentityVerification({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IdentityVerificationState();
}

class _IdentityVerificationState extends ConsumerState<IdentityVerification> {
  late File imageFront;
  late File imageBack;
  late File video;
  String pathFront = '';
  String pathBack = '';
  bool isUploadVideo = false;
  List mediasId = [];
  bool alreadySend = false;
  Map<String, dynamic> request = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRequest();
  }

  void fetchRequest() async {
    var result = await UserPageApi().getVerifyUserRequest();
    if (result != null) {
      request = result;
    }

    setState(() {
      alreadySend = true;
    });
    _buildSnackBar(
        "Yêu cầu xác minh của bạn đang chờ xác thực, không thể gửi thêm");
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CupertinoActivityIndicator(),
      ),
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const AppBarTitle(title: 'Xác minh danh tính tài khoản'),
          ),
          body: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: SingleChildScrollView(
                  child: Column(children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ảnh CCCD (Mặt trước) · Bắt buộc*'),
                        TextButton(
                            onPressed: () {
                              openEditor("front");
                            },
                            child: const Text('Thêm')),
                      ],
                    ),
                    Container(
                      height: 200,
                      color: Colors.black,
                      child: Center(
                        child: pathFront != ''
                            ? Image.file(
                                imageFront,
                                height: 240.0,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/pages/banner.png',
                                width: 20,
                                height: 20,
                              ),
                      ),
                    ),
                    const Divider(
                      height: 30,
                      thickness: 1,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ảnh CCCD (Mặt sau) · Bắt buộc*'),
                        TextButton(
                            onPressed: () {
                              openEditor("back");
                            },
                            child: const Text('Thêm')),
                      ],
                    ),
                    Container(
                      height: 200,
                      color: Colors.black,
                      child: Center(
                        child: pathBack != ''
                            ? Image.file(
                                imageBack,
                                height: 240.0,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/pages/banner.png',
                                width: 20,
                                height: 20,
                              ),
                      ),
                    ),
                    const Divider(
                      height: 30,
                      thickness: 1,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                              'Video xác định danh tính (không quá 30 giây) · Bắt buộc*'),
                        ),
                        TextButton(
                            onPressed: () {
                              openVideoEditor();
                            },
                            child: const Text('Thêm')),
                      ],
                    ),
                    Container(
                      height: 200,
                      color: Colors.black,
                      child: Center(
                        child: isUploadVideo
                            ? VideoPlayerRender(
                                path: video.path,
                                // fit: BoxFit.fitHeight,
                              )
                            : Image.asset(
                                'assets/pages/banner.png',
                                width: 20,
                                height: 20,
                              ),
                      ),
                    ),
                    const Divider(
                      height: 30,
                      thickness: 1,
                    ),
                  ],
                ),
                ButtonPrimary(
                  isGrey: pathFront != '' &&
                          pathBack != '' &&
                          isUploadVideo == true &&
                          alreadySend == false
                      ? false
                      : true,
                  label: "Xác nhận",
                  handlePress: () {
                    pathFront != '' &&
                            pathBack != '' &&
                            isUploadVideo == true &&
                            alreadySend == false
                        ? handleSendRequest()
                        : null;
                    //handleSendRequest();
                  },
                ),
                const SizedBox(
                  height: 20,
                )
              ])))),
    );
  }

  void openEditor(type) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (type == 'front') {
          imageFront = File(pickedFile.path);
          pathFront = pickedFile.path;
        } else {
          imageBack = File(pickedFile.path);
          pathBack = pickedFile.path;
        }
      });
    }
  }

  void openVideoEditor() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      final controller = VideoPlayerController.file(File(pickedFile.path));
      await controller.initialize();

      if (controller.value.duration.inSeconds <= 30) {
        setState(() {
          video = File(pickedFile.path);
          isUploadVideo = true;
        });
      } else {
        // Video is too long
        controller.dispose();

        _buildSnackBar("Video của bạn quá dài, xin vui lòng gửi lại.");
      }
    }
  }

  handleSendRequest() async {
    context.loaderOverlay.show();
    List<Future> listUpload = [];
    listUpload.add(handleUploadMedia(0, imageFront, 'image'));
    listUpload.add(handleUploadMedia(1, imageBack, 'image'));
    listUpload.add(handleUploadMedia(2, video, 'video'));

    var results = await Future.wait(listUpload);
    if (results.isNotEmpty) {
      mediasId = results.map((e) => e['id']).toList();
    }
    FormData formData = FormData.fromMap({
      "identity_card_front[id]": mediasId[0],
      "identity_card_back[id]": mediasId[1],
      "identity_verification_video[id]": mediasId[2],
    });
    var res = await UserPageApi().verifyUserRequest(formData);
    if (mounted) {
      context.loaderOverlay.hide();
    }
    if (res != null) {
      _buildSnackBar(
          "Bạn đã gửi xác minh thành công, chúng tôi sẽ xem xét và sớm gửi thông báo đến bạn!");
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      _buildSnackBar("Gửi yêu cầu thất bại");
    }
  }

  Future<File> overrideImage(Uint8List data, String imagePath) async {
    // Tạo một thư mục tạm để lưu trữ ảnh ghi đè
    try {
      final tempDir = await getTemporaryDirectory();
      final tempImagePath = '${tempDir.path}/temp_image.png';

      // Ghi dữ liệu từ Uint8List vào file ảnh tạm
      final tempFile = File(tempImagePath);
      await tempFile.writeAsBytes(data);
      return tempFile;
    } catch (e) {
      throw e.toString();
    }
  }

  handleUploadMedia(index, file, type) async {
    var fileData;
    fileData = file;
    String fileName = fileData!.path.split('/').last;
    FormData formData;
    dynamic response;
    if (type == 'image') {
      formData = FormData.fromMap({
        /* "description": file['description'] ?? '', */
        "position": index + 1,
        "file": await MultipartFile.fromFile(fileData.path, filename: fileName),
      });
      response = await MediaApi().uploadMediaEmso(formData);
    } else {
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

  _buildSnackBar(String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(title),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9)))),
    );
  }
}
