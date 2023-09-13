import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screens/UserPage/EditUser/Details/change_place_live.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../../../../constant/common.dart';
import '../../../../data/life_event_categories.dart';
import '../../../../helper/push_to_new_screen.dart';
import '../../../../providers/UserPage/user_information_provider.dart';
import '../../../../theme/theme_manager.dart';
import '../../../../widgets/WebView/my_web_view.dart';
import '../../../../widgets/appbar_title.dart';
import '../../../../widgets/back_icon_appbar.dart';
import '../../../../widgets/button_primary.dart';
import 'package:provider/provider.dart' as pv;

import '../../../CreatePost/MenuBody/life_event_categories.dart';
import 'add_social_links.dart';
import 'add_user_relationship.dart';
import '../../../CreatePost/create_modal_base_menu.dart';
import 'add_website_link.dart';

class EditUserDetail extends ConsumerStatefulWidget {
  const EditUserDetail({super.key});

  @override
  EditUserDetailState createState() => EditUserDetailState();
}

class EditUserDetailState extends ConsumerState<EditUserDetail> {
  bool isLoading = false;
  List friendSelected = [];
  List files = [];

  String content = '';
  String gifLink = '';

  bool _isShow = true;
  dynamic menuSelected;
  dynamic visibility = typeVisibility[0];
  dynamic backgroundSelected;
  dynamic statusActivity;
  dynamic statusQuestion;
  dynamic checkin;
  dynamic updateLifeEvent;
  dynamic poll;

  bool isUploadVideo = false;
  bool showMap = true;

  bool isActiveBackground = false;
  double height = 0;
  double width = 0;
  dynamic postDiscussion;
  dynamic previewUrlData;
  bool showPreviewImage = true;
  ScrollController menuController = ScrollController();
  bool isMenuMinExtent = true;
  

  List listMentions = [];
  Offset textFieldOffset = const Offset(0, 150.6);
  String type = "";
  dynamic userAbout;
  dynamic infor;
  dynamic relationship;
  List lifeEvent = [];
  List workEvents = [];
  bool refresh = false;

