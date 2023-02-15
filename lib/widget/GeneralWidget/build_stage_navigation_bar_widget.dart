import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';

buildStageNavigatorBar(
    {required bool isPassCondition,
    required String title,
    required double width,
    Function? function,
    int? currentPage = 0,
    bool? isHaveStageNavigatorBar = true}) {
  return Container(
    height: 85,
    child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      isHaveStageNavigatorBar!
          ? Container(
              child: Column(
                children: [
                  // Divider(
                  //   height: 4,
                  //   color: Colors.white,
                  // ),
                  buildSpacer(height: 10),
                  Center(
                      child: Container(
                    height: 6,
                    width: width * 0.9,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: ((context, index) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(
                                index == 0 ? 0 : 5, 0, index == 4 ? 0 : 5, 0),
                            width: (width * 0.9 - 4 * 7) / 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: index <= currentPage! - 1
                                  ? Colors.blue
                                  : Colors.grey[800],
                            ),
                          );
                        })),
                  )),
                ],
              ),
            )
          : Container(),
      Container(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(width * 0.9, 40),
                      backgroundColor:
                          isPassCondition ? Colors.blue : Colors.grey[800]),
                  onPressed: () {
                    function != null ? function() : null;
                  },
                  child: Text(title)),
            ),
            buildSpacer(height: 5),
          ],
        ),
      ),
    ]),
  );
}
