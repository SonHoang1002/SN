import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
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
  @override
  Widget build(BuildContext context) {
    List reefList = widget.reefList;
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.52,
      padding: EdgeInsets.zero,
      child: buildPageView(reefList, size),
    );
  }

  Widget buildPageView(List reefList, Size size) {
    return SizedBox(
      height: size.height * 0.5,
      child: PageView.builder(
        controller: PageController(
          viewportFraction: 0.6,
          initialPage: 0,
        ),
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
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
                            type: 'momentFeed',
                            moment: reefList[index],
                            isPlayBack: true,
                          ),
                          Container(
                              height: size.height * 0.5,
                              width: size.width * 0.55,
                              color: transparent)
                        ],
                      )
                    : Image.network(
                        reefList[index]["media_attachments"][0]["preview_url"],
                        fit: BoxFit.cover,
                        height: size.height * 0.5,
                        width: size.width * 0.55,
                      ),
              ),
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
      ),
    );
  }

  Widget buildCarousel(List reefList, Size size) {
    return CarouselSlider(
      items: reefList.map((child) {
        int index = reefList.indexOf(child);
        return GestureDetector(
          onTap: () {
            pushToNextScreen(
                context,
                Moment(
                  dataAdditional: reefList[index],
                ));
          },
          child: Container(
            height: size.height * 0.52,
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
                          type: 'momentFeed',
                          moment: reefList[index],
                          isPlayBack: true,
                        ),
                        Container(
                            height: size.height * 0.52,
                            width: size.width * 0.55,
                            color: transparent)
                      ],
                    )
                  : ExtendedImage.network(
                      reefList[index]["media_attachments"][0]["preview_url"],
                      fit: BoxFit.fitHeight,
                    ),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
          enableInfiniteScroll: false,
          viewportFraction: 0.6,
          height: size.height * 0.52,
          onPageChanged: (value, reason) {
            setState(() {
              currentActiveVideo = value;
            });
          }),
    );
  }
}
