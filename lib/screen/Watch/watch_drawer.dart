import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/watch.dart';
import 'package:social_network_app_mobile/widget/page_item.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

class WatchDrawer extends StatelessWidget {
  const WatchDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 180,
          child: DrawerHeader(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Trang theo dõi',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              TextDescription(
                  description:
                      "Truy cập để xem video của các trang bạn đang theo dõi."),
              SizedBox(
                height: 5,
              ),
              SearchInput()
            ],
          )),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: List.generate(
                  pagesLike.length,
                  (index) => Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 8, right: 8, left: 10),
                        child: PageItem(page: pagesLike[index]['page']),
                      )),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
