import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/screen/Moment/moment_pageview.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class MomentPageProfile extends StatefulWidget {
  final dynamic object;
  final String objectType;

  const MomentPageProfile({Key? key, this.object, required this.objectType})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MomentPageProfileState createState() => _MomentPageProfileState();
}

class _MomentPageProfileState extends State<MomentPageProfile> {
  List listVideos = [];
  bool isLoading = false;
  bool isMore = true;
  late ScrollController scrollController;

  @override
  initState() {
    super.initState();
    scrollController = ScrollController();

    fetchVideoMoment({
      'limit': 18,
    });

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        fetchVideoMoment({'limit': 6, 'max_id': listVideos.last['id']});
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  fetchVideoMoment(params) async {
    if (isMore == false) return;
    setState(() {
      isLoading = true;
    });
    dynamic response;
    if (widget.objectType == 'page') {
      response = await PostApi().getListMomentPage(widget.object['id']);
    } else {
      response = await PostApi().getListMomentUser(widget.object['id']);
    }
    if (response != null) {
      setState(() {
        isLoading = false;
        listVideos = listVideos + response;
        isMore = response.length < params['limit'] ? false : true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List dataInfo = [
      {"count": "8", "description": "Đang theo dõi"},
      {"count": "118.7k", "description": "Người theo dõi"},
    ];

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              AppBarTitle(
                  title: widget.object[
                      widget.objectType == 'page' ? 'title' : 'display_name']),
              const SizedBox()
            ],
          )),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AvatarSocial(
              width: 100.0,
              height: 100.0,
              object: widget.object,
              path: widget.object['avatar_media']['preview_url'],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Text(
              widget.object[
                  widget.objectType == 'page' ? 'title' : 'display_name'],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  dataInfo.length,
                  (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              dataInfo[index]['count'],
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              dataInfo[index]['description'],
                              style: const TextStyle(
                                  color: greyColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )),
            ),
            const SizedBox(
              height: 12.0,
            ),
            SizedBox(
              width: 200,
              child: ButtonPrimary(
                label: "Theo dõi",
                handlePress: () {},
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            GridView.builder(
                shrinkWrap: true,
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    crossAxisCount: 3,
                    childAspectRatio: 0.7),
                itemCount: listVideos.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Material(
                                    child: MomentPageview(
                                      momentRender: listVideos,
                                      handlePageChange: (value) {},
                                      initialPage: index,
                                    ),
                                  )));
                    },
                    child: Stack(
                      children: [
                        ImageCacheRender(
                          path: listVideos[index]['media_attachments'][0]
                              ['preview_url'],
                          width: (MediaQuery.of(context).size.width - 4) / 3,
                        ),
                        Positioned(
                            bottom: 5,
                            left: 5,
                            child: Row(
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
                            ))
                      ],
                    ),
                  );
                }),
            isLoading ? const CupertinoActivityIndicator() : const SizedBox()
          ],
        ),
      ),
    );
  }
}
