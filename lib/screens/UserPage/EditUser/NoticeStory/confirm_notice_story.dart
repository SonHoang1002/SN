import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/screens/UserPage/EditUser/NoticeStory/pick_notice_cover_img.dart';
import 'dart:io';

import '../../../../apis/media_api.dart';
import '../../../../providers/UserPage/user_information_provider.dart';
import '../../../../providers/me_provider.dart';
import '../../../../theme/theme_manager.dart';
import '../../../../widgets/appbar_title.dart';
import '../../../../widgets/back_icon_appbar.dart';
import '../../../../widgets/button_primary.dart';

class ConfirmNoticeStory extends ConsumerStatefulWidget {
  final Map<String, String> chosenImages;
  final Map<int, File> chosenFileImages;
  final List images;
  final List mediaIds;
  const ConfirmNoticeStory({
    super.key,
    required this.chosenImages,
    required this.chosenFileImages,
    required this.images,
    required this.mediaIds,
  });

  @override
  ConfirmNoticeStoryState createState() => ConfirmNoticeStoryState();
}

class ConfirmNoticeStoryState extends ConsumerState<ConfirmNoticeStory> {
  dynamic bannerImage;
  String title = '';
  bool isLoading = false;

  TextStyle buildBoldTxt(ThemeManager theme) {
    return TextStyle(
        color: theme.isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16.5);
  }

  handleUploadMedia(fileData) async {
    fileData = fileData.replaceAll('file://', '');
    FormData formData;

    formData = FormData.fromMap({
      "description": '',
      "position": 1,
      "file": await MultipartFile.fromFile(fileData,
          filename: fileData.split('/').last),
    });
    var response = await MediaApi().uploadMediaEmso(formData);

    return response;
  }

  Future<bool> handleNoticeCollection(ScaffoldMessengerState snackbar) async {
    var mediaIds = widget.mediaIds;
    dynamic bannerId;
    final userId = ref.read(meControllerProvider)[0]['id'];
    bool isSuccess = false;

    for (var i = 0; i < mediaIds.length; i++) {
      if (mediaIds[i] is int && widget.images[i] is File) {
        var mediaUploadResult = await handleUploadMedia(widget.images[i]!.path);
        if (mediaUploadResult == null) {
          snackbar.showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Có lỗi xảy ra khi upload"),
            ),
          );
        } else {
          mediaIds[i] = mediaUploadResult['id'];
        }
      }
    }
    if (!widget.images.contains(bannerImage) && bannerImage is File) {
      var mediaUploadBanner = await handleUploadMedia(bannerImage!.path);
      bannerId = mediaUploadBanner['id'];
    } else {
      final index = widget.images.indexWhere((e) => e == bannerImage);
      bannerId = mediaIds[index];
    }
    var response = await UserPageApi().createNoticeCollection({
      "title": title,
      "media_ids": mediaIds,
      "banner_id": bannerId,
    });
    if (response != null) {
      isSuccess = true;
    }
    await ref
        .read(userInformationProvider.notifier)
        .getUserFeatureContent(userId);
    return isSuccess;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.chosenFileImages.isNotEmpty) {
        bannerImage = widget.chosenFileImages.values.toList()[0];
      } else {
        bannerImage = widget.chosenImages.values.toList()[0];
      }
    });
  }

  void resetBanner(dynamic newBanner) {
    setState(() {
      bannerImage = newBanner;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = pv.Provider.of<ThemeManager>(context);
    final snackbar = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            const AppBarTitle(title: "Chỉnh sửa bộ sưu tập Đáng chú ý"),
            ButtonPrimary(
              label: isLoading ? null : "Lưu",
              icon: isLoading
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : null,
              handlePress: () async {
                setState(() {
                  isLoading = true;
                });
                var isSuccess = await handleNoticeCollection(snackbar);
                if (isSuccess) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                }
                setState(() {
                  isLoading = false;
                });
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: size.height,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text("Ảnh bìa", style: buildBoldTxt(theme)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => PickNoticeCoverImage(
                              chosenImages: widget.chosenImages,
                              chosenFileImages: widget.chosenFileImages,
                              resetBanner: resetBanner,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            height: size.height * 0.25,
                            width: size.width * 0.4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: bannerImage is String
                                  ? Image.network(
                                      bannerImage,
                                      height: size.height * 0.25,
                                      width: size.width * 0.4,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      bannerImage,
                                      height: size.height * 0.25,
                                      width: size.width * 0.4,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 7.5),
                            alignment: Alignment.bottomCenter,
                            height: size.height * 0.25,
                            width: size.width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Colors.transparent,
                                  Colors.black12,
                                  Colors.black54,
                                  Colors.black87,
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Column(
                  children: [
                    Text("Tiêu đề", style: buildBoldTxt(theme)),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      height: 50,
                      child: CupertinoTextField(
                        placeholder: "Nhập tên bộ sưu tập",
                        placeholderStyle: const TextStyle(
                          color: CupertinoColors.placeholderText,
                          fontSize: 16.5,
                        ),
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25.0),
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: widget.images.length + 1,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      crossAxisCount: 3,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, int index) {
                      if (index == 0) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 0.5,
                                color: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.images,
                                    size: 16.0,
                                    color: theme.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                Text(
                                  'Thêm ảnh mới',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: theme.isDarkMode
                                          ? Colors.white
                                          : Colors.black),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 0.325,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: widget.images[index - 1] is String
                                ? Image.network(
                                    widget.images[index - 1],
                                    height: size.height * 0.275,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    widget.images[index - 1],
                                    height: size.height * 0.275,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
