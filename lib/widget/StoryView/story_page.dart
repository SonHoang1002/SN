import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/StoryView/controller/story_controller.dart';

import 'widgets/story_view.dart';

class StoryPage extends StatefulWidget {
  final dynamic story;
  const StoryPage({Key? key, this.story}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List medias = widget.story['medias'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(
          top: 40,
        ),
        child: StoryView(
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
