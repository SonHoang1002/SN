import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constant/event_constants.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/information_component_widget.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
showBottomSheetEventWithFacebookLive(BuildContext context, double width) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 350,
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15))),
          child: Column(children: [
            // icon horizontal
            Container(
              padding: EdgeInsets.only(top: 5),
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15))),
              ),
            ),
            // event with facebook live title
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Center(
                    child: Text(
                      LocationEventConstants.EVENT_WITH_FACEBOOK_LIVE_TITLE,
                      style: TextStyle(color: white, fontSize: 18),
                    ),
                  )),
                ],
              ),
            ),
            // divider
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(
                height: 2,
                color: white,
              ),
            ),
            // content
            Container(
              height: 235,
              child: ListView.builder(
                  itemCount: LocationEventConstants
                      .EVENT_WITH_FACEBOOK_LIVE_CONTENT_LIST.length,
                  itemBuilder: ((context1, index) {
                    return GeneralComponent(
                      [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            LocationEventConstants
                                    .EVENT_WITH_FACEBOOK_LIVE_CONTENT_LIST[
                                index][1],
                            style: TextStyle(
                                color: white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            LocationEventConstants
                                    .EVENT_WITH_FACEBOOK_LIVE_CONTENT_LIST[
                                index][2],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                      prefixWidget: Container(
                        margin: EdgeInsets.only(right: 5),
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(
                            LocationEventConstants
                                    .EVENT_WITH_FACEBOOK_LIVE_CONTENT_LIST[
                                index][0],
                            color: white,
                            fit: BoxFit.scaleDown),
                      ),
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    );
                  })),
            ),
            // button
            Container(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(fixedSize: Size(width, 30)),
                  child: Text(
                    "Đã hiểu",
                    style: TextStyle(color: white),
                  )),
            )
          ]),
        );
      });
}
