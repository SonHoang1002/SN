import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/constant/event_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/EventScreen/screen/location_event_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/build_stage_navigation_bar_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../providers/event/selection_private_event_provider.dart';

class DetailEventPage extends StatefulWidget {
  @override
  State<DetailEventPage> createState() => _DetailEventPageState();
}

class _DetailEventPageState extends State<DetailEventPage> {
  List<dynamic> listRadio =
      DetailEventConstants.SELECTION_FOR_PRIVATE_OF_EVENT.map((e) {
    return e[1];
  }).toList();

  List<dynamic> listSelectionGroup =
      DetailEventConstants.SELECTION_FOR_CHOOSE_GROUP_EVENT.map((e) {
    return e[1];
  }).toList();

  late double width = 0;
  late double height = 0;
  // late String privateRuleValue = "";
  bool isPrivateSelection = true;

  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();

  List<int> _startPeriod = [DateTime.now().hour, DateTime.now().minute];
  List<int> _endPeriod = [DateTime.now().hour, DateTime.now().minute];
  bool isHaveEndTime = false;
  bool isOnBeginTime = true;
  late TextEditingController _startTimeController =
      TextEditingController(text: "");
  late TextEditingController _endTimeController =
      TextEditingController(text: "");
  late TextEditingController _nameEventController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
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
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            Expanded(
              child: Column(
                children: [
                  // title
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          DetailEventConstants.DETAIL_EVENT_TITLE,
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            // color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildSpacer(height: 20),
                  //user example
                  GeneralComponent(
                    [
                      Text(DetailEventConstants.USER_EXAMPLE[1],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // color: Colors.white
                          )),
                      buildSpacer(height: 5),
                      Text(DetailEventConstants.USER_EXAMPLE[2],
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                    prefixWidget: Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child:
                            Image.asset(DetailEventConstants.USER_EXAMPLE[0])),
                    changeBackground: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                  buildSpacer(height: 20),

                  // name event input
                  Container(
                    height: 50,
                    child: TextFormField(
                      controller: _nameEventController,
                      style: TextStyle(
                          // color: Colors.white
                          ),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          border: InputBorder.none,
                          hintText: DetailEventConstants.EVENT_NAME_PLACEHOLDER,
                          labelText:
                              DetailEventConstants.EVENT_NAME_PLACEHOLDER,
                          labelStyle: TextStyle(
                              // color: Colors.white
                              ),
                          hintStyle: TextStyle(
                              // color: Colors.white
                              )),
                    ),
                  ),
                  buildSpacer(height: 10),

                  // startTime input
                  Container(
                    height: 50,
                    child: TextFormField(
                      controller: _startTimeController,
                      readOnly: true,
                      onTap: (() {
                        _startTimeController.text =
                            "${_startTime.day} thg ${_startTime.month} lúc ${_startPeriod[0]}:${_startPeriod[1]}";
                        setState(() {});
                        _showBottomSheetDayAndTimePicker(context);
                      }),
                      style: TextStyle(
                          // color: Colors.white
                          ),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          border: InputBorder.none,
                          hintText:
                              DetailEventConstants.DAY_AND_TIME_BEGIN_TITLE,
                          labelText:
                              DetailEventConstants.DAY_AND_TIME_BEGIN_TITLE,
                          labelStyle: TextStyle(
                              // color: Colors.white
                              ),
                          hintStyle: TextStyle(
                              // color: Colors.white
                              )),
                    ),
                  ),
                  buildSpacer(height: 10),

                  //endTime input ( optional input)
                  isHaveEndTime
                      ? Container(
                          height: 50,
                          child: TextFormField(
                            controller: _endTimeController,
                            readOnly: true,
                            onTap: (() {
                              _showBottomSheetDayAndTimePicker(context);
                            }),
                            style: TextStyle(
                                // color: Colors.white
                                ),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 0, 0, 0),
                                border: InputBorder.none,
                                hintText:
                                    DetailEventConstants.DAY_AND_TIME_END_TITLE,
                                labelText:
                                    DetailEventConstants.DAY_AND_TIME_END_TITLE,
                                labelStyle: TextStyle(
                                    // color: Colors.white
                                    ),
                                hintStyle: TextStyle(
                                    // color: Colors.white
                                    )),
                          ),
                        )
                      : Container(),

