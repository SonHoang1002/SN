import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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
          return currentActiveVideo != index
              ? ReefItem(reefData: _reefList[index])
              : Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: size.height * 0.45,
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: greyColor, width: 0.1)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(_reefList[index]["media_attachments"]
                        [0]["preview_url"]),
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
