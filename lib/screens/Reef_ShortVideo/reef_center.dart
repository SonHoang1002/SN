import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Moment/moment.dart';
import 'package:social_network_app_mobile/screens/Moment/moment_video.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class ReefCenter extends StatefulWidget {
  final List reefList;
  const ReefCenter({required this.reefList, super.key});

  @override
  State<ReefCenter> createState() => _ReefCenterState();
}

class _ReefCenterState extends State<ReefCenter> {
  bool isScrollToLimit = true;
  int currentActiveVideo = 0;
  final _controller = PageController(initialPage: 0, viewportFraction: 0.6);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List reefList = widget.reefList;
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height * 0.45,
      padding: EdgeInsets.zero,
      child: buildPageView(reefList, size),
    );
  }

  Widget buildPageView(List reefList, Size size) {
    return PageView.builder(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      itemCount: reefList.length,
      padEnds: isScrollToLimit ? false : true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () {
            pushToNextScreen(
                context,
                Moment(
                  dataAdditional: reefList[index],
                  isBack: true,
                ));
          },
          child: Container(
            margin: const EdgeInsets.only(
              right: 10,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: greyColor, width: 0.3)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    MomentVideo(
                      type: 'momentFeed',
                      moment: reefList[index],
                      isPlayBack: true,
                    ),
                    Container(height: size.height * 0.45, color: transparent),
                    if (currentActiveVideo != index)
                      SizedBox(
                        height: size.height * 0.45,
                        child: Image.network(
                          reefList[index]["media_attachments"][0]
                              ["preview_url"],
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                )),
          ),
        );
      },
      onPageChanged: (value) {
        if (isScrollToLimit == false &&
            (value == 0 || value == widget.reefList.length)) {
          setState(() {
            isScrollToLimit = true;
          });
        } else {
          if (isScrollToLimit == true) {
            setState(() {
              isScrollToLimit = false;
            });
          }
        }
        setState(() {
          currentActiveVideo = value;
        });
      },
    );
  }
}
