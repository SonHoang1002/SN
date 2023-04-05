import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/config.dart';
import 'package:social_network_app_mobile/apis/emoji_sticky_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/data/gif.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

class EmojiModalBottom extends StatefulWidget {
  final double height;
  final String? type;
  final Function functionGetEmoji;
  const EmojiModalBottom(
      {Key? key,
      this.type,
      required this.height,
      required this.functionGetEmoji})
      : super(key: key);

  @override
  State<EmojiModalBottom> createState() => _EmojiModalBottomState();
}

class _EmojiModalBottomState extends State<EmojiModalBottom>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List listGif = [];
  List listSticky = [];
  List listMenuSticky = [
    {"icon": FontAwesomeIcons.fireFlameCurved, "id": 'trending'},
    // {"icon": FontAwesomeIcons.magnifyingGlass, "id": 'search'},
    // {"icon": FontAwesomeIcons.clock, "id": 'history'}
  ];
  bool isLoadingGif = true;
  bool isLoadingSticky = true;
  bool isLoadingMenuSticky = true;
  String tabStickySelected = 'trending';

  @override
  void initState() {
    if (!mounted) return;

    super.initState();
    fetchDataGif({"offset": 0, "api_key": gifKey, "limit": 10});
    fetchGetSticky('free');
    fetchGetSticky('trending');
    _tabController = TabController(length: 2, vsync: this);
  }

  fetchDataGif(params) async {
    setState(() {
      isLoadingGif = true;
    });
    var response = await EmojiStickyApi().fetchDataGifApi(params);
    if (response != null) {
      if (mounted) {
        setState(() {
          isLoadingGif = false;
          listGif = response["data"];
        });
      }
    }
  }

  fetchGetSticky(type) async {
    // ignore: prefer_typing_uninitialized_variables
    var response;
    if (type == 'free') {
      response = await EmojiStickyApi().getPackFreeApi();
      if (response != null && listMenuSticky.length == 1) {
        var listMenuFree = List.from(response['data'].map((el) => ({
              "sticky": el["thumbnails"].elementAt(0)["url"],
              "id": el["id"],
            })));
        if (mounted) {
          setState(() {
            isLoadingMenuSticky = false;
            listMenuSticky = [...listMenuSticky, ...listMenuFree];
          });
        }
      }
    } else if (type == 'trending') {
      setState(() {
        isLoadingSticky = true;
      });
      response = await EmojiStickyApi().getTrendingApi();
      if (response != null) {
        var listTrending = List.from(response["data"].map((el) =>
            ({"id": el['id'], "url": el["images"].elementAt(0)["url"]})));
        if (mounted) {
          setState(() {
            isLoadingSticky = false;
            listSticky = listTrending;
          });
        }
      }
    } else {
      setState(() {
        isLoadingSticky = true;
      });
      response = await EmojiStickyApi().getPackDetailApi(type);
      if (response != null) {
        List listStickyData = List.from(response['data']["stickers"]?.map(
            (el) =>
                ({"id": el['id'], "url": el["images"].elementAt(0)["url"]})));

        if (mounted) {
          setState(() {
            isLoadingSticky = false;
            listSticky = listStickyData;
          });
        }
      }
    }
  }

  handleSearch(value) {
    fetchDataGif({"offset": 0, "api_key": gifKey, "limit": 10, "q": value});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.type == postWatch
          ? Colors.grey.shade900
          : Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          const SizedBox(
            height: 8.0,
          ),
          SearchInput(type: widget.type),
          SizedBox(
            height: 45,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.grey.withOpacity(0.5),
              tabs: const [
                Tab(
                  icon: Icon(Icons.emoji_emotions, color: secondaryColor),
                ),
                Tab(
                  icon: Icon(Icons.gif_box, size: 26, color: secondaryColor),
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
                    renderSticker(),
                    isLoadingGif
                        ? const Center(child: CupertinoActivityIndicator())
                        : MasonryGridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: listGif.length,
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  widget.functionGetEmoji(
                                      gifs[index]['images']['original']['url']);
                                },
                                child: ImageCacheRender(
                                    path: gifs[index]['images']['original']
                                        ['url']),
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

  Widget renderSticker() {
    final size = MediaQuery.of(context).size;
    return isLoadingMenuSticky
        ? const Center(child: CupertinoActivityIndicator())
        : SizedBox(
            width: size.width,
            height: widget.height - 93,
            child: Column(
              children: [
                SizedBox(
                    height: widget.height - 145,
                    child: isLoadingSticky
                        ? const Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : SingleChildScrollView(
                            child: GridView.count(
                              shrinkWrap: true,
                              primary: false,
                              padding: const EdgeInsets.all(4),
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 2,
                              crossAxisCount: 4,
                              children: List.generate(
                                  listSticky.length,
                                  (index) => InkWell(
                                        onTap: () {
                                          widget.functionGetEmoji(
                                              listSticky[index]['url']);
                                        },
                                        child: Image.network(
                                            listSticky[index]['url']),
                                      )),
                            ),
                          )),
                SizedBox(
                  height: 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(
                            listMenuSticky.length,
                            (index) => Container(
                                  padding: const EdgeInsets.all(6),
                                  margin:
                                      const EdgeInsets.only(left: 2, right: 2),
                                  decoration: BoxDecoration(
                                      color: tabStickySelected ==
                                              listMenuSticky[index]['id']
                                          ? Colors.grey.withOpacity(0.3)
                                          : null,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          fetchGetSticky(
                                              listMenuSticky[index]['id']);
                                          tabStickySelected =
                                              listMenuSticky[index]['id'];
                                        });
                                      },
                                      child: listMenuSticky[index]['sticky'] !=
                                              null
                                          ? Image.network(
                                              listMenuSticky[index]['sticky'],
                                              height: 28,
                                              width: 28,
                                              fit: BoxFit.contain,
                                            )
                                          : Icon(listMenuSticky[index]['icon'],
                                              size: 24,
                                              color: Theme.of(context)
                                                  .primaryColorDark),
                                    ),
                                  ),
                                ))),
                  ),
                ),
              ],
            ),
          );
  }
}
