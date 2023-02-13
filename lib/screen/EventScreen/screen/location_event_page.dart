import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constant/event_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/build_stage_navigation_bar_widget.dart';
import '../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/appbar_title.dart';
import '../../../widget/back_icon_appbar.dart';
import '../widget/event_with_facebook_live_event.dart';
import 'description_event_page.dart';

class LocationEventPage extends StatefulWidget {
  const LocationEventPage({super.key});

  @override
  State<LocationEventPage> createState() => _LocationEventPageState();
}

class _LocationEventPageState extends State<LocationEventPage> {
  bool isOutsideLink = false;
  bool isDifferent = false;
  bool isLiveMeetingRoomSelection = false;
  bool isFacebookLiveSelection = false;
  late double width = 0;
  late double height = 0;
  late TextEditingController _urlController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
            GestureDetector(
                onTap: () {
                  popToPreviousScreen(
                    context,
                  );
                },
                child: AppBarTitle(title: "Hủy")),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            Expanded(
                child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        LocationEventConstants.LOCATION_EVENT_TITLE,
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          // color:  white
                        ),
                      ),
                    ],
                  ),
                ),
                // ---------------------------------ONLINE--------------------------------------
                Container(
                  child: Row(
                    children: [
                      Text(
                        LocationEventConstants.ONLINE_LOCATION_EVENT_SUBTITLE,
                        style: TextStyle(
                          fontSize: 16,
                          // color:  white
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------------------------------ONLINE--------------------------------------

                // ---------------------------------OFFLINE--------------------------------------
                // Container(
                //   child: Row(
                //     children: [
                //       Text(
                //         LocationEventConstants.OFFLINE_LOCATION_EVENT_SUBTITLE,
                //         style:
                //             TextStyle(fontSize: 16, color:  white),
                //       ),
                //     ],
                //   ),
                // ),
                //space
                // SizedBox(
                //   height: 10,
                // ),
                // // select location from map in bottom sheet
                // Container(
                //   height: 50,
                //   child: TextFormField(
                //     readOnly: true,
                //     onTap: () {
                //       _showBottomSheetSelectLocation(context);
                //     },
                //     // controller:  ???,
                //     style: TextStyle(color:  white),
                //     decoration: InputDecoration(
                //         enabledBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: Colors.grey),
                //             borderRadius:
                //                 BorderRadius.all(Radius.circular(5))),
                //         focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: Colors.blue),
                //             borderRadius:
                //                 BorderRadius.all(Radius.circular(5))),
                //         contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                //         border: InputBorder.none,
                //         hintText: LocationEventConstants
                //             .OFFLINE_PLACEHOLDER_EVENT[0],
                //         labelStyle: TextStyle(color:  white),
                //         hintStyle: TextStyle(color:  white)),
                //   ),
                // ),

                // ---------------------------------OFFLINE--------------------------------------

                buildSpacer(height: 10),
                // meeting room
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (_) => DetailEventPage()));
                    setState(() {
                      isDifferent = isOutsideLink = false;
                      isLiveMeetingRoomSelection = true;
                      isFacebookLiveSelection = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: isLiveMeetingRoomSelection
                                ? Colors.blue
                                : transparent)),
                    child: GeneralComponent(
                      [
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 10),
                          child: Row(
                            children: [
                              Text(
                                  LocationEventConstants
                                      .MEETING_ROOM_COMPONENT[1],
                                  style: TextStyle(
                                    fontSize: 16,
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
                              Text(
                                  LocationEventConstants
                                      .MEETING_ROOM_COMPONENT[2],
                                  style: TextStyle(
                                    fontSize: 15,
                                    //  color: Colors.grey
                                  ))
                            ],
                          ),
                        ),
                      ],
                      prefixWidget: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 10),
                        child: LocationEventConstants.MEETING_ROOM_COMPONENT[0]
                                is String
                            ? SvgPicture.asset(
                                LocationEventConstants
                                    .MEETING_ROOM_COMPONENT[0],
                                color: white,
                              )
                            : Icon(
                                LocationEventConstants
                                    .MEETING_ROOM_COMPONENT[0],
                                size: 15,
                                color: white,
                              ),
                        decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      changeBackground: Colors.grey[500],
                    ),
                  ),
                ),
                buildSpacer(height: 15),
                // facebook live
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (_) => DetailEventPage()));
                    setState(() {
                      isDifferent = isOutsideLink = false;
                      isLiveMeetingRoomSelection = false;
                      isFacebookLiveSelection = true;
                    });
                    showBottomSheetEventWithFacebookLive(context, width);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: isFacebookLiveSelection
                                ? Colors.blue
                                : transparent)),
                    child: GeneralComponent(
                      [
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 10),
                          child: Row(
                            children: [
                              Text(
                                  LocationEventConstants
                                      .FACEBOOK_LIVE_COMPONENT[1],
                                  style: TextStyle(
                                    fontSize: 16,
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
                              Text(
                                  LocationEventConstants
                                      .FACEBOOK_LIVE_COMPONENT[2],
                                  style: TextStyle(
                                    fontSize: 15,
                                    // color: Colors.grey
                                  ))
                            ],
                          ),
                        ),
                      ],
                      prefixWidget: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 10),
                        child: LocationEventConstants.FACEBOOK_LIVE_COMPONENT[0]
                                is String
                            ? SvgPicture.asset(
                                LocationEventConstants
                                    .FACEBOOK_LIVE_COMPONENT[0],
                                color: white,
                                height: 5,
                                width: 5,
                                fit: BoxFit.scaleDown)
                            : Icon(
                                LocationEventConstants
                                    .FACEBOOK_LIVE_COMPONENT[0],
                                size: 15,
                                color: white,
                              ),
                        decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      changeBackground: Colors.grey[500],
                    ),
                  ),
                ),
                buildSpacer(height: 30),
                // different selection
                isDifferent == false && isOutsideLink == false
                    ? GestureDetector(
                        onTap: () {
                          showBottomSheetDifferentSelection(context);
                        },
                        child: Center(
                            child: Text(
                          LocationEventConstants.ADD_PRIVATE_LINK,
                          style: TextStyle(color: Colors.blue),
                        )),
                      )
                    : Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocationEventConstants.DIFFERENT_SELECTION,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  // color:  white
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showBottomSheetDifferentSelection(context);
                                },
                                child: Text(
                                  LocationEventConstants.CHANGE_SELECTION,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue),
                                ),
                              ),
                            ]),
                      ),
                isDifferent
                    ? _buildSingleDifferentSelectionComponent(
                        LocationEventConstants.DIFFERENT_SELECTION_COMPONENT[1],
                        onSheet: false)
                    : Container(),
                isOutsideLink
                    ? _buildSingleDifferentSelectionComponent(
                        LocationEventConstants.DIFFERENT_SELECTION_COMPONENT[0],
                        addtionalWidget: Container(
                          height: 70,
                          margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                          child: TextFormField(
                            onTap: (() {
                              // if (validateUrlLink(_urlController.text)) {}
                            }),
                            controller: _urlController,
                            style: TextStyle(
                                // color:  white
                                ),
                            decoration: InputDecoration(
                                fillColor: white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  // borderSide: BorderSide(
                                  //     color: validateUrlLink(
                                  //             _urlController.text.trim())
                                  //         ? Colors.blue
                                  //         : Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                hintText: "URL liên kết",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        onSheet: false)
                    : Container(),
              ],
            )),
            // bottom button

            buildStageNavigatorBar(
                width: width,
                currentPage: 2,
                isPassCondition: (isDifferent ||
                    isFacebookLiveSelection ||
                    isLiveMeetingRoomSelection ||
                    (isOutsideLink && _urlController.text.trim() != "")),
                title: EventConstants.NEXT,
                function: () {
                  if (isDifferent ||
                      isFacebookLiveSelection ||
                      isLiveMeetingRoomSelection ||
                      (isOutsideLink && _urlController.text.trim() != "")) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DescriptionEventPage()));
                  }
                })
          ]),
        ),
      ),
    );
  }

  showBottomSheetDifferentSelection(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.black87,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 270,
            decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Column(children: [
              //drag icon
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
              // title
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: Center(
                      child: Text(
                        LocationEventConstants.DIFFERENT_SELECTION,
                        style: TextStyle(color: white, fontSize: 18),
                      ),
                    )),
                  ],
                ),
              ),
              Divider(
                height: 10,
                color: white,
              ),
              //content
              Container(
                  height: 200,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: (() {
                          Navigator.of(context).pop();
                          if (LocationEventConstants
                                  .DIFFERENT_SELECTION_COMPONENT[index][1] ==
                              "Khác") {
                            setState(() {
                              isDifferent = true;
                              isOutsideLink = false;
                              isFacebookLiveSelection =
                                  isLiveMeetingRoomSelection = false;
                            });
                            return;
                          }
                          setState(() {
                            isDifferent = false;
                            isOutsideLink = true;
                            isFacebookLiveSelection =
                                isLiveMeetingRoomSelection = false;
                          });
                          // Navigator.of(context).pop();
                          return;
                        }),
                        child: _buildSingleDifferentSelectionComponent(
                            LocationEventConstants
                                .DIFFERENT_SELECTION_COMPONENT[index],
                            onSheet: true),
                      );
                    }),
                  ))
            ]),
          );
        });
  }

  Widget _buildSingleDifferentSelectionComponent(List<dynamic> value,
      {Widget? addtionalWidget, bool? onSheet = false}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: GeneralComponent(
        [
          Container(
            margin: EdgeInsets.only(top: 5, left: 10),
            child: Row(
              children: [
                onSheet == true
                    ? Text(value[1],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: white))
                    : Text(value[1],
                        style: TextStyle(
                          fontSize: 16,
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
                onSheet == true
                    ? Text(value[2],
                        style: TextStyle(fontSize: 15, color: Colors.grey))
                    : Text(value[2],
                        style: TextStyle(
                          fontSize: 15,
                          //  color: Colors.grey
                        ))
              ],
            ),
          ),
          addtionalWidget ?? Container()
        ],
        prefixWidget: Container(
          height: 40,
          width: 40,
          margin: EdgeInsets.only(left: 10),
          child: Center(
              child: value[0] is String
                  ? Container(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset(
                        value[0],
                        color: white,
                      ),
                    )
                  : Icon(
                      value[0],
                      size: 15,
                      color: white,
                    )),
          decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        changeBackground: onSheet == true ? Colors.grey[800] : Colors.grey[500],
        // padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
      ),
    );
  }

  bool validateUrlLink(String input) {
    RegExp exp =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    return (exp.hasMatch(input));
  }
}


  // _showBottomSheetSelectLocation(BuildContext context) {
  //   showModalBottomSheet(
  //       backgroundColor: transparent,
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, setStateFull) {
  //           return Container(
  //             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //             height: 500,
  //             decoration: BoxDecoration(
  //                 color: Colors.grey[900],
  //                 borderRadius: BorderRadius.only(
  //                     topRight: Radius.circular(15),
  //                     topLeft: Radius.circular(15))),
  //             child: Column(children: [
  //               Container(
  //                 padding: EdgeInsets.only(top: 5),
  //                 child: Container(
  //                   height: 4,
  //                   width: 40,
  //                   decoration: BoxDecoration(
  //                       color: Colors.grey,
  //                       borderRadius: BorderRadius.only(
  //                           topRight: Radius.circular(15),
  //                           topLeft: Radius.circular(15))),
  //                 ),
  //               ),
  //               Container(
  //                 margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Container(
  //                         child: Center(
  //                       child: Text(
  //                         LocationEventConstants.OFFLINE_PRIVATE_OF_EVENT,
  //                         style: TextStyle(color:  white, fontSize: 18),
  //                       ),
  //                     )),
  //                   ],
  //                 ),
  //               ),
  //               // divider
  //               Divider(
  //                 height: 4,
  //                 color:  white,
  //               ),
  //               // find location input
  //               Container(
  //                 margin: EdgeInsets.symmetric(vertical: 10),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Container(
  //                       height: 40,
  //                       width: 290,
  //                       child: TextFormField(
  //                         onChanged: ((value) {}),
  //                         textAlign: TextAlign.left,
  //                         style: const TextStyle(color:  white),
  //                         decoration: InputDecoration(
  //                             prefixIcon: Icon(
  //                               FontAwesomeIcons.search,
  //                               color: Colors.grey,
  //                               size: 13,
  //                             ),
  //                             fillColor: Colors.grey[800],
  //                             filled: true,
  //                             contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
  //                             hintText: LocationEventConstants
  //                                 .OFFLINE_PLACEHOLDER_EVENT[1],
  //                             hintStyle:
  //                                 TextStyle(color: Colors.grey, fontSize: 14),
  //                             border: OutlineInputBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(20)))),
  //                       ),
  //                     ),
  //                      buildSpacer(height: 5),
  //                     Container(
  //                         height: 40,
  //                         width: 40,
  //                         padding: EdgeInsets.all(5),
  //                         margin: EdgeInsets.only(left: 10),
  //                         child: Center(
  //                           child: Container(
  //                               height: 20,
  //                               width: 20,
  //                               // child: SvgPicture.asset(
  //                               //   EventConstants.PATH_ICON + "camera_plus_icon.svg",
  //                               //   color:  white,
  //                               // ),
  //                               child: Icon(
  //                                 CupertinoIcons.location,
  //                                 color:  white,
  //                                 size: 14,
  //                               )),
  //                         ),
  //                         decoration: BoxDecoration(
  //                             color: Colors.grey[700],
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(20)))),
  //                   ],
  //                 ),
  //               ),
  //               // divider
  //               Divider(
  //                 height: 4,
  //                 color:  white,
  //               ),
  //               // img example for location
  //               Container(
  //                   height: 100,
  //                   width: 200,
  //                   margin: EdgeInsets.symmetric(vertical: 10),
  //                   child: Image.asset(
  //                     EventConstants.PATH_IMG + "back_1.jpg",
  //                     fit: BoxFit.fitWidth,
  //                   )),
  //               // find location near you
  //               Container(
  //                   margin: EdgeInsets.only(bottom: 10),
  //                   child: Text(
  //                     LocationEventConstants.OFFLINE_FIND_LOCATION_NEAR_FOR_YOU,
  //                     style: TextStyle(
  //                         color: Colors.grey,
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold),
  //                   )),
  //               // please open location service
  //               Container(
  //                   margin: EdgeInsets.only(bottom: 10),
  //                   child: Center(
  //                     child: Text(
  //                       LocationEventConstants.OFFLINE_OPEN_LOCATION_SERVICE,
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(color: Colors.grey, fontSize: 18),
  //                     ),
  //                   )),
  //               // open location service button
  //               Container(
  //                 width: 80,
  //                 child: ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                       FocusManager.instance.primaryFocus!.unfocus();
  //                     },
  //                     style:
  //                         ElevatedButton.styleFrom(fixedSize: Size(width, 30)),
  //                     child: Text(
  //                       LocationEventConstants
  //                           .OFFLINE_OPEN_LOCATION_SERVICE_BUTTON,
  //                       style: TextStyle(color:  white),
  //                     )),
  //               ),
  //               Divider(
  //                 height: 4,
  //                 color:  white,
  //               ),
  //             ]),
  //           );
  //         });
  //       });
  // }
