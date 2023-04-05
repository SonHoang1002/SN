import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_new_feed.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

class CreatePost extends StatelessWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List postTypeCreate = [
      {"key": "post", "icon": "assets/story.svg", "title": "Post"},
      {
        "key": "moment",
        "image": "assets/MomentMenu.png",
        "title": "Khoảnh khắc"
      },
      {"key": "live", "icon": "assets/Live.svg", "title": "Phát trực tiếp"}
    ];

    return Container(
        margin: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppBarTitle(title: "Tạo bài viết"),
              const SizedBox(
                height: 12,
              ),
              const Text(
                  "Bạn muốn tạo bài viết gì? Hãy chọn loại bài viết muốn tạo."),
              const SizedBox(
                height: 12,
              ),
              Column(
                  children: List.generate(
                      postTypeCreate.length,
                      (index) => GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: ((context) {
                                String key = postTypeCreate[index]['key'];
                                return key == 'post'
                                    ? const CreateNewFeed()
                                    : const SizedBox();
                              })));
                            },
                            child: Container(
                              height: 60,
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 0.2, color: greyColor)),
                              child: Row(
                                children: [
                                  if (postTypeCreate[index]?['icon'] != null)
                                    SvgPicture.asset(
                                        postTypeCreate[index]['icon']),
                                  if (postTypeCreate[index]?['image'] != null)
                                    Image.asset(
                                      postTypeCreate[index]?['image'],
                                      width: 31,
                                      height: 31,
                                    ),
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
                            ),
                          )))
            ],
          ),
        ));
  }
}
