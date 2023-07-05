import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateMoment/create_moment.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MomentCover extends StatefulWidget {
  final String videoPath;
  final String? videoPathUpload;
  const MomentCover({Key? key, required this.videoPath, this.videoPathUpload})
      : super(key: key);

  @override
  _MomentCoverState createState() => _MomentCoverState();
}

class _MomentCoverState extends State<MomentCover> {
  List<File> listImages = [];
  int imageIndexSelected = 0;
  bool isLoadAsset = true;

  @override
  void initState() {
    super.initState();
    handleGenerationThumbnail();
  }

  handleGenerationThumbnail() async {
    MediaInfo mediaInfo = await VideoCompress.getMediaInfo(widget.videoPath);
    Duration videoDuration =
        Duration(milliseconds: mediaInfo.duration!.floor());

    Duration interval = videoDuration ~/ 10;

    List<File> thumbnails = [];
    for (int i = 0; i < 10; i++) {
      Duration thumbnailTime = interval * i;
      File thumbnailData = await getVideoThumbnail(i, thumbnailTime);
      thumbnails.add(thumbnailData);
    }

    setState(() {
      isLoadAsset = false;
      listImages = thumbnails;
    });
  }

  getVideoThumbnail(i, position) async {
    final thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: widget.videoPath,
        imageFormat: ImageFormat.PNG,
        timeMs: position.inMilliseconds,
        thumbnailPath: "${dirname(widget.videoPath)}/$i.png");

    return File(thumbnailFile!);
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
                            imageCover: listImages[imageIndexSelected],
                            videoPath:
                                widget.videoPathUpload ?? widget.videoPath)));
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
      body: isLoadAsset
          ? SizedBox(
              width: size.width,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text("Đang khởi tạo, vui lòng chờ trong giây lát")
                ],
              ),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                if (listImages.isNotEmpty)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: primaryColorSelected)),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: size.width * 0.65,
                            height: size.width * 0.65 * 16 / 9,
                            child: Image.file(listImages[imageIndexSelected],
                                fit: BoxFit.cover),
                          ),
                          const Positioned.fill(
                            child: Center(
                              child: Icon(
                                CupertinoIcons.play_circle,
                                color: white,
                                size: 60,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                    width: size.width - 30,
                    height: 5 + 1.5 * (size.width - 30) / 10,
                    child: Listener(
                      onPointerMove: (PointerMoveEvent event) {
                        int newIndex =
                            (event.localPosition.dx / ((size.width - 33) / 10))
                                .floor();
                        if (newIndex != imageIndexSelected &&
                            newIndex >= 0 &&
                            newIndex < listImages.length) {
                          setState(() {
                            imageIndexSelected = newIndex;
                          });
                        }
                      },
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listImages.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            File image = listImages[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  imageIndexSelected = index;
                                });
                              },
                              child: Center(
                                child: Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeOut,
                                      decoration: BoxDecoration(
                                          border: imageIndexSelected == index
                                              ? Border.all(
                                                  width: 2, color: Colors.red)
                                              : Border.all(
                                                  width: 0,
                                                  color: transparent)),
                                      child: Image.file(
                                        image,
                                        width: (size.width -
                                                (imageIndexSelected == index
                                                    ? 35
                                                    : 33)) /
                                            10,
                                        height: (imageIndexSelected == index
                                                ? 2
                                                : 0) +
                                            1.35 * (size.width - 30) / 10,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    imageIndexSelected == index
                                        ? const SizedBox()
                                        : Positioned.fill(
                                            child: Container(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ))
                                  ],
                                ),
                              ),
                            );
                          }),
                    ))
              ],
            ),
    );
  }
}
