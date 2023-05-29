import 'package:flutter/material.dart';
import 'package:market_place/helpers/routes.dart';

buildBottomNavigatorWithButtonAndChipWidget(
    {required BuildContext context,
    required double width,
    required int currentPage,
    required String title,
    required bool isPassCondition,
    Widget? newScreen,
    Function? function}) {
  return Container(
    height: 70,
    // color: Colors.black87,
    child: Column(children: [
      Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(width * 0.9, 40),
                backgroundColor: isPassCondition ? Colors.blue : Colors.grey),
            onPressed: () {
              // function != null ? function() : null;
              newScreen != null ? pushToNextScreen(context, newScreen) : null;
            },
            child: Text(title)),
      ),
      const SizedBox(
        height: 5,
      ),
      Center(
          child: Container(
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
                  color: index < currentPage ? Colors.blue : Colors.grey[800],
                ),
              );
            })),
      ))
    ]),
  );
}
