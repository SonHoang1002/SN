import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../../../../helper/push_to_new_screen.dart';
import '../../../../providers/UserPage/user_information_provider.dart';
import '../../../../theme/theme_manager.dart';
import '../../../../widgets/WebView/my_web_view.dart';
import '../../../../widgets/appbar_title.dart';
import '../../../../widgets/back_icon_appbar.dart';
import '../../../../widgets/button_primary.dart';
import 'package:provider/provider.dart' as pv;

import '../../../CreatePost/MenuBody/life_event_categories.dart';
import '../../../CreatePost/create_modal_base_menu.dart';
import 'add_life_event.dart';
import 'add_website_link.dart';

class EditUserDetail extends ConsumerStatefulWidget {
  const EditUserDetail({super.key});

  @override
  EditUserDetailState createState() => EditUserDetailState();
}

class EditUserDetailState extends ConsumerState<EditUserDetail> {
  bool isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = pv.Provider.of<ThemeManager>(context);
    final userAbout = ref.watch(userInformationProvider).userMoreInfor;
    final infor = userAbout?['general_information'];
    final relationship = userAbout?['account_relationship'];
    final lifeEvent = ref.watch(userInformationProvider).userLifeEvent;
    final workEvents =
        lifeEvent.where((e) => e['life_event']['school_type'] == null).toList();

    final highSchoolEvents = lifeEvent
        .where((e) => e['life_event']['school_type'] == 'HIGH_SCHOOL')
        .toList();

    final universityEvents = lifeEvent
        .where((e) => e['life_event']['school_type'] == 'UNIVERSITY')
        .toList();

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
                                      ['position'] ??
                                  'Làm việc';
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 7.5),
                                child: buildRowInfo(
                                    "$preWord tại ${workEvents[index]['life_event']['company']}",
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
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => CreateModalBaseMenu(
                              title: 'Sự kiện trong đời',
                              body: LifeEventCategories(
                                handleUpdateData: () {},
                              ),
                              buttonAppbar: const SizedBox(),
                            ),
                          ),
                        );
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
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 7.5),
                                child: buildRowInfo(
                                    "Từng học tại ${highSchoolEvents[index]['life_event']['company']}",
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
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => CreateModalBaseMenu(
                              title: 'Sự kiện trong đời',
                              body: LifeEventCategories(
                                handleUpdateData: () {},
                              ),
                              buttonAppbar: const SizedBox(),
                            ),
                          ),
                        );
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
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 7.5),
                                child: buildRowInfo(
                                    "Từng học tại ${universityEvents[index]['life_event']['company'] ?? "Trường mới"}",
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
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => CreateModalBaseMenu(
                              title: 'Sự kiện trong đời',
                              body: LifeEventCategories(
                                handleUpdateData: () {},
                              ),
                              buttonAppbar: const SizedBox(),
                            ),
                          ),
                        );
                      },
                    ),
                    buildDrawer(),
                    buildBoldTxt("Tỉnh/Thành phố hiện tại", theme),
                    infor['place_live'] == null
                        ? ButtonPrimary(
                            label: "Thêm tỉnh/thành phố hiện tại",
                            colorButton: greyColor[300],
                            colorText: Colors.black54,
                          )
                        : buildRowInfo(
                            "Sống tại ${infor['place_live']['title']}",
                            Checkbox(
                                activeColor: secondaryColor,
                                value: true,
                                onChanged: (value) {}),
                            () {},
                            theme),
                    buildDrawer(),
                    buildBoldTxt("Quê quán", theme),
                    infor['hometown'] == null
                        ? ButtonPrimary(
                            label: "Thêm quê quán",
                            colorButton: greyColor[300],
                            colorText: Colors.black54,
                          )
                        : buildRowInfo(
                            "Đến từ ${infor['hometown']['title']}",
                            Checkbox(
                                activeColor: secondaryColor,
                                value: true,
                                onChanged: (value) {}),
                            () {},
                            theme),
                    buildDrawer(),
                    buildBoldTxt("Mối quan hệ", theme),
                    relationship != null &&
                            relationship['relationship_category'] != null
                        ? buildRowInfo(
                            "Đã kết hôn với ${relationship['partner']['display_name']}",
                            Checkbox(
                                activeColor: secondaryColor,
                                value: true,
                                onChanged: (value) {}),
                            () {},
                            theme)
                        : ButtonPrimary(
                            label: "Thêm mối quan hệ",
                            colorButton: greyColor[300],
                            colorText: Colors.black54,
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
                    ),
                    const SizedBox(height: 25.0),
                  ],
                ),
              ),
      ),
    );
  }
}
