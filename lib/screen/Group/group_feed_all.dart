import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/groups.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class GroupFeedAll extends StatelessWidget {
  const GroupFeedAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: 70,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: groupMember.length,
                  itemBuilder: (context, index) => Container(
                        width: 70,
                        height: 70,
                        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: ImageCacheRender(
                                    path: groupMember[index]['banner']
                                        ['preview_url'],
                                    width: 70.0,
                                    height: 70.0,
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                                Positioned(
                                    bottom: 2,
                                    left: 2,
                                    child: SizedBox(
                                        width: 64,
                                        child: Text(
                                          groupMember[index]['title'],
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              overflow: TextOverflow.ellipsis),
                                        )))
                              ],
                            ),
                          ],
                        ),
                      ))),
          const CrossBar(),
          ListView.builder(
              shrinkWrap: true,
              primary: true,
              itemCount: postDiscoverGroup.length,
              itemBuilder: ((context, index) => Post(
                    post: postDiscoverGroup[index],
                  )))
        ],
      ),
    ));
  }
}
