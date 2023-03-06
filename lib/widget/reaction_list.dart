import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/widget/tab_social.dart';
import 'package:social_network_app_mobile/widget/user_item.dart';

class ReactionList extends StatefulWidget {
  final dynamic post;
  const ReactionList({Key? key, this.post}) : super(key: key);

  @override
  State<ReactionList> createState() => _ReactionListState();
}

class _ReactionListState extends State<ReactionList> {
  dynamic dataRender = {};
  int indexTab = 0;
  bool isMore = true;

  @override
  void initState() {
    super.initState();
    if (mounted && dataRender.isEmpty) {
      fetchDataReaction(null);
    }
  }

  fetchDataReaction(params) async {
    if (isMore == false) return;
    var response = await PostApi().getListFavourited(widget.post['id'], params);

    dynamic dataFlag = dataRender;

    if (response.length < 20) {
      setState(() {
        isMore = false;
      });
    }

    if (indexTab == 0) {
      dataFlag['all'] = checkObjectUniqueInList(
          [...(dataFlag['all'] ?? []), ...response], 'id');
    } else {
      dataFlag[params['vote_type']] = checkObjectUniqueInList(
          [...(dataFlag[params['vote_type']] ?? []), ...response], 'id');
    }

    setState(() {
      dataRender = dataFlag;
    });
  }

  renderGif(key) {
    return Image.asset(
      'assets/reaction/$key.png',
      width: 20,
      height: 20,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(FontAwesomeIcons.faceAngry),
    );
  }

  @override
  Widget build(BuildContext context) {
    List reactions = widget.post['reactions'] ?? [];

    getCountTypeReaction(type, String text) {
      return shortenLargeNumber(reactions.firstWhere(
        (el) => el['type'] == type,
        orElse: () => {text: '0'},
      )?[text]);
    }

    List listTabs = [
      {
        "type": 'all',
        "text": const SizedBox(),
        "count": widget.post['favourites_count']
      },
      {
        "type": 'like',
        "text": renderGif('like'),
        "count": getCountTypeReaction('like', 'likes_count')
      },
      {
        "type": 'love',
        "text": renderGif('love'),
        "count": getCountTypeReaction('love', 'loves_count')
      },
      {
        "type": 'sad',
        "text": renderGif('sad'),
        "count": getCountTypeReaction('sad', 'sads_count')
      },
      {
        "type": 'haha',
        "text": renderGif('haha'),
        "count": getCountTypeReaction('haha', 'hahas_count')
      },
      {
        "type": 'wow',
        "text": renderGif('wow'),
        "count": getCountTypeReaction('wow', 'wows_count')
      },
      {
        "type": 'angry',
        "text": renderGif('angry'),
        "count": getCountTypeReaction('angry', 'angrys_count')
      },
      {
        "type": 'yay',
        "text": renderGif('yay'),
        "count": getCountTypeReaction('yay', 'yays_count')
      }
    ];

    List tabsRenderObject = listTabs.where((el) => el['count'] > 0).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: TabSocial(
            tabCustom: List.generate(
                tabsRenderObject.length,
                (index) => Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          tabsRenderObject[index]['text'],
                          const SizedBox(width: 8),
                          Text(tabsRenderObject[index]['type'] == 'all'
                              ? "Tất cả"
                              : '${tabsRenderObject[index]['count']}')
                        ],
                      ),
                    )),
            handleTabChange: (index) {
              setState(() {
                indexTab = index;
                isMore = true;
              });
              if (tabsRenderObject[index]['type'] != 'all') {
                fetchDataReaction(
                    {'vote_type': tabsRenderObject[index]['type']});
              } else {
                fetchDataReaction(null);
              }
            },
            childTab: List.generate(
              tabsRenderObject.length,
              (indexTab) => dataRender.isNotEmpty &&
                      dataRender[tabsRenderObject[indexTab]['type']] != null &&
                      dataRender[tabsRenderObject[indexTab]['type']].isNotEmpty
                  ? NotificationListener(
                      onNotification: (ScrollNotification notification) {
                        if (notification is ScrollEndNotification) {
                          final before = notification.metrics.extentBefore;
                          final max = notification.metrics.maxScrollExtent;

                          if (before == max) {
                            fetchDataReaction({
                              "max_id":
                                  dataRender[tabsRenderObject[indexTab]['type']]
                                      .last['id'],
                              "vote_type": tabsRenderObject[indexTab]['type']
                            });
                          }
                        }
                        return false;
                      },
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              dataRender[tabsRenderObject[indexTab]['type']]
                                  .length,
                          itemBuilder: (context, index) => Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                child: Stack(
                                  children: [
                                    UserItem(
                                      user: dataRender[
                                          tabsRenderObject[indexTab]
                                              ['type']][index]['account'],
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        left: 25,
                                        child: renderGif(dataRender[
                                                tabsRenderObject[indexTab]
                                                    ['type']][index]
                                            ['custom_vote_type']))
                                  ],
                                ),
                              )),
                    )
                  : const Center(
                      child: CupertinoActivityIndicator(),
                    ),
            )),
      ),
    );
  }
}
