import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/common.api.dart';
import 'package:social_network_app_mobile/data/emoji_activity.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

class EmojiActivity extends StatefulWidget {
  final String type;
  final dynamic statusActivity;
  final Function handleUpdateData;

  const EmojiActivity(
      {Key? key,
      this.statusActivity,
      required this.handleUpdateData,
      required this.type})
      : super(key: key);

  @override
  State<EmojiActivity> createState() => _EmojiActivityState();
}

class _EmojiActivityState extends State<EmojiActivity>
    with TickerProviderStateMixin {
  late TabController _tabController;
  dynamic preStatus;
  String textSearch = '';

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.statusActivity != null) {
      setState(() {
        preStatus = widget.statusActivity;
      });
    }
  }

  handleSearch(value) {
    setState(() {
      textSearch = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List listEmojis = emojis
        .where((element) => element['name'].contains(textSearch))
        .toList();
    List listActivities = activities
        .where((element) => element['name'].contains(textSearch))
        .toList();

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
      Container(margin: const EdgeInsets.all(8.0), child:  SearchInput()),
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
                itemCount: listEmojis.length,
                itemBuilder: (context, index) => Item(
                    typePage: widget.type,
                    subType: 'emoji',
                    item: listEmojis[index],
                    type: 'emoji',
                    handleUpdateData: widget.handleUpdateData)),
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 8,
                    crossAxisCount: 2,
                    childAspectRatio: 4),
                itemCount: listActivities.length,
                itemBuilder: (context, index) => Item(
                      typePage: widget.type,
                      subType: 'emoji',
                      item: listActivities[index],
                      type: 'activity',
                      handleUpdateData: widget.handleUpdateData,
                    )),
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

class Item extends StatefulWidget {
  final dynamic item;
  final String type;
  final String subType;
  final String typePage;
  final Function handleUpdateData;
  const Item({
    super.key,
    this.item,
    required this.type,
    required this.handleUpdateData,
    required this.subType,
    required this.typePage,
  });

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  fetchDataChildActivity(id) async {
    var response = await CommonApi().fetchDataActivityListApi(id);
    if (response != null) {
      if (mounted) {
        final size = MediaQuery.of(context).size;
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => CreateModalBaseMenu(
                title: widget.item['name'],
                body: SizedBox(
                  height: size.height - 80,
                  child: response['data'].isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 8,
                                  crossAxisCount: 2,
                                  childAspectRatio: 4),
                          itemCount: response['data'].length,
                          itemBuilder: (context, index) => Item(
                              typePage: widget.typePage,
                              item: response['data'][index],
                              type: 'emoji',
                              subType: 'child',
                              handleUpdateData: widget.handleUpdateData))
                      : const Center(child: Text("Không có dữ liệu hiển thị")),
                ),
                buttonAppbar: const SizedBox(),
              ),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.type == 'activity') {
          fetchDataChildActivity(widget.item['id']);
        } else {
          widget.handleUpdateData('update_status_activity', widget.item);
          if (widget.subType == 'child') {
            if (widget.typePage == 'menu_out') {
              Navigator.of(context)
                ..pop()
                ..pop();
            } else {
              Navigator.of(context)
                ..pop()
                ..pop()
                ..pop();
            }
          } else {
            if (widget.typePage == 'menu_out') {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context)
                ..pop()
                ..pop();
            }
          }
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
                  path: widget.item['url'],
                  width: 20.0,
                  height: 20.0,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  widget.item['name'],
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            widget.type == 'activity'
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
