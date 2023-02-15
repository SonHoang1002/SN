import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import '../../../constant/event_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../widget/appbar_title.dart';
import 'detail_event_page.dart';

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            GestureDetector(
                onTap: () {
                  popToPreviousScreen(context);
                },
                child: AppBarTitle(title: EventConstants.CANCEL)),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Row(
              children: [
                Text(
                  CreateEventConstants.CREATE_EVENT_TITLE,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    // color:  white
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          _buildCreateEventComponent(
              context,
              DetailEventPage(),
              CreateEventConstants.ONLINE_COMPONENT[0],
              CreateEventConstants.ONLINE_COMPONENT[1],
              CreateEventConstants.ONLINE_COMPONENT[2]),
          SizedBox(
            height: 20,
          ),
          _buildCreateEventComponent(
              context,
              DetailEventPage(),
              CreateEventConstants.LIVE_MEETING_COMPONENT[0],
              CreateEventConstants.LIVE_MEETING_COMPONENT[1],
              CreateEventConstants.LIVE_MEETING_COMPONENT[2]),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (_) => DetailEventPage()));
          //   },
          //   child: GeneralComponent(
          //     [
          //       Container(
          //         height: 40,
          //         width: 40,
          //         margin: EdgeInsets.only(left: 10),
          //         child: Center(
          //             child: Icon(
          //           CreateEventConstants.LIVE_MEETING_COMPONENT[0],
          //           size: 15,
          //           color:  white,
          //         )),
          //         decoration: BoxDecoration(
          //             color: Colors.grey[700],
          //             borderRadius: BorderRadius.all(Radius.circular(20))),
          //       ),
          //       Container(
          //         margin: EdgeInsets.only(top: 5, left: 10),
          //         child: Row(
          //           children: [
          //             Text(CreateEventConstants.LIVE_MEETING_COMPONENT[1],
          //                 style: TextStyle(
          //                   fontSize: 23,
          //                   fontWeight: FontWeight.bold,
          //                   // color:  white
          //                 ))
          //           ],
          //         ),
          //       ),
          //       Container(
          //         margin: EdgeInsets.only(top: 5, left: 10),
          //         child: Wrap(
          //           children: [
          //             Text(CreateEventConstants.LIVE_MEETING_COMPONENT[2],
          //                 style: TextStyle(
          //                   fontSize: 18,
          //                   //  color: Colors.grey
          //                 ))
          //           ],
          //         ),
          //       ),
          //     ],
          //     suffixWidget: Container(
          //       alignment: Alignment.centerRight,
          //       margin: EdgeInsets.only(right: 10),
          //       child: Icon(
          //         EventConstants.ICON_DATA_NEXT,
          //         // color:  white,
          //       ),
          //     ),
          //     changeBackground: Colors.grey[500],
          //   ),
          // )
        ]),
      ),
    );
  }
}

_buildCreateEventComponent(
  BuildContext context,
  Widget newScreen,
  IconData iconData,
  String title,
  String content,
) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => newScreen));
    },
    child: GeneralComponent(
      [
        Container(
          height: 40,
          width: 40,
          margin: EdgeInsets.only(left: 10),
          child: Center(
              child: Icon(
            iconData,
            size: 15,
            color: white,
          )),
          decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        Container(
          margin: EdgeInsets.only(top: 5, left: 10),
          child: Row(
            children: [
              Text(title,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    // color:  white
                  ))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5, left: 10),
          child: Wrap(
            children: [
              Text(content,
                  style: TextStyle(
                    fontSize: 18,
                    //  color: Colors.grey
                  ))
            ],
          ),
        ),
      ],
      suffixWidget: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(right: 10),
        child: Icon(
          EventConstants.ICON_DATA_NEXT,
          // color:  white,
        ),
      ),
      changeBackground: Colors.grey[500],
    ),
  );
}
