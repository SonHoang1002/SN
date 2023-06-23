import 'dart:math';

import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/reaction.dart';
import 'package:social_network_app_mobile/screens/Watch/WatchDetail/watch_detail.dart';

/// animation widget to display reaction icons tranfer from bottom to top on constant distances
class AnimatedFlyIconWidget extends StatefulWidget {
  final String reactName;
  final Function? onEnd;
  const AnimatedFlyIconWidget({super.key, required this.reactName, this.onEnd});

  @override
  State<AnimatedFlyIconWidget> createState() => _AnimatedFlyIconWidgetState();
}

class _AnimatedFlyIconWidgetState extends State<AnimatedFlyIconWidget> {
  GlobalKey _animationKey = GlobalKey();
  bool iconFlying = false;
  Offset? offset;
  bool isShowAnimatedReactionIcon = false;
  Size? size;
  double deltaHorizontal = double.parse(Random().nextInt(200).toString());
  // double deltaVertical= double.parse(Random().nextInt(40).toString());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size ??= MediaQuery.of(context).size;
    // if (offset != null) {
    //   final box =
    //       _animationKey.currentContext?.findRenderObject() as RenderBox?;
    //   offset = box?.localToGlobal(Offset.zero);
    // }
    isShowAnimatedReactionIcon = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        iconFlying = true;
      });
    });
    return animationWidget();
  }

  Widget animationWidget() {
    return AnimatedPositioned(
      key: _animationKey,
      onEnd: () { 
        // setState(() {
        //   isShowAnimatedReactionIcon = false;
        // });
        widget.onEnd != null ? widget.onEnd!() : null;
      },
      duration: const Duration(milliseconds: 2000),
      left: iconFlying ? (250 + deltaHorizontal) : (210 + deltaHorizontal),
      top: iconFlying
          ? (size!.height - (size!.height / 5.2) - 220)
          : size!.height - 220,
      child: isShowAnimatedReactionIcon
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              // curve: Curves.easeInOut,
              height: 100,
              width:
                  // iconFlying ? 30 :
                  100,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 700),
                opacity: 1.0,
                child: Stack(
                  children: [
                    renderGif('gif', widget.reactName,
                        size: getSizeGif(widget.reactName)),
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
