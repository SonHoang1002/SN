import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/emoji_activity.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

class EmojiActivity extends StatefulWidget {
  const EmojiActivity({Key? key}) : super(key: key);

  @override
  State<EmojiActivity> createState() => _EmojiActivityState();
}

class _EmojiActivityState extends State<EmojiActivity>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    if (!mounted) return;

    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(children: [
      Container(
        decoration:
            BoxDecoration(border: Border.all(width: 0.2, color: greyColor)),
        child: TabBar(
          controller: _tabController,
          onTap: (index) {},
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.displayLarge!.color,
          tabs: const [
            Tab(
              text: "Cảm xúc",
            ),
            Tab(text: "Hoạt động"),
          ],
        ),
      ),
      Container(margin: const EdgeInsets.all(8.0), child: const SearchInput()),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: [
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 8,
                    crossAxisCount: 2,
                    childAspectRatio: 4),
                itemCount: emojis.length,
                itemBuilder: (context, index) =>
                    Item(item: emojis[index], type: 'emoji')),
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 8,
                    crossAxisCount: 2,
                    childAspectRatio: 4),
                itemCount: activities.length,
                itemBuilder: (context, index) =>
                    Item(item: activities[index], type: 'activity')),
          ],
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}

class Item extends StatelessWidget {
  final dynamic item;
  final String type;
  const Item({
    super.key,
    this.item,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (type == 'activity') {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => CreateModalBaseMenu(
                  title: item['name'],
                  body: SizedBox(
                    height: size.height - 80,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 8,
                                crossAxisCount: 2,
                                childAspectRatio: 4),
                        itemCount: activityDetail.length,
                        itemBuilder: (context, index) =>
                            Item(item: activityDetail[index], type: 'emoji')),
                  ),
                  buttonAppbar: const SizedBox(),
                ),
              ));
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        decoration: BoxDecoration(
            border: Border.all(width: 0.2, color: greyColor),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageCacheRender(
                  path: item['url'],
                  width: 20.0,
                  height: 20.0,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  item['name'],
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            type == 'activity'
                ? const Icon(
                    FontAwesomeIcons.chevronRight,
                    size: 12,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
