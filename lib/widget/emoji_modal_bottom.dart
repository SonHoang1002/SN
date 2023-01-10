import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:social_network_app_mobile/data/gif.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

class EmojiModalBottom extends StatefulWidget {
  final double height;
  const EmojiModalBottom({Key? key, required this.height}) : super(key: key);

  @override
  State<EmojiModalBottom> createState() => _EmojiModalBottomState();
}

class _EmojiModalBottomState extends State<EmojiModalBottom>
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
    TabController _tabControllerSticky = TabController(length: 2, vsync: this);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          const SizedBox(
            height: 8.0,
          ),
          const SearchInput(),
          SizedBox(
            height: 45,
            child: TabBar(
              controller: _tabController,
              onTap: (index) {},
              indicatorColor: Colors.grey.withOpacity(0.5),
              tabs: const [
                Tab(
                  icon: Icon(Icons.emoji_emotions, color: primaryColor),
                ),
                Tab(
                  icon: Icon(Icons.gif_box, size: 26, color: primaryColor),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: widget.height - 93,
                  child: TabBarView(controller: _tabController, children: [
                    const Center(child: Text("Chưa có dữ liệu")),
                    MasonryGridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: gifs.length,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: ImageCacheRender(
                                path: gifs[index]['images']['original']['url']),
                          );
                        })
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