                  buildSpacer(height: 5),

                  // add day and time function
                  isHaveEndTime
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            _showBottomSheetDayAndTimePicker(context);
                            isHaveEndTime = true;
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Text(
                                "+ ${DetailEventConstants.DAY_AND_TIME_END_TITLE}",
                                style: TextStyle(color: Colors.blue),
                              )
                            ],
                          ),
                        ),

                  buildSpacer(height: 20),

                  // divder
                  Divider(
                    height: 10,
                    color: Colors.grey,
                  ),
                  buildSpacer(height: 15),

                  // set private rule
                  GestureDetector(
                    onTap: () {
                      _showBottomSheetPrivateRuleOfEvent(context);
                    },
                    child: GeneralComponent(
                      [
                        Text(DetailEventConstants.PRIVATE_RULE_COMPONENT[1],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              // color: Colors.white
                            )),
                        buildSpacer(height: 5),
                        Text(
                            Provider.of<SelectionPrivateEventProvider>(context)
                                        .selection !=
                                    ""
                                ? Provider.of<SelectionPrivateEventProvider>(
                                        context)
                                    .selection
                                : DetailEventConstants
                                    .PRIVATE_RULE_COMPONENT[2],
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                      prefixWidget: Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Icon(
                            DetailEventConstants.PRIVATE_RULE_COMPONENT[0],
                            color: Colors.white,
                            size: 15,
                          )),
                      changeBackground: Colors.transparent,
                      padding: EdgeInsets.zero,
                      suffixWidget: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          EventConstants.ICON_DATA_NEXT,
                          // color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // bottom navigate
            buildStageNavigatorBar(
                width: width,
                currentPage: 1,
                isPassCondition: (_nameEventController.text.trim() != "" &&
                    Provider.of<SelectionPrivateEventProvider>(context)
                            .selection !=
                        ""),
                title: EventConstants.NEXT,
                function: () {
                  if (_nameEventController.text.trim() != "" &&
                      Provider.of<SelectionPrivateEventProvider>(context,
                                  listen: false)
                              .selection !=
                          "") {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => LocationEventPage()));
                  }
                })
          ]),
        ),
      ),
    );
  }

  // bottom sheet show private rule selections
  _showBottomSheetPrivateRuleOfEvent(BuildContext context) {
    bool isCustomerCanRequestFriend = false;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateFull) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: Provider.of<SelectionPrivateEventProvider>(context)
                          .selection ==
                      "Riêng tư"
                  ? 455
                  : 370,
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
              child: Column(children: [
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
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: Center(
                        child: Text(
                          DetailEventConstants.PRIVATE_OF_EVENT,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )),
                    ],
                  ),
                ),
                Divider(
                  height: 4,
                  color: Colors.white,
                ),
                buildSpacer(height: 15),
                Container(
                    child: Center(
                  child: Text(
                    DetailEventConstants.DESCRIPTION_FOR_PRIVATE_OF_EVENT,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )),
                buildSpacer(height: 5),
                Container(
                  height: 200,
                  child: ListView.builder(
                      itemCount: DetailEventConstants
                          .SELECTION_FOR_PRIVATE_OF_EVENT.length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: (() {
                            Provider.of<SelectionPrivateEventProvider>(context,
                                    listen: false)
                                .setSelectionPrivateEventProvider(
                                    DetailEventConstants
                                            .SELECTION_FOR_PRIVATE_OF_EVENT[
                                        index][1]);

                            if (Provider.of<SelectionPrivateEventProvider>(
                                        context,
                                        listen: false)
                                    .getSelectionPrivateEventProvider ==
                                "Nhóm") {
                              _showBottomSheetSelectionGroup(context);
                            }
                            setStateFull(() {});
                            setState(() {});
                          }),
                          child: GeneralComponent(
                            [
                              Text(
                                DetailEventConstants
                                    .SELECTION_FOR_PRIVATE_OF_EVENT[index][1],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DetailEventConstants
                                    .SELECTION_FOR_PRIVATE_OF_EVENT[index][2],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                            prefixWidget: Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Icon(
                                DetailEventConstants
                                    .SELECTION_FOR_PRIVATE_OF_EVENT[index][0],
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            suffixWidget: Radio(
                              groupValue: context
                                  .read<SelectionPrivateEventProvider>()
                                  .selection,
                              onChanged: ((value) {
                                context
                                    .read<SelectionPrivateEventProvider>()
                                    .setSelectionPrivateEventProvider(
                                        DetailEventConstants
                                                .SELECTION_FOR_PRIVATE_OF_EVENT[
                                            index][1]);
                                _showBottomSheetSelectionGroup(context);
                                setStateFull(() {});
                                setState(() {});
                              }),
                              value: listRadio[index],
                            ),
                            changeBackground: Colors.transparent,
                            padding: EdgeInsets.zero,
                          ),
                        );
                      })),
                ),
                buildSpacer(height: 5),
                Provider.of<SelectionPrivateEventProvider>(context).selection ==
                        "Riêng tư"
                    ? Column(children: [
                        Divider(
                          height: 2,
                          color: Colors.white,
                        ),
                        buildSpacer(height: 5),
                        GeneralComponent(
                          [
                            Text("Khách mời có thể mời bạn bè",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            buildSpacer(height: 5),
                            Text(
                                "Nếu cài đặt này bật, khách mời có thể mời bạn bè của họ tham gia sự kiện",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                          ],
                          suffixWidget: Container(
                            // color: Colors.red,
                            child: Switch(
                              onChanged: ((value) {
                                setStateFull(() {
                                  isCustomerCanRequestFriend =
                                      !isCustomerCanRequestFriend;
                                });
                              }),
                              value: isCustomerCanRequestFriend,
                            ),
                          ),
                          changeBackground: Colors.transparent,
                          padding: EdgeInsets.only(right: 10),
                        ),
                        buildSpacer(height: 10),
                      ])
                    : Container(),
                Container(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        FocusManager.instance.primaryFocus!.unfocus();
                      },
                      style:
                          ElevatedButton.styleFrom(fixedSize: Size(width, 30)),
                      child: Text(
                        "Xong",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ]),
            );
          });
        });
  }

  // bottom sheet show group selection after user choose "Ban be" value
  _showBottomSheetSelectionGroup(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 450,
            decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Column(children: [
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
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: Center(
                      child: Text(
                        DetailEventConstants.SELECTION_GROUP,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Divider(
                  height: 2,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 335,
                child: ListView.builder(
                    itemCount: DetailEventConstants
                        .SELECTION_FOR_CHOOSE_GROUP_EVENT.length,
                    itemBuilder: ((context1, index) {
                      return GeneralComponent(
                        [
                          Text(
                            DetailEventConstants
                                .SELECTION_FOR_CHOOSE_GROUP_EVENT[index][1],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DetailEventConstants
                                .SELECTION_FOR_CHOOSE_GROUP_EVENT[index][2],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ],
                        prefixWidget: Container(
                          margin: EdgeInsets.only(right: 10),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Image.asset(
                            DetailEventConstants
                                .SELECTION_FOR_CHOOSE_GROUP_EVENT[index][0],
                          ),
                        ),
                        suffixWidget: Radio(
                          fillColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.white),
                          groupValue: listSelectionGroup,
                          onChanged: ((value) {}),
                          value: listSelectionGroup[index],
                        ),
                        changeBackground: Colors.transparent,
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      );
                    })),
              ),
              Container(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(fixedSize: Size(width, 30)),
                    child: Text(
                      "Lưu",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ]),
          );
        });
  }

  // bottom sheet show day and time table for user  choose for day and time input
  _showBottomSheetDayAndTimePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        backgroundColor: Colors.grey[900],
        builder: (context) {
          return Wrap(
            children: [
              StatefulBuilder(builder: (context, setStateFull) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: height * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15))),
                  child: Column(children: [
                    // navigate bottom sheet
                    Container(
                      // margin: EdgeInsets.only(top: 40),
                      height: 50,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (() {
                                Navigator.of(context).pop();
                              }),
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text("Hủy",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Ngày và giờ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: (() {
                                Navigator.of(context).pop();
                              }),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Text("OK",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            )
                          ]),
                    ),
                    // begin time
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 30,
                      child: Row(
                          mainAxisAlignment: isHaveEndTime
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (() {
                                isOnBeginTime = true;
                                setStateFull(() {});
                                setState(() {});
                              }),
                              child: Text(
                                  "Bat dau vao: ${_startTime.day}/${_startTime.month}, luc: ${_startPeriod[0]}:${_startPeriod[1]}",
                                  style: TextStyle(
                                    color: isOnBeginTime
                                        ? Colors.blue
                                        : Colors.grey,
                                    fontSize: 15,
                                  )),
                            ),
                            !isHaveEndTime
                                ? GestureDetector(
                                    onTap: (() {
                                      isHaveEndTime = true;
                                      isOnBeginTime = false;
                                      setStateFull(() {});
                                      setState(() {});
                                    }),
                                    child: Text("+ Thời gian kết thúc",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        )),
                                  )
                                : Container(),
                          ]),
                    ),
                    // end time
                    isHaveEndTime
                        ? Column(
                            children: [
                              //divider
                              Divider(height: 10, color: Colors.green),
                              // end time
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height: 30,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (() {
                                          isOnBeginTime = false;
                                          setStateFull(() {});
                                          setState(() {});
                                        }),
                                        child: Container(
                                          child: Text(
                                              "Ket thuc vao: ${_endTime.day}/${_endTime.month}, luc :${_endPeriod[0]}: ${_endPeriod[1]}",
                                              style: TextStyle(
                                                color: !isOnBeginTime
                                                    ? Colors.blue
                                                    : Colors.grey,
                                                fontSize: 15,
                                              )),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (() {
                                          isHaveEndTime = false;
                                          isOnBeginTime = true;
                                          setStateFull(() {});
                                          setState(() {});
                                        }),
                                        child: Container(
                                            child: Icon(
                                          FontAwesomeIcons.close,
                                          color: Colors.white,
                                          size: 18,
                                        )),
                                      ),
                                    ]),
                              ),
                            ],
                          )
                        : Container(),
                    // table Calendar
                    Container(
                      height: 325,
                      color: Colors.grey[600],
                      child: TableCalendar(
                        selectedDayPredicate: (day) {
                          if (isOnBeginTime) {
                            return isSameDay(_startTime, day);
                          }
                          return isSameDay(_endTime, day);
                        },
                        onPageChanged: (focusedDay) {
                          if (isOnBeginTime) {
                            _startTime = focusedDay;
                          }
                          _endTime = focusedDay;
                        },
                        onFormatChanged: (format) {
                          CalendarFormat.week;
                        },
                        onDaySelected: ((selectedDay, focusedDay) {
                          if (isOnBeginTime) {
                            _startTime = selectedDay;
                            _startTimeController.text =
                                "${_startTime.day} thg ${_startTime.month} lúc ${_startPeriod[0]}:${_startPeriod[1]}";
                          } else {
                            _endTime = selectedDay;
                            _endTimeController.text =
                                "${_endTime.day} thg ${_endTime.month} lúc ${_endPeriod[0]}:${_endPeriod[1]}";
                          }
                          setStateFull(() {});
                          setState(() {});
                        }),
                        firstDay: DateTime.utc(1950, 1, 1),
                        lastDay: DateTime.utc(2100, 1, 1),
                        focusedDay: DateTime.now(),
                        headerStyle: HeaderStyle(
                          leftChevronVisible: false,
                          rightChevronVisible: false,
                          headerPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                        ),
                      ),
                    ),

                    // datetime picker
                    Container(
                      height: 200,
                      child: CupertinoDatePicker(
                        backgroundColor: Colors.grey[700],
                        mode: CupertinoDatePickerMode.time,
                        onDateTimeChanged: (value) {
                          if (isOnBeginTime) {
                            _startPeriod = [value.hour, value.minute];
                            _startTimeController.text =
                                "${_startTime.day} thg ${_startTime.month} lúc ${_startPeriod[0]}:${_startPeriod[1]}";
                          } else {
                            _endPeriod = [value.hour, value.minute];
                            _endTimeController.text =
                                "${_endTime.day} thg ${_endTime.month} lúc ${_endPeriod[0]}:${_endPeriod[1]}";
                          }
                          setStateFull(() {});
                          setState(() {});
                        },
                        initialDateTime: DateTime.now(),
                      ),
                    )
                  ]),
                );
              }),
            ],
          );
        });
  }
}
