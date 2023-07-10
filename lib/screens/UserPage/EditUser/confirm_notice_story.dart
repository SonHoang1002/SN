import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'dart:io';

import '../../../apis/media_api.dart';
import '../../../providers/UserPage/user_information_provider.dart';
import '../../../providers/me_provider.dart';
import '../../../theme/theme_manager.dart';
import '../../../widgets/appbar_title.dart';
import '../../../widgets/back_icon_appbar.dart';
import '../../../widgets/button_primary.dart';

class ConfirmNoticeStory extends ConsumerStatefulWidget {
  final Map<String, String> chosenImages;
  final Map<int, File> chosenFileImages;
  const ConfirmNoticeStory({
    super.key,
    required this.chosenImages,
    required this.chosenFileImages,
  });

  @override
  ConfirmNoticeStoryState createState() => ConfirmNoticeStoryState();
}

class ConfirmNoticeStoryState extends ConsumerState<ConfirmNoticeStory> {
  String bannerImage = '';
  String title = '';

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final urls = widget.chosenImages.values.toList();
    final files = widget.chosenFileImages.values.toList();
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
              label: "Lưu",
              handlePress: () async {
                var mediaIds = widget.chosenImages.keys.toList();
                var mediaFileIds = [];
                final userId = ref.read(meControllerProvider)[0]['id'];

                if (widget.chosenFileImages.isNotEmpty) {
                  for (var i = 0; i < widget.chosenFileImages.length; i++) {
                    var mediaUploadResult = await handleUploadMedia(
                        widget.chosenFileImages[i]!.path);
                    if (mediaUploadResult == null) {
                      snackbar.showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text("Có lỗi xảy ra khi upload"),
                        ),
                      );
                    } else {
                      mediaFileIds.add(mediaUploadResult['id']);
                    }
                  }
                }
                await UserPageApi().createNoticeCollection({
                  "title": title,
                  "media_ids": mediaFileIds.isEmpty
                      ? mediaIds
                      : [...mediaFileIds, ...mediaIds],
                  "banner_id":
                      mediaFileIds.isEmpty ? mediaIds[0] : mediaFileIds[0],
                });
                await ref
                    .read(userInformationProvider.notifier)
                    .getUserFeatureContent(userId);
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: size.height,
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text("Ảnh bìa", style: buildBoldTxt(theme)),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      height: size.height * 0.25,
                      width: size.width * 0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          urls[0],
                          height: size.height * 0.25,
                          width: size.width * 0.4,
                          fit: BoxFit.cover,
                        ),
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
                    itemCount: widget.chosenImages.length +
                        widget.chosenFileImages.length +
                        1,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
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
                      } else if (index >= 1 && index < files.length + 1) {
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
                            child: Image.file(
                              files[index - 1],
                              height: size.height * 0.275,
                              fit: BoxFit.cover,
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
                            child: Image.network(
                              urls[index - files.length - 1],
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
