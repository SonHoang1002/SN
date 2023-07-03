import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateMoment/create_moment.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_none_controller.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:video_compress/video_compress.dart';

class MomentCover extends StatefulWidget {
  final String videoPath;
  const MomentCover({Key? key, required this.videoPath}) : super(key: key);

  @override
  _MomentCoverState createState() => _MomentCoverState();
}

class _MomentCoverState extends State<MomentCover> {
  List<File> listImages = [];
  int imageIndexSelected = 0;

  @override
  void initState() {
    super.initState();

    handleGenerationThumbnail();
  }

  handleGenerationThumbnail() async {
    List<File> newList = [];
    for (int i = -1; i <= 8; i++) {
      File imageThumbnail = await getVideoThumbnail(i);
      newList.add(imageThumbnail);
    }

    setState(() {
      listImages = newList;
    });
  }

  getVideoThumbnail(position) async {
    final thumbnailFile = await VideoCompress.getFileThumbnail(widget.videoPath,
        position: position // default(-1)
        );
    return thumbnailFile;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            const AppBarTitle(title: "Chọn ảnh bìa"),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => CreateMoment(
                            imageCover: listImages[imageIndexSelected].path,
                            videoPath: widget.videoPath)));
              },
              child: Text(
                "Xong",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              width: size.width * 0.65,
              height: 500,
              child: VideoPlayerNoneController(
                path: widget.videoPath,
                type: 'local',
                isShowVolumn: false,
              ),
            ),
          ),
          SizedBox(
            width: size.width - 30,
            height: 5 + 1.5 * (size.width - 30) / 10,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listImages.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  File image = listImages[index];
                  return Listener(
                      // onPointerDown: (PointerDownEvent event) {
                      //   int newIndex =
                      //       (event.localPosition.dx / ((size.width - 33) / 10))
                      //           .floor();
                      //   if (newIndex != imageIndexSelected &&
                      //       newIndex >= 0 &&
                      //       newIndex < listImages.length) {
                      //     setState(() {
                      //       imageIndexSelected = newIndex;
                      //     });
                      //   }
                      // },
                      // onPointerMove: (PointerMoveEvent event) {
                      //   int moveAmount =
                      //       (event.localPosition.dx / ((size.width - 33) / 10))
                      //           .floor();
                      //   int newIndex = imageIndexSelected + moveAmount - index;
                      //   if (newIndex != imageIndexSelected &&
                      //       newIndex >= 0 &&
                      //       newIndex < listImages.length) {
                      //     setState(() {
                      //       imageIndexSelected = newIndex;
                      //     });
                      //   }
                      // },
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        imageIndexSelected = index;
                      });
                    },
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: imageIndexSelected == index
                                    ? Border.all(width: 2, color: Colors.red)
                                    : Border.all(width: 0, color: transparent)),
                            child: Image.file(
                              image,
                              width: (size.width - 33) / 10,
                              height: (imageIndexSelected == index ? 5 : 0) +
                                  1.5 * (size.width - 30) / 10,
                              fit: BoxFit.cover,
                            ),
                          ),
                          imageIndexSelected == index
                              ? const SizedBox()
                              : Positioned.fill(
                                  child: Container(
                                  color: Colors.white.withOpacity(0.4),
                                ))
                        ],
                      ),
                    ),
                  ));
                }),
          )
        ],
      ),
    );
  }
}
