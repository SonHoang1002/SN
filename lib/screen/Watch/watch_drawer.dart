import 'package:flutter/material.dart';

import '../../data/watch.dart';
import '../../widget/page_item.dart';
import '../../widget/search_input.dart';
import '../../widget/text_description.dart';

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
            children:  [
              const Text(
                'Trang theo dõi',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              const TextDescription(
                  description:
                      "Truy cập để xem video của các trang bạn đang theo dõi."),
              const SizedBox(
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
