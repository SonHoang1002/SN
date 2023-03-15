import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PagePickMedia extends StatefulWidget {
  final dynamic user;
  final Function handleAction;
  const PagePickMedia({Key? key, this.user, required this.handleAction})
      : super(key: key);

  @override
  State<PagePickMedia> createState() => _PagePickMediaState();
}

class _PagePickMediaState extends State<PagePickMedia> {
  List medias = [];
  bool isLoading = false;
  bool isMore = true;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (medias.isEmpty && mounted && widget.user != null) {
      fetchMediaUser({"limit": 21, "media_type": 'image'});
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        fetchMediaUser(
            {"limit": 21, "media_type": 'image', "max_id": medias.last['id']});
      }
    });
  }

  fetchMediaUser(params) async {
    if (!isMore) return;
    setState(() {
      isLoading = true;
    });
    var response = await UserPageApi().getUserMedia(widget.user['id'], params);
    if (response != null) {
      setState(() {
        isMore = response.length < params['limit'] ? false : true;
        isLoading = false;
        medias = medias + response;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              const AppBarTitle(title: "Ảnh trên Emso"),
              Container()
            ],
          ),
        ),
        body: medias.isEmpty
            ? const Center(
                child: Text("Không có hình ảnh để hiển thị"),
              )
            : SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.vertical,
                child: GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      crossAxisCount: 3,
                    ),
                    itemCount: medias.length + 1,
                    itemBuilder: (context, index) {
                      return index < medias.length
                          ? GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                widget.handleAction('image', medias[index]);
                              },
                              child:
                                  ImageCacheRender(path: medias[index]['url']),
                            )
                          : const Center(
                              child: CupertinoActivityIndicator(),
                            );
                    })));
  }
}
