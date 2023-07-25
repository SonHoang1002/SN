import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart' as pv;

import '../../../../theme/theme_manager.dart';
import '../../../../widgets/appbar_title.dart';
import '../../../../widgets/back_icon_appbar.dart';
import '../../../../widgets/button_primary.dart';
import 'dart:io';

class PickNoticeCoverImage extends ConsumerStatefulWidget {
  final Map<String, String> chosenImages;
  final Map<int, File> chosenFileImages;
  final Function resetBanner;
  const PickNoticeCoverImage({
    super.key,
    required this.chosenImages,
    required this.chosenFileImages,
    required this.resetBanner,
  });

  @override
  PickNoticeCoverImageState createState() => PickNoticeCoverImageState();
}

class PickNoticeCoverImageState extends ConsumerState<PickNoticeCoverImage> {
  dynamic chosenBannerImage;
  List images = [];
  int chosenIndex = 0;
  XFile? newBanner;
  File? newBannerImage;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        images = [
          ...widget.chosenFileImages.values.toList(),
          ...widget.chosenImages.values.toList()
        ];
        chosenBannerImage = images[0];
      });
    }
  }

  Widget buildImageItem(item, Size size) {
    return GestureDetector(
      onTap: () {
        final indexWhere = images.indexWhere((e) => e == item);
        setState(() {
          chosenIndex = indexWhere;
          chosenBannerImage = images[indexWhere];
        });
      },
      child: Container(
        height: size.height * 0.3,
        width: size.width * 0.325,
        margin: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.325),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: item is String
                  ? Image.network(
                      item,
                      height: size.height * 0.3,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      item,
                      height: size.height * 0.3,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              bottom: 5.0,
              right: 5.0,
              child: item == images[chosenIndex]
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            const AppBarTitle(title: "Chọn ảnh bìa cho bộ sưu tập"),
            ButtonPrimary(
              label: "Dùng",
              handlePress: () {
                widget.resetBanner(chosenBannerImage);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  height: size.height * 0.45,
                  width: size.width * 0.55,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.2,
                        color: theme.isDarkMode ? Colors.white : Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: chosenBannerImage is String
                        ? Image.network(
                            chosenBannerImage,
                            height: size.height * 0.25,
                            width: size.width * 0.4,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            chosenBannerImage,
                            height: size.height * 0.25,
                            width: size.width * 0.4,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: size.height * 0.3,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.5,
                  vertical: 25.0,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () async {
                          newBanner = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          setState(() {
                            chosenIndex = 0;
                            images = [File(newBanner!.path), ...images];
                            chosenBannerImage = File(newBanner!.path);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          height: size.height * 0.3,
                          width: size.width * 0.325,
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
                              Icon(Icons.camera_alt_rounded,
                                  size: 16.0,
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                              Text(
                                'Tải lên ảnh bìa',
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
                      return buildImageItem(images[index - 1], size);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
