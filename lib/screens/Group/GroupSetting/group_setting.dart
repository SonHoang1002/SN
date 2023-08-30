import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/tag/user_tag_settings.dart';

import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';
import 'package:provider/provider.dart' as pv;

class GroupSetting extends ConsumerStatefulWidget {
  final groupDetail;
  const GroupSetting({super.key, required this.groupDetail});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupSettingState();
}

class _GroupSettingState extends ConsumerState<GroupSetting> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  bool isDropdownVisible = false;
  bool isDropdownVisible2 = false;
  bool isDropdownVisible3 = false;
  bool isDropdownVisible4 = false;
  bool isDropdownVisible5 = false;
  void _toggleDropdown(int index) {
    setState(() {
      switch (index) {
        case 1:
          isDropdownVisible = !isDropdownVisible;
          break;
        case 2:
          isDropdownVisible2 = !isDropdownVisible2;
          break;
        case 3:
          isDropdownVisible3 = !isDropdownVisible3;
          break;
        case 4:
          isDropdownVisible4 = !isDropdownVisible4;
          break;
        case 5:
          isDropdownVisible5 = !isDropdownVisible5;
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppBarTitle(title: 'Cài đặt nhóm'),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FontAwesomeIcons.angleLeft,
              size: 18,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          shape:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomContainer(
                  isDarkMode: theme.isDarkMode,
                  children: [
                    sectionTitle(
                      "Thiết lập nhóm",
                    ),
                    FieldDataWidget(
                      title: "Tên và mô tả",
                      height: 260,
                      controler1: groupNameController,
                      controler2: groupDescriptionController,
                      dropdown: () => _toggleDropdown(1),
                      isDropdownVisible: isDropdownVisible,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: groupNameController,
                          enabled: true,
                          autofocus: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nhập tên nhóm mới ...',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: groupDescriptionController,
                          enabled: true,
                          autofocus: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nhóm này nói về ...',
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                    const Divider(
                      height: 0,
                      thickness: 1,
                    ),
                    FieldDataWidget(
                      title: "Danh mục và tag",
                      height: 230,
                      dropdown: () => _toggleDropdown(2),
                      isDropdownVisible: isDropdownVisible2,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: greyColor)),
                                child: const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Âm nhạc',
                                          style: TextStyle(
                                              fontSize: 16, color: blackColor),
                                        ),
                                        Icon(Icons.arrow_drop_down_sharp)
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: groupDescriptionController,
                          enabled: true,
                          autofocus: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nhập ngăn cách nhau dấu phẩy',
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 0,
                      thickness: 1,
                    ),
                    FieldDataWidget(
                      isLastItem: true,
                      title: "Quyền riêng tư",
                      height: 160,
                      dropdown: () => _toggleDropdown(3),
                      isDropdownVisible: isDropdownVisible3,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Chọn quyền riêng tư"),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: groupNameController,
                          enabled: false,
                          autofocus: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Công khai',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomContainer(isDarkMode: theme.isDarkMode, children: [
                  sectionTitle(
                    "Tùy chỉnh nhóm",
                  ),
                  FieldDataWidget(
                    isLastItem: true,
                    title: "Địa chỉ web",
                    height: 160,
                    dropdown: () => _toggleDropdown(4),
                    isDropdownVisible: isDropdownVisible4,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child:
                            Text("https://sn.emso.vn/group/110830222881103066"),
                      ),
                      TextFormField(
                        controller: groupNameController,
                        enabled: true,
                        autofocus: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText:
                              'Địa chỉ web để người dùng truy cập nhóm nhanh chóng',
                        ),
                      ),
                    ],
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                CustomContainer(isDarkMode: theme.isDarkMode, children: [
                  sectionTitle(
                    "Quản lý nội dung thảo luận",
                  ),
                  FieldDataWidget(
                    isLastItem: true,
                    title: "Ai có thể đăng",
                    height: 250,
                    dropdown: () => _toggleDropdown(5),
                    isDropdownVisible: isDropdownVisible5,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text("Ai có thể đăng"),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: greyColor)),
                              child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                        children: [
                                          Image.asset(
                                            "assets/groups/groupActivity.png",
                                            width: 20,
                                            height: 20,
                                            color: blackColor,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Text(
                                            'Bất cứ ai trong nhóm',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: blackColor),
                                          ),
                                        ],
                                      ),
                                      const Icon(Icons.arrow_drop_down_sharp)
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text("Phê duyệt mọi bài viết của thành viên"),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: greyColor)),
                              child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                        children: [
                                          Image.asset(
                                            "assets/groups/groupActivity.png",
                                            width: 20,
                                            height: 20,
                                            color: blackColor,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: const Text(
                                              overflow: TextOverflow.ellipsis,
                                              'Thành viên có thể trực tiếp đăng bài lên nhóm',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: blackColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(Icons.arrow_drop_down_sharp)
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ])
              ],
            ),
          ),
        ));
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class FieldDataWidget extends StatelessWidget {
  final String title;
  final double height;
  final List<Widget> children;
  final VoidCallback dropdown;
  final bool isDropdownVisible;
  final bool isLastItem;
  final TextEditingController? controler1;
  final TextEditingController? controler2;
  const FieldDataWidget(
      {Key? key,
      required this.title,
      required this.height,
      required this.children,
      required this.dropdown,
      required this.isDropdownVisible,
      this.isLastItem = false,
      this.controler1,
      this.controler2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isLastItem
          ? const EdgeInsets.fromLTRB(10, 10, 10, 0)
          : const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                  onTap: dropdown,
                  child: isDropdownVisible
                      ? const Icon(
                          Icons.keyboard_arrow_up_outlined,
                          size: 30,
                        )
                      : const Icon(Icons.edit))
            ],
          ),
          AnimatedSize(
            // vsync: this,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              height: isDropdownVisible ? height : 0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children +
                    [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonPrimary(
                            isGrey: true,
                            label: "Huỷ",
                            handlePress: () {
                              dropdown();
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ButtonPrimary(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            label: "Lưu",
                            handlePress: () {
                              if (controler1?.text == "" ||
                                  controler2?.text == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Hãy nhập đầy đủ thông tin"),
                                      duration: Duration(seconds: 3),
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.only(
                                          bottom: 20, right: 20, left: 20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(9)))),
                                );
                              }
                            },
                          )
                        ],
                      )
                    ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
