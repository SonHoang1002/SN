import 'package:flutter/material.dart';
import 'package:market_place/constant/config.dart';

import 'messenger_app_bar/app_bar_network_rounded_image.dart';

class AppBarGroup extends StatelessWidget {
  final dynamic objectItem;
  final double width;
  final double height;
  final double childWidth;
  final double childHeight;
  const AppBarGroup(
      {Key? key,
      this.objectItem,
      required this.width,
      required this.height,
      required this.childWidth,
      required this.childHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var roomUser =
        objectItem['room'] != null ? objectItem['room']['usernames'] : null;
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: roomUser == null &&
              (objectItem['members'] == null ||
                  objectItem['members']!.length == 1)
          ? const SizedBox()
          : Stack(
              children: [
                Positioned(
                    bottom: 3,
                    left: 3,
                    child: AppBarNetworkRoundedImage(
                        width: childWidth,
                        height: childHeight,
                        imageUrl: roomUser != null
                            ? '$urlRocketChat/avatar/${roomUser[0]}'
                            : '$urlRocketChat/avatar/${objectItem['members'][0]['username']}')),
                Positioned(
                    top: 3,
                    right: 3,
                    child: AppBarNetworkRoundedImage(
                      width: childWidth,
                      height: childHeight,
                      imageUrl: roomUser != null
                          ? '$urlRocketChat/avatar/${roomUser[1]}'
                          : '$urlRocketChat/avatar/${objectItem['members']?[1]?['username'] ?? objectItem['members']?[0]?['username']}',
                    ))
              ],
            ),
    );
  }
}
