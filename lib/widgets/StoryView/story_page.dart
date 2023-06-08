import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/widgets/StoryView/controller/story_controller.dart';

import 'widgets/story_view.dart';

class StoryPage extends StatefulWidget {
  final dynamic story;
  final dynamic user;
  const StoryPage({Key? key, this.story, this.user}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final storyController = StoryController();
  List medias = [];

  @override
  void initState() {
    if (mounted && widget.user != null && widget.story != null) {
      fetchMediaStory();
    }
    super.initState();
  }

  fetchMediaStory() async {
    var response = await UserPageApi()
        .getUserFeatureContentMedia(widget.user['id'], widget.story['id']);
    if (response != null) {
      setState(() {
        medias = response;
      });
    }
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(
          top: 40,
        ),
        child: medias.isEmpty
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : StoryView(
                medias: medias,
                storyItems: List.generate(
                    medias.length,
                    (index) => medias[index]['type'] == 'image'
                        ? StoryItem.pageImage(
                            url: medias[index]['url'],
                            controller: storyController,
                          )
                        : StoryItem.pageVideo(
                            url: medias[index]['url'],
                            controller: storyController,
                          )),
                onStoryShow: (s) {},
                onComplete: () {
                  Navigator.pop(context);
                },
                progressPosition: ProgressPosition.top,
                repeat: false,
                controller: storyController,
              ),
      ),
    );
  }
}
