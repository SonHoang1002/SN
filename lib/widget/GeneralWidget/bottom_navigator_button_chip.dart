import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

buildBottomNavigatorWithButtonAndChipWidget(
    {required BuildContext context,
    required double width,
    required int currentPage,
    required String title,
    required bool isPassCondition,
    dynamic loading,
    Widget? newScreen,
    Function? function}) {
  return SizedBox(
    height: 70,
    // color: Colors.black87,
    child: Column(children: [
      Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(width * 0.9, 40),
                backgroundColor:
                    isPassCondition ? secondaryColor : Colors.grey),
            onPressed: () {
              if (function != null && isPassCondition) {
                function();
              } else if (isPassCondition && newScreen != null) {
                pushToNextScreen(context, newScreen);
              }
            },
            child: loading == true
                ? const CupertinoActivityIndicator()
                : Text(title)),
      ),
      const SizedBox(
        height: 5,
      ),
      Center(
          child: SizedBox(
        height: 6,
        width: width * 0.9,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: ((context, index) {
              return Container(
                margin: EdgeInsets.fromLTRB(
                    index == 0 ? 0 : 5, 0, index == 6 ? 0 : 5, 0),
                width: width * 0.10555,
                // height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color:
                      index < currentPage ? secondaryColor : Colors.grey[800],
                ),
              );
            })),
      ))
    ]),
  );
}
