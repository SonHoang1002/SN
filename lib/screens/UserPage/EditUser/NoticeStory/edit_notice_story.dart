import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:provider/provider.dart' as pv;

import '../../../../theme/theme_manager.dart';

import '../../../../widgets/appbar_title.dart';
import '../../../../widgets/back_icon_appbar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'confirm_notice_story.dart';

class EditNoticeStory extends ConsumerStatefulWidget {
  const EditNoticeStory({super.key});

  @override
  EditNoticeStoryState createState() => EditNoticeStoryState();
}

class EditNoticeStoryState extends ConsumerState<EditNoticeStory> {
  List uploadedFiles = [];
  XFile? _image;
  List uploadedBefore = [];
  List avatars = [];
  List coverImg = [];
  bool showUploadBefore = true;
  bool showAvatars = true;
  bool showCoverImg = true;
  int fileIndex = 0;
  var chosenImg = <String, String>{}; // những bức ảnh được chọn -> media_ids
  var chosenFileImg = <int, File>{};
  List images = [];
  List mediaIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final userId = ref.read(meControllerProvider)[0]['id'];
      initImages(userId);
    });
  }

  void initImages(String userId) async {
    final uploadBeforeRes =
        await UserPageApi().getMediaAttachment(userId, {"limit": 5});
    final avatarRes = await UserPageApi().getMediaAttachment(
        userId, {"post_type": "account_avatar", "limit": 5});
    final coverRes = await UserPageApi().getMediaAttachment(
        userId, {"post_type": "account_banner", "limit": 5});

    setState(() {
      // dont take video
      uploadedBefore =
          uploadBeforeRes.where((e) => e['type'] == 'image').toList();
      avatars = avatarRes.where((e) => e['type'] == 'image').toList();
      coverImg = coverRes.where((e) => e['type'] == 'image').toList();
      isLoading = false;
    });
  }

  void loadMoreUploadBefore(String userId, String maxId) async {
    final uploadBeforeRes = await UserPageApi()
        .getMediaAttachment(userId, {"limit": 5, "max_id": maxId});
    if (uploadBeforeRes.isEmpty) {
      setState(() {
        showUploadBefore = false;
      });
    } else {
      final imageUpload =
          uploadBeforeRes.where((e) => e['type'] == 'image').toList();
      setState(() {
        uploadedBefore = [...uploadedBefore, ...imageUpload];
      });
    }
  }

  void loadMoreAvatar(String userId, String maxId) async {
    final avatarRes = await UserPageApi().getMediaAttachment(
        userId, {"limit": 5, "max_id": maxId, "post_type": "account_avatar"});
    if (avatarRes.isEmpty) {
      setState(() {
        showAvatars = false;
      });
    } else {
      final imageAvatars =
          avatarRes.where((e) => e['type'] == 'image').toList();
      setState(() {
        avatars = [...avatars, ...imageAvatars];
      });
    }
  }

  void loadMoreBanner(String userId, String maxId) async {
    final bannerRes = await UserPageApi()
        .getMediaAttachment(userId, {"limit": 5, "max_id": maxId});
    if (bannerRes.isEmpty) {
      setState(() {
        showCoverImg = false;
      });
    } else {
      final imageBanners =
          bannerRes.where((e) => e['type'] == 'image').toList();
      setState(() {
        coverImg = [...coverImg, ...imageBanners];
      });
    }
  }

  Widget _buildTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 7.5),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
      ),
    );
  }

  Widget _buildSeeMoreButton(Function onTap) {
    return ButtonPrimary(
      label: "Xem thêm",
      colorText: Colors.black87,
      colorButton: greyColor[300],
      handlePress: onTap,
    );
  }

  Widget _buildEmptyList(String title) {
    return SizedBox(height: 30.0, child: Center(child: Text(title)));
  }

  Widget buildImageItem(item, double height) {
    final renderUrl = item['url'] ?? item['show_url'] ?? item['preview_url'];
    return GestureDetector(
      onTap: () {
        setState(() {
          if (!chosenImg.keys.contains(item['id'])) {
            chosenImg[item['id']] = renderUrl;
            images.add(renderUrl);
            mediaIds.add(item['id']);
          } else {
            chosenImg.remove(item['id']);
            images.remove(renderUrl);
            mediaIds.remove(item['id']);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.325),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                renderUrl,
                height: height * 0.275,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 5.0,
              right: 5.0,
              child: chosenImg.keys.contains(item['id'])
                  ? const Icon(
                      Icons.check_circle,
                      size: 22.5,
                      color: Colors.lightBlue,
                    )
                  : const Icon(
                      Icons.circle_outlined,
                      size: 22.5,
                      color: Colors.grey,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageFileItem(item, double height) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (!chosenFileImg.keys.contains(item['id'])) {
            chosenFileImg[item['id']] = item['file'];
            images.add(item['file']);
            mediaIds.add(item['id']);
          } else {
            chosenFileImg.remove(item['id']);
            images.remove(item['file']);
            mediaIds.remove(item['id']);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.325),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.file(
                item['file']!,
                height: height * 0.25,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 5.0,
              right: 5.0,
              child: chosenFileImg.keys.contains(item['id'])
                  ? const Icon(
                      Icons.check_circle,
                      size: 22.5,
                      color: Colors.lightBlue,
                    )
                  : const Icon(
                      Icons.circle_outlined,
                      size: 22.5,
                      color: Colors.grey,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridImages(List images, double height) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: images.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, int index) {
          return buildImageItem(images[index], height);
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final length = chosenImg.length + uploadedFiles.length;
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            const AppBarTitle(title: "Thêm vào mục đáng chú ý"),
            ButtonPrimary(
              label: "Tiếp",
              colorText: length == 0 ? Colors.black : Colors.white,
              colorButton: length == 0 ? greyColor[300] : secondaryColor,
              handlePress: () {
                if (length != 0) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ConfirmNoticeStory(
                        chosenImages: chosenImg,
                        chosenFileImages: chosenFileImg,
                        images: images,
                        mediaIds: mediaIds,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: size.height,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                color: theme.isDarkMode ? Colors.white : Colors.black,
              ))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ButtonPrimary(
                      label: "Tải ảnh lên",
                      icon: const Icon(
                        FontAwesomeIcons.upload,
                        size: 15.0,
                        color: Colors.black,
                      ),
                      colorText: Colors.black87,
                      colorButton: greyColor[300],
                      handlePress: () async {
                        _image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        setState(() {
                          final newUploadImage = File(_image!.path);
                          uploadedFiles = [
                            ...uploadedFiles,
                            {"id": fileIndex, "file": newUploadImage}
                          ];
                          chosenFileImg[fileIndex] = newUploadImage;
                          images.add(newUploadImage);
                          mediaIds.add(fileIndex);
                          fileIndex += 1;
                        });
                      },
                    ),
                    _buildTitle("Ảnh vừa tải lên"),
                    uploadedFiles.isEmpty
                        ? const SizedBox(
                            height: 30.0,
                            child: Center(
                              child: Text('Chưa có ảnh nào vừa được tải lên'),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            itemCount: uploadedFiles.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              crossAxisCount: 3,
                              childAspectRatio: 0.85,
                            ),
                            itemBuilder: (context, int index) {
                              return buildImageFileItem(
                                  uploadedFiles[index], size.height);
                            }),
                    const SizedBox(height: 12.0),
                    _buildTitle("Ảnh đã tải lên từ trước"),
                    uploadedBefore.isEmpty
                        ? _buildEmptyList(
                            "Chưa có ảnh nào được tải lên từ trước")
                        : buildGridImages(uploadedBefore, size.height),
                    showUploadBefore
                        ? _buildSeeMoreButton(() {
                            final userId =
                                ref.read(meControllerProvider)[0]['id'];
                            loadMoreUploadBefore(
                                userId, uploadedBefore.last['id']);
                          })
                        : const SizedBox(height: 10.0),
                    const SizedBox(height: 12.0),
                    _buildTitle("Ảnh đại diện"),
                    avatars.isEmpty
                        ? _buildEmptyList("Chưa có ảnh đại diện")
                        : buildGridImages(avatars, size.height),
                    showAvatars
                        ? _buildSeeMoreButton(() {
                            final userId =
                                ref.read(meControllerProvider)[0]['id'];
                            loadMoreAvatar(userId, avatars.last['id']);
                          })
                        : const SizedBox(height: 10.0),
                    const SizedBox(height: 12.0),
                    _buildTitle("Ảnh bìa"),
                    coverImg.isEmpty
                        ? _buildEmptyList("Chưa có ảnh bìa")
                        : buildGridImages(coverImg, size.height),
                    showCoverImg
                        ? _buildSeeMoreButton(() {
                            final userId =
                                ref.read(meControllerProvider)[0]['id'];
                            loadMoreBanner(userId, coverImg.last['id']);
                          })
                        : const SizedBox(height: 10.0),
                  ],
                ),
              ),
      ),
    );
  }
}
