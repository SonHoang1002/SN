import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Moment/moment.dart';
import 'package:social_network_app_mobile/screen/Moment/moment_video.dart';
import 'package:social_network_app_mobile/screen/Reef_ShortVideo/reef_item.dart';
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
  @override
  Widget build(BuildContext context) {
    List _reefList = widget.reefList;
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.45,
      padding: EdgeInsets.zero,
      child: PageView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: _reefList.length,
        padEnds: false,
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              pushToNextScreen(
                  context,
                  Moment(
                    dataFromReef: _reefList[index],
                  ));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              height: size.height * 0.45,
              width: size.width * 0.55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: greyColor, width: 0.3)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: currentActiveVideo == index
                    ? Stack(
                        children: [
                          MomentVideo(
                            moment: _reefList[index],
                          ),
                          Container(
                              height: size.height * 0.45,
                              width: size.width * 0.55,
                              color: transparent)
                        ],
                      )
                    : Image.network(
                        _reefList[index]["media_attachments"][0]["preview_url"],
                        fit: BoxFit.fitWidth,
                      ),
              ),
            ),
          );
        },
        onPageChanged: (value) {
          if (isScrollToLimit == false &&
              (value == 0
              // || value == widget.reefList.length - 1
              )) {
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
        controller: PageController(
          viewportFraction: 0.6,
          initialPage: 0,
        ),
      ),
    );
  }
}
