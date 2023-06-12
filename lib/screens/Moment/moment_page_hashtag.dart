import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/apis/moment_api.dart';
import 'package:social_network_app_mobile/screens/Moment/moment_pageview.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

class MomentPageHashtag extends StatefulWidget {
  final String hashtag;
  const MomentPageHashtag({Key? key, required this.hashtag}) : super(key: key);

  @override
  State<MomentPageHashtag> createState() => _MomentPageHashtagState();
}

class _MomentPageHashtagState extends State<MomentPageHashtag> {
  dynamic momentHashtag;
  bool isLoading = false;
  bool isMore = true;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    if (mounted && momentHashtag == null) {
      fetchDataHashtag({"limit": 18, "post_type": "moment"});
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        fetchDataHashtag({
          'limit': 6,
          'post_type': 'moment',
          'max_id': momentHashtag['data'].last['id']
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  fetchDataHashtag(params) async {
    if (isMore == false) return;
    setState(() {
      isLoading = true;
    });
    var response =
        await MomentApi().getListMomentHashtag(widget.hashtag, params);

    if (response != null) {
      setState(() {
        isMore = response['data'].length < params['limit'] ? false : true;
        isLoading = false;
        momentHashtag = {
          "meta": response['meta'],
          "data": (momentHashtag?['data'] ?? []) + response['data']
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            AppBarTitle(title: "#${widget.hashtag}"),
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.withOpacity(0.3)),
              child: const Icon(
                Icons.search,
                size: 20,
                color: white,
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Video",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  momentHashtag != null
                      ? Text(
                          "${momentHashtag['meta']?['total'] ?? 0} video",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                        )
                      : const SizedBox()
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      crossAxisCount: 2,
                      childAspectRatio: 0.55),
                  itemCount: (momentHashtag?['data'] ?? []).length,
                  itemBuilder: (context, index) {
                    var object = momentHashtag['data'][index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => Material(
                                      color: Colors.black,
                                      child: MomentPageview(
                                        type: 'hashtag',
                                        momentRender:
                                            momentHashtag?['data'] ?? [],
                                        handlePageChange: (value) {},
                                        initialPage: index,
                                      ),
                                    )));
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: ImageCacheRender(
                                  path: object['media_attachments'][0]
                                      ['preview_url'],
                                  width: (size.width - 12) / 2,
                                  height: (size.width - 12) / 2 +
                                      (size.width - 12) / 4,
                                ),
                              ),
                              Positioned(
                                  bottom: 5,
                                  left: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(
                                            CupertinoIcons.play_arrow,
                                            color: white,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 3.0,
                                          ),
                                          Text(
                                            '123,5k',
                                            style: TextStyle(
                                                color: white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 3.0),
                                      Row(
                                        children: [
                                          AvatarSocial(
                                            height: 26.0,
                                            width: 26.0,
                                            path: (object['page'] ??
                                                    object['account'])[
                                                'avatar_media']['preview_url'],
                                            object: (object['page'] ??
                                                object['account']),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                20,
                                            child: Text(
                                              object['page']?['title'] ??
                                                  object['account']
                                                      ['display_name'],
                                              style: const TextStyle(
                                                  color: white,
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ))
                            ],
                          ),
                          SizedBox(
                            width: size.width / 2 - 6,
                            child: Text(
                              object['content'],
                              maxLines: 2,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            isLoading ? const CupertinoActivityIndicator() : const SizedBox()
          ],
        ),
      ),
    );
  }
}
