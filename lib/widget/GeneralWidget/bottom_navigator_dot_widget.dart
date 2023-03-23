import 'package:flutter/material.dart';

import '../../helper/push_to_new_screen.dart';
import '../../theme/colors.dart';

Widget buildBottomNavigatorDotWidget(BuildContext context, int allNumberDot,
    int currentDot, String buttonTitle, Widget destinationWidget) {
  return Container(
    height: 80,
    color: transparent,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        height: 20,
        padding: EdgeInsets.only(left: 15),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: allNumberDot,
            itemBuilder: ((context, index) {
              return Container(
                margin: EdgeInsets.only(right: 5),
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: index == currentDot - 1
                        ? Colors.blue
                        : Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              );
            })),
      ),
      Container(
          margin: EdgeInsets.only(right: 10),
          child: ElevatedButton(
            onPressed: (() {
              pushToNextScreen(context, destinationWidget);
            }),
            child: Text(buttonTitle),
          ))
    ]),
  );
}