  Text buildBoldTxt(String title, ThemeManager theme) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: theme.isDarkMode ? Colors.white : Colors.black,
        fontSize: 17.0,
      ),
    );
  }

  Widget buildDrawer() {
    return Container(
      height: 0.75,
      color: greyColor[300],
      margin: const EdgeInsets.symmetric(vertical: 17.5),
    );
  }

  Widget buildRowInfo(
      String title, Widget head, Function onEdit, ThemeManager theme) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: head,
        ),
        Expanded(
          flex: 4,
          child: InkWell(
            onTap: () {
              if (title.contains('https')) {
                pushCustomCupertinoPageRoute(
                  context,
                  MyWebView(
                    title: 'Liên kết ngoài',
                    selectedUrl: title,
                  ),
                );
              }
            },
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16.0,
                  color: title.contains('https')
                      ? Colors.lightBlue[200]
                      : theme.isDarkMode
                          ? Colors.white60
                          : Colors.black54),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              onEdit();
            },
            child: Icon(Icons.edit,
                size: 22.5,
                color: theme.isDarkMode ? Colors.white70 : Colors.black54),
          ),
        ),
      ],
    );
  }

  
  handleUpdateData(
    String type,
    dynamic data,
  ) {
    switch (type) {
      case 'update_visibility':
        setState(() {
          visibility = data;
          _isShow = false;
        });
        break;
      case 'update_content':
        setState(() {
          content = data['content'];
          listMentions = data['mentions'];
          _isShow = false;
        });

        if (data.length > 150) {
          setState(() {
            backgroundSelected = null;
            _isShow = false;
          });
        }
        break;
      case 'update_friend':
        setState(() {
          friendSelected = data;
          _isShow = false;
        });
        break;
      case 'update_background':
        setState(() {
          backgroundSelected = data;
          _isShow = false;
        });
        break;
      case 'update_gif':
        setState(() {
          gifLink = data;
          _isShow = false;
        });
        break;
      case 'update_status_activity':
        setState(() {
          statusActivity = data;
          _isShow = false;
        });
        break;
      case 'update_status_question':
        setState(() {
          statusQuestion = data;
          _isShow = false;
        });
        break;
      case 'update_checkin':
        setState(() {
          checkin = data;
          _isShow = false;
        });
        break;
      case 'update_file':
        List listPath = [];
        List newFiles = [];

        for (var item in data) {
          if (!listPath.contains(item?['id'])) {
            newFiles.add(item);
            listPath.add(item?['id']);
          } else if (item['file'] != null) {
            if (item['file'].path != null &&
                (!listPath.contains(item['file']!.path))) {
              newFiles.add(item);
              listPath.add(item['file']!.path);
            }
          }
        }
        setState(() {
          files = newFiles;
          _isShow = false;
        });
        break;
      case 'update_file_description':
        setState(() {
          if (files.length == 1) {
            files = [data];
          } else {
            files = data;
          }
          _isShow = false;
        });
        break;
      case 'update_poll':
        setState(() {
          poll = data;
          _isShow = false;
        });
        break;
      case 'updateLifeEvent':
        setState(() {
          updateLifeEvent = data;
          _isShow = false;
        });
    }
  }

  handlePress(event, school, relationship) {
    if (event['children'] != null && event['children'].isNotEmpty) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => CreateModalBaseMenu(
                  title: event['name'],
                  body: LifeEventCategories(
                    type: 'children',
                    eventSelected: event,
                    listLifeEvent: event['children'],
                    handleUpdateData: handleUpdateData,
                    edit: true,
                    school: school,
                  ),
                  buttonAppbar: const SizedBox())));
    }
  }

  
  refreshData() {
    setState(() {
      ref
          .read(userInformationProvider.notifier)
          .getUserInformation(userAbout["id"]);
      ref
          .read(userInformationProvider.notifier)
          .getUserMoreInformation(userAbout["id"]);
      ref
          .read(userInformationProvider.notifier)
          .getUserLifeEvent(userAbout["id"]);
      ref
          .read(userInformationProvider.notifier)
          .getUserFeatureContent(userAbout["id"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (refresh) {
      refreshData();
      setState(() {
        refresh = false;
      });
    }

    final size = MediaQuery.sizeOf(context);
    final theme = pv.Provider.of<ThemeManager>(context);
    userAbout = ref.watch(userInformationProvider).userMoreInfor;
    infor = userAbout?['general_information'];
    relationship = userAbout?['account_relationship'];
    lifeEvent = ref.watch(userInformationProvider).userLifeEvent;
    workEvents = lifeEvent.where((e) => e['life_event']['school_type'] == null).toList();

    final highSchoolEvents = lifeEvent
        .where((e) => e['life_event']['school_type'] == 'HIGH_SCHOOL')
        .toList();

    final universityEvents = lifeEvent
        .where((e) => e['life_event']['school_type'] == 'UNIVERSITY')
        .toList();
    List listData = lifeEventCategories;


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            const AppBarTitle(title: "Chỉnh sửa chi tiết"),
            ButtonPrimary(
              label: isLoading ? null : "Lưu",
              icon: isLoading
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : null,
              handlePress: () {},
            ),
          ],
        ),
      ),
      body: Container(
        height: size.height,
        margin: const EdgeInsets.symmetric(horizontal: 12.5),
        child: isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                color: theme.isDarkMode ? Colors.white : Colors.black,
              ))
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildBoldTxt("Chỉnh sửa phần giới thiệu", theme),
                    Text(
                      "Chi tiết bạn chọn sẽ hiển thị công khai",
                      style: TextStyle(
                          fontSize: 13.5,
                          color: theme.isDarkMode
                              ? Colors.white54
                              : Colors.black54),
                    ),
                    buildDrawer(),
                    buildBoldTxt("Công việc hiện tại", theme),
                    workEvents.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: workEvents.length,
                            itemBuilder: (context, index) {
                              String preWord = workEvents[index]['life_event']
                                      ['name'] ??
                                  'Làm việc';
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 7.5),
                                child: buildRowInfo(
                                    "$preWord tại ${workEvents[index]['life_event']["place"] != null ? workEvents[index]['life_event']["place"]['title'] : ""}",
                                    const Icon(FontAwesomeIcons.briefcase,
                                        size: 18),
                                    () {},
                                    theme),
                              );
                            })
                        : const SizedBox(),
                    ButtonPrimary(
                      label: "Thêm công việc hiện tại",
                      colorButton: greyColor[300],
                      colorText: Colors.black54,
                      handlePress: () {
                        handlePress(listData[3], null, null);
                      },
                    ),
                    buildDrawer(),
                    buildBoldTxt("Trung Học", theme),
                    highSchoolEvents.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: highSchoolEvents.length,
                            itemBuilder: (context, index) {
                              String school = highSchoolEvents[index]
                                      ['life_event']['name'] ??
                                  'Từng học';
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 7.5),
                                child: buildRowInfo(
                                    "$school tại ${highSchoolEvents[index]['life_event']["place"] != null ? highSchoolEvents[index]['life_event']["place"]['title'] : ""}",
                                    const Icon(FontAwesomeIcons.briefcase,
                                        size: 18),
                                    () {},
                                    theme),
                              );
                            })
                        : const SizedBox(),
                    ButtonPrimary(
                      label: "Thêm trường trung học",
                      colorButton: greyColor[300],
                      colorText: Colors.black54,
                      handlePress: () {
                        handlePress(listData[10], "HIGH_SCHOOL", null);
                      },
                    ),
                    buildDrawer(),
                    buildBoldTxt("Đại học", theme),
                    universityEvents.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: universityEvents.length,
                            itemBuilder: (context, index) {
                              String university = universityEvents[index]
                                      ['life_event']['name'] ??
                                  'Từng học';
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 7.5),
                                child: buildRowInfo(
                                     "$university tại ${universityEvents[index]['life_event']["place"] != null ? universityEvents[index]['life_event']["place"]['title'] : "Trường mới"}",
                                    const Icon(FontAwesomeIcons.briefcase,
                                        size: 18),
                                    () {},
                                    theme),
                              );
                            })
                        : const SizedBox(),
                    ButtonPrimary(
                      label: "Thêm trường đại học",
                      colorButton: greyColor[300],
                      colorText: Colors.black54,
                      handlePress: () {
                        handlePress(listData[10], "UNIVERSITY", null);
                      },
                    ),
                    buildDrawer(),
                    buildBoldTxt("Tỉnh/Thành phố hiện tại", theme),
                    infor['place_live'] == null
                        ? ButtonPrimary(
                            label: "Thêm tỉnh/thành phố hiện tại",
                            colorButton: greyColor[300],
                            colorText: Colors.black54,
                            handlePress: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      const ChangeLivingPlace(),
                                ),
                              );
                            },
                          )
                        : buildRowInfo(
                            "Sống tại ${infor['place_live']['title']}",
                            Checkbox(
                              activeColor: secondaryColor,
                              value: true,
                              onChanged: (value) {},
                            ),
                            () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      const ChangeLivingPlace(),
                                ),
                              );
                            },
                            theme,
                          ),
                    buildDrawer(),
                    buildBoldTxt("Quê quán", theme),
                    infor['hometown'] == null
                        ? ButtonPrimary(
                            label: "Thêm quê quán",
                            colorButton: greyColor[300],
                            colorText: Colors.black54,
                            handlePress: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const ChangeLivingPlace(
                                    city: false,
                                  ),
                                ),
                              );
                            },
                          )
                        : buildRowInfo(
                            "Đến từ ${infor['hometown']['title']}",
                            Checkbox(
                                activeColor: secondaryColor,
                                value: true,
                                 onChanged: (value) {}), () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const ChangeLivingPlace(
                                  city: false,
                                ),
                              ),
                            );
                          }, theme),
                    buildDrawer(),
                    buildBoldTxt("Mối quan hệ", theme),
                    relationship != null &&
                            relationship['relationship_category'] != null
                        ? buildRowInfo(
                            "Đã kết hôn với ${relationship['partner']['display_name']}",
                            Checkbox(
                                activeColor: secondaryColor,
                                value: true,
                                 onChanged: (value) {}),  () async {
                            refresh = await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => CreateModalBaseMenu(
                                        title: listData[11]['name'],
                                        body: Relationship(
                                          type: 'children',
                                          eventSelected: listData[11],
                                          listLifeEvent: listData[11]
                                              ['children'],
                                          handleUpdateData: handleUpdateData,
                                          edit: true,
                                          school: null,
                                          relationship: relationship,
                                          idUser: userAbout["id"],
                                        ),
                                        buttonAppbar: const SizedBox())));
                            if (refresh) {
                              setState(() {
                                refreshData();
                              });
                            }
                          }, theme)
                        : ButtonPrimary(
                            label: "Thêm mối quan hệ",
                            colorButton: greyColor[300],
                            colorText: Colors.black54,
                            handlePress: () async {
                              refresh = await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => CreateModalBaseMenu(
                                          title: listData[11]['name'],
                                          body: Relationship(
                                            type: 'children',
                                            eventSelected: listData[11],
                                            listLifeEvent: listData[11]
                                                ['children'],
                                            handleUpdateData: handleUpdateData,
                                            edit: true,
                                            school: null,
                                            relationship: relationship,
                                            idUser: userAbout["id"],
                                          ),
                                          buttonAppbar: const SizedBox())));
                              if (refresh) {
                                setState(() {
                                  refreshData();
                                });
                              }
                            },
                          ),
                    buildDrawer(),
                    buildBoldTxt("Trang web", theme),
                    infor['account_web_link'] != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: infor['account_web_link'].length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 7.5),
                                child: buildRowInfo(
                                    "${infor['account_web_link'][index]['url']}",
                                    Icon(FontAwesomeIcons.earthAsia,
                                        size: 22.5,
                                        color: theme.isDarkMode
                                            ? Colors.white60
                                            : Colors.black54),
                                    () {},
                                    theme),
                              );
                            })
                        : const SizedBox(),
                    ButtonPrimary(
                      label: "Thêm trang web",
                      colorButton: greyColor[300],
                      colorText: Colors.black54,
                      handlePress: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const AddWebsiteLink(),
                          ),
                        );
                      },
                    ),
                    buildDrawer(),
                    buildBoldTxt("Liên kết xã hội", theme),
                    ButtonPrimary(
                      label: "Thêm liên kết xã hội",
                      colorButton: greyColor[300],
                      colorText: Colors.black54,
                      handlePress: (){
                        Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => CreateModalBaseMenu(
                                        title: listData[11]['name'],
                                        body: SocialLinks(
                                          type: 'children',
                                          eventSelected: listData[11],
                                          listLifeEvent: listData[11]
                                              ['children'],
                                          handleUpdateData: handleUpdateData,
                                          edit: true,
                                          school: null,
                                          relationship: relationship,
                                          idUser: userAbout["id"],
                                        ),
                                        buttonAppbar: const SizedBox())));
                      },
                    ),
                    const SizedBox(height: 25.0),
                  ],
                ),
              ),
      ),
    );
  }
}
