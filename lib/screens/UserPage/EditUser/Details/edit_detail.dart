import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../../../../providers/UserPage/user_information_provider.dart';
import '../../../../theme/theme_manager.dart';
import '../../../../widgets/appbar_title.dart';
import '../../../../widgets/back_icon_appbar.dart';
import '../../../../widgets/button_primary.dart';
import 'package:provider/provider.dart' as pv;

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
      margin: const EdgeInsets.symmetric(vertical: 20.5),
    );
  }

  Widget editIcon(ThemeManager theme) {
    return Icon(Icons.edit,
        size: 15.0, color: theme.isDarkMode ? Colors.white70 : Colors.black54);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = pv.Provider.of<ThemeManager>(context);
    final userAbout = ref.watch(userInformationProvider).userMoreInfor;
    final infor = userAbout?['general_information'];
    final relationship = userAbout?['account_relationship'];
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
                    ButtonPrimary(
                      label: "Thêm công việc hiện tại",
                      colorButton: greyColor[300],
                      colorText: Colors.black54,
                    ),
                    buildDrawer(),
                    buildBoldTxt("Trung Học", theme),
                    ButtonPrimary(
                      label: "Thêm trường trung học",
                      colorButton: greyColor[300],
                      colorText: Colors.black54,
                    ),
                    buildDrawer(),
                    buildBoldTxt("Đại học", theme),
                    ButtonPrimary(
                      label: "Thêm trường đại học",
                      colorButton: greyColor[300],
                      colorText: Colors.black54,
                    ),
                    buildDrawer(),
                    buildBoldTxt("Tỉnh/Thành phố hiện tại", theme),
                    infor['place_live'] == null
                        ? ButtonPrimary(
                            label: "Thêm tỉnh/thành phố hiện tại",
                            colorButton: greyColor[300],
                            colorText: Colors.black54,
                          )
                        : ListTile(
                            leading: Checkbox(
                              value: true,
                              onChanged: (value) {},
                            ),
                            title: Text(
                                "Sống tại ${infor['place_live']['title']}"),
                            trailing: GestureDetector(
                              onTap: () {},
                              child: editIcon(theme),
                            ),
                          ),
                    buildDrawer(),
                    buildBoldTxt("Quê quán", theme),
                    infor['hometown'] == null
                        ? ButtonPrimary(
                            label: "Thêm quê quán",
                            colorButton: greyColor[300],
                            colorText: Colors.black54,
                          )
                        : ListTile(
                            leading: Checkbox(
                              checkColor: Colors.lightBlue[200],
                              value: true,
                              onChanged: (value) {},
                            ),
                            title: Text("Đến từ ${infor['hometown']['title']}"),
                            trailing: GestureDetector(
                              onTap: () {},
                              child: editIcon(theme),
                            ),
                          ),
                    buildDrawer(),
                    buildBoldTxt("Mối quan hệ", theme),
                    relationship != null &&
                            relationship['relationship_category'] != null
                        ? ListTile(
                            leading: Checkbox(
                              checkColor: Colors.lightBlue[200],
                              value: true,
                              onChanged: (value) {},
                            ),
                            title: Text(
                                "Đã kết hôn với ${relationship['partner']}"),
                            trailing: GestureDetector(
                              onTap: () {},
                              child: editIcon(theme),
                            ),
                          )
                        : ButtonPrimary(
                            label: "Thêm mối quan hệ",
                            colorButton: greyColor[300],
                            colorText: Colors.black54,
                          ),
                    buildDrawer(),
                    buildBoldTxt("Trang web", theme),
                    buildDrawer(),
                    buildBoldTxt("Liên kết xã hội", theme),
                  ],
                ),
              ),
      ),
    );
  }
}
