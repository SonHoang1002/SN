import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

class CreatePost extends StatelessWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List postTypeCreate = [
      {"icon": "assets/story.svg", "title": "Post"},
      {"icon": "assets/moment_menu.svg", "title": "Khoảnh khắc"},
      {"icon": "assets/Live.svg", "title": "Phát trực tiếp"}
    ];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const AppbarTitle(title: "Tạo bài viết"),
        ),
        body: Container(
          margin: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text(
                  "Bạn muốn tạo bài viết gì? Hãy chọn loại bài viết muốn tạo."),
              const SizedBox(
                height: 8,
              ),
              Column(
                  children: List.generate(
                      postTypeCreate.length,
                      (index) => Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 0.2, color: greyColor)),
                            child: Row(
                              children: [
                                SvgPicture.asset(postTypeCreate[index]['icon']),
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
                          )))
            ],
          ),
        ));
  }
}
