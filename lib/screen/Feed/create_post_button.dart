import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_new_feed.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatePostButton extends StatefulWidget {
  const CreatePostButton({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreatePostButtonState createState() => _CreatePostButtonState();
}

class _CreatePostButtonState extends State<CreatePostButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: ((context) => const CreateNewFeed())));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: const [
                  AvatarSocial(
                      width: 40,
                      height: 40,
                      path:
                          "https://snapi.emso.asia/system/media_attachments/files/108/853/138/654/944/677/original/cc4c8fd4be1d7a96.jpg"),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Bạn đang nghĩ gì?",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              SvgPicture.asset(
                "assets/post_media.svg",
                width: 30,
              )
            ]),
      ),
    );
  }
}
