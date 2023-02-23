import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class PostOneMediaDetail extends StatefulWidget {
  final dynamic postMedia;
  const PostOneMediaDetail({Key? key, this.postMedia}) : super(key: key);

  @override
  State<PostOneMediaDetail> createState() => _PostOneMediaDetailState();
}

class _PostOneMediaDetailState extends State<PostOneMediaDetail> {
  bool isShowAction = false;

  @override
  Widget build(BuildContext context) {
    String path = widget.postMedia['media_attachments'][0]['url'];
    final size = MediaQuery.of(context).size;

    void showActionSheet(BuildContext context, {required objectItem}) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Lưu ảnh',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Hủy",
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.w700),
              )),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () {
          setState(() {
            isShowAction = !isShowAction;
          });
        },
        child: Stack(
          children: [
            PhotoView(
              imageProvider: NetworkImage(path),
            ),
            isShowAction
                ? Positioned(
                    top: 70,
                    child: Container(
                      width: size.width - 40,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.5)),
                              child: const Icon(
                                FontAwesomeIcons.xmark,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                showActionSheet(context,
                                    objectItem: widget.postMedia);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withOpacity(0.5)),
                                child: const Icon(
                                  FontAwesomeIcons.ellipsis,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
