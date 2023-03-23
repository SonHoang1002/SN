import 'package:flutter/material.dart';

import '../../../constant/event_constants.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../widget/back_icon_appbar.dart';

class SettingEventPage extends StatefulWidget {
  @override
  State<SettingEventPage> createState() => _SettingEventPageState();
}

class _SettingEventPageState extends State<SettingEventPage> {
  bool switchValue = false;

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
            BackIconAppbar(),
            SizedBox(),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          // setting title
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Text(
                  SettingEventConstants.SETTING_TITLE,
                  style: const TextStyle(
                      // color:  white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // co-organizer part
          Container(
            // color: Colors.red,
            child: GeneralComponent(
              [
                Text(
                  SettingEventConstants.CO_ORGANIZER[1],
                  style: TextStyle(
                      // color:  white,
                      fontSize: 15),
                ),
              ],
              prefixWidget: Container(
                  height: 30,
                  width: 30,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Icon(
                    SettingEventConstants.CO_ORGANIZER[0],
                    color: white,
                    size: 15,
                  )),
              suffixWidget: Icon(
                EventConstants.ICON_DATA_NEXT,
                // color: Colors.grey,
                size: 20,
              ),
              changeBackground: transparent,
              padding: EdgeInsets.only(top: 15, bottom: 15),
            ),
          ),

          // this below widget only will be shown when user choose live meeting room method from location, include share link and description
          // share link
          Container(
            child: GeneralComponent(
              [
                Container(
                  width: 280,
                  child: Text(
                    SettingEventConstants.SHARE_LINK_CONTENT,
                    style: TextStyle(
                        // color:  white,
                        fontSize: 17),
                  ),
                ),
              ],
              suffixWidget: Switch(
                thumbColor:
                    MaterialStateProperty.resolveWith((states) => Colors.blue),
                onChanged: (value) {
                  setState(() {
                    switchValue = !switchValue;
                  });
                },
                value: switchValue,
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2.5),
              changeBackground: transparent,
            ),
          ),

          // description for share link function
          Container(
            // margin: EdgeInsets.only(top: 5),
            child: Wrap(
              children: [
                Text(
                  SettingEventConstants.DESCRIPTION_FOR_SHARE_LINK_CONTENT,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
