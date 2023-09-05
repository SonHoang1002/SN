import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/config.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Group/GroupCreate/create_group_screen.dart';
import 'package:social_network_app_mobile/screens/Group/GroupSetting/field_setting_group.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/tag/user_tag_settings.dart';

import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';
import 'package:provider/provider.dart' as pv;

class GroupSetting extends ConsumerStatefulWidget {
  final dynamic groupDetail;
  const GroupSetting({super.key, required this.groupDetail});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupSettingState();
}

class _GroupSettingState extends ConsumerState<GroupSetting> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController usernamesController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  String iconTag = '';
  dynamic groupDetail;
  dynamic categoryValue;
  List categories = [];
  bool privacySelected = true;
  bool isVisible = true;
  String postPermissionSelected = "NONE";
  String postApprovalSelected = "NONE";
  Map<bool, Map<String, dynamic>> listPrivacyOptions = {
    false: {
      "icon": "assets/groups/publish.png",
      "title": "Công khai",
    },
    true: {
      "icon": "assets/groups/privacy.png",
      "title": "Riêng tư",
    }
  };
  Map<bool, Map<String, dynamic>> listHideGroupOptions = {
    true: {
      "icon": "assets/groups/trueVisible.png",
      "title": "Hiển thị",
    },
    false: {
      "icon": "assets/groups/falseVisible.png",
      "title": "Ẩn nhóm",
    }
  };
  Map<String, Map<String, dynamic>> listPostPermission = {
    "NONE": {
      "icon": "assets/groups/groupActivity.png",
      "title": "Bất cứ ai trong nhóm",
    },
    "ADMIN_ONLY": {
      "icon": "assets/groups/user_shield.png",
      "title": "Chỉ có quản trị viên",
    },
  };
  Map<String, Map<String, dynamic>> listPostApproval = {
    "NONE": {
      "icon": "assets/groups/unlock.png",
      "title": "Thành viên có thể trực tiếp đăng bài lên nhóm",
    },
    "ADMIN_ONLY": {
      "icon": "assets/groups/privacy.png",
      "title":
          "Bài viết của thành viên phải được quản trị viên hoặc người kiểm duyệt phê duyệt",
    },
  };
  bool isDropdownVisible = false;
  bool isDropdownVisible2 = false;
  bool isDropdownVisible3 = false;
  bool isDropdownVisible4 = false;
  bool isDropdownVisible5 = false;
  void _toggleDropdown(int index) {
    FocusScope.of(context).requestFocus(FocusNode());
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

  saveNameAndDescription() async {
    FormData formData = FormData.fromMap({
      "title": groupNameController.text,
      "description": groupDescriptionController.text
    });
    var res = await GroupApi().updateGroupDetails(groupDetail["id"], formData);
    await ref
        .read(groupListControllerProvider.notifier)
        .updateGroupDetails(res);
    groupDetail = ref.read(groupListControllerProvider).groupDetail;
    _toggleDropdown(1);
    buildSnackBar("Cập nhật dữ liệu thành công");
  }

  saveCategoryAndTags() async {
    FormData formData = FormData.fromMap(
        {"tags": tagsController.text, "category_id": categoryValue["id"]});
    var res = await GroupApi().updateGroupDetails(groupDetail["id"], formData);
    await ref
        .read(groupListControllerProvider.notifier)
        .updateGroupDetails(res);
    groupDetail = ref.read(groupListControllerProvider).groupDetail;
    _toggleDropdown(2);
    buildSnackBar("Cập nhật dữ liệu thành công");
  }

  savePrivacySetting() async {
    FormData formData = FormData.fromMap(
        {"is_private": privacySelected, "is_visible": isVisible});
    var res = await GroupApi().updateGroupDetails(groupDetail["id"], formData);
    await ref
        .read(groupListControllerProvider.notifier)
        .updateGroupDetails(res);
    groupDetail = ref.read(groupListControllerProvider).groupDetail;
    _toggleDropdown(3);
    buildSnackBar("Cập nhật dữ liệu thành công");
  }

  saveUsernameSetting() async {
    FormData formData =
        FormData.fromMap({"username": usernamesController.text});
    var res = await GroupApi().updateGroupDetails(groupDetail["id"], formData);
    await ref
        .read(groupListControllerProvider.notifier)
        .updateGroupDetails(res);
    groupDetail = ref.read(groupListControllerProvider).groupDetail;
    _toggleDropdown(4);
    buildSnackBar("Cập nhật dữ liệu thành công");
  }

  saveDiscussionSetting() async {
    FormData formData = FormData.fromMap({
      "post_approval_setting": postApprovalSelected,
      "post_permission_setting": postPermissionSelected
    });
    var res = await GroupApi().updateGroupDetails(groupDetail["id"], formData);
    await ref
        .read(groupListControllerProvider.notifier)
        .updateGroupDetails(res);
    groupDetail = ref.read(groupListControllerProvider).groupDetail;
    _toggleDropdown(5);
    buildSnackBar("Cập nhật dữ liệu thành công");
  }

  void fetchCategories() async {
    final res = await GroupApi().fetchCategories(null);

    if (res != null) {
      setState(() {
        categories = res;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    groupDetail = widget.groupDetail;
    setData();
    fetchCategories();
    fetchData();
  }

  void fetchData() {
    Future.delayed(Duration.zero, () async {
      await ref
          .read(groupListControllerProvider.notifier)
          .getGroupDetail(widget.groupDetail["id"])
          .then(
        (value) {
          setState(
            () {
              groupDetail = ref.read(groupListControllerProvider).groupDetail;
              setData();
            },
          );
        },
      );
    });
  }

  void setData() {
    groupNameController = TextEditingController(text: groupDetail["title"]);
    groupDescriptionController =
        TextEditingController(text: groupDetail["description"]);
    tagsController = TextEditingController(text: groupDetail["tags"].join(","));
    usernamesController = TextEditingController(text: groupDetail["username"]);
    categoryController =
        TextEditingController(text: groupDetail["category"]["text"]);
    iconTag = groupDetail["category"]["icon"];
    categoryValue = groupDetail["category"];
    privacySelected = groupDetail["is_private"];
    postPermissionSelected = groupDetail["post_permission_setting"];
    postApprovalSelected = groupDetail["post_approval_setting"];
    isVisible = groupDetail["is_visible"];
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
            shape: const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.5)),
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
                        saveData: saveNameAndDescription,
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
                        saveData: saveCategoryAndTags,
                        isDropdownVisible: isDropdownVisible2,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              showBarModalBottomSheet(
                                barrierColor: Colors.transparent,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                context: context,
                                builder: (context) {
                                  return Categories(
                                    data: categories,
                                    title: 'Chọn danh mục nhóm',
                                    isValue: categoryValue,
                                    onSelected: (value) {
                                      setState(() {
                                        categoryValue = value;
                                        categoryController.text = value['text'];
                                        iconTag =
                                            value['icon'] ?? linkAvatarDefault;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: greyColorOutlined,
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
                                                ExtendedImage.network(
                                                  iconTag,
                                                  width: 20,
                                                  fit: BoxFit.cover,
                                                  height: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  categoryController.text,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: blackColor),
                                                ),
                                              ],
                                            ),
                                            const Icon(
                                              Icons.arrow_drop_down_sharp,
                                              color: blackColor,
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: tagsController,
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
                        height: privacySelected ? 270 : 170,
                        dropdown: () => _toggleDropdown(3),
                        saveData: savePrivacySetting,
                        isDropdownVisible: isDropdownVisible3,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text("Chọn quyền riêng tư"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              buildFilterUsersSelectionBottomSheet(
                                  listPrivacyOptions,
                                  privacySelected,
                                  "privacy");
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: greyColorOutlined,
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
                                                  listPrivacyOptions[
                                                      privacySelected]!["icon"],
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
                                                  child: Text(
                                                    listPrivacyOptions[
                                                            privacySelected]![
                                                        "title"],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: blackColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Icon(
                                              Icons.arrow_drop_down_sharp,
                                              color: blackColor,
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          privacySelected == true
                              ? Wrap(
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text("Ẩn nhóm"),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        buildFilterUsersSelectionBottomSheet(
                                            listHideGroupOptions,
                                            isVisible,
                                            "hide");
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: greyColorOutlined,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: greyColor)),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Wrap(
                                                        children: [
                                                          Image.asset(
                                                            listHideGroupOptions[
                                                                    isVisible]![
                                                                "icon"],
                                                            width: 20,
                                                            height: 20,
                                                            color: blackColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
                                                            child: Text(
                                                              listHideGroupOptions[
                                                                      isVisible]![
                                                                  "title"],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      blackColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .arrow_drop_down_sharp,
                                                        color: blackColor,
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container()
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
                      controler1: usernamesController,
                      isLastItem: true,
                      title: "Địa chỉ web",
                      height: 180,
                      dropdown: () => _toggleDropdown(4),
                      saveData: saveUsernameSetting,
                      isDropdownVisible: isDropdownVisible4,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(
                                text:
                                    "$urlWebEmso/group/${groupDetail["username"]}"));
                            buildSnackBar("Sao chép thành công!");
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                                "$urlWebEmso/group/${groupDetail["username"]}"),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: usernamesController,
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
                      height: postApprovalSelected == "NONE" ? 250 : 160,
                      dropdown: () => _toggleDropdown(5),
                      saveData: saveDiscussionSetting,
                      isDropdownVisible: isDropdownVisible5,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text("Ai có thể đăng"),
                        ),
                        InkWell(
                          onTap: () {
                            buildFilterUsersSelectionBottomSheet(
                                listPostPermission,
                                postApprovalSelected,
                                "post_approval_setting");
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: greyColorOutlined,
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
                                                listPostPermission[
                                                        postApprovalSelected]![
                                                    "icon"],
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
                                                child: Text(
                                                  listPostPermission[
                                                          postApprovalSelected]![
                                                      "title"],
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: blackColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color: blackColor,
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        postApprovalSelected == "NONE"
                            ? Wrap(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Text(
                                        "Phê duyệt mọi bài viết của thành viên"),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      buildFilterUsersSelectionBottomSheet(
                                          listPostApproval,
                                          postPermissionSelected,
                                          "post_permission_setting");
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: greyColorOutlined,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: greyColor)),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Wrap(
                                                      children: [
                                                        Image.asset(
                                                          listPostApproval[
                                                                  postPermissionSelected]![
                                                              "icon"],
                                                          width: 20,
                                                          height: 20,
                                                          color: blackColor,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                          child: Text(
                                                            listPostApproval[
                                                                    postPermissionSelected]![
                                                                "title"],
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    blackColor),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Icon(
                                                      Icons
                                                          .arrow_drop_down_sharp,
                                                      color: blackColor,
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ])
                ],
              ),
            ),
          )),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  buildSnackBar(title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(title),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9)))),
    );
  }

  buildFilterUsersSelectionBottomSheet(
      listItem, dynamic itemValue, String type) {
    showCustomBottomSheet(context, 200,
        title: "Chọn đối tượng",
        isShowCloseButton: false,
        bgColor: Colors.grey[300], widget: StatefulBuilder(
      builder: (ctx, setStatefull) {
        return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: listItem.length,
            itemBuilder: (context, index) {
              dynamic key = listItem.keys.elementAt(index);
              String title = listItem[key]!["title"];
              return InkWell(
                child: Column(
                  children: [
                    GeneralComponent(
                      [
                        buildTextContent(title, true),
                      ],
                      changeBackground: transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      suffixWidget: Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => secondaryColor),
                        groupValue: itemValue,
                        value: key,
                        onChanged: (value) async {
                          updateModalField(type, key);
                        },
                      ),
                      function: () async {
                        updateModalField(type, key);
                      },
                    ),
                    buildSpacer(height: 10)
                  ],
                ),
              );
            });
      },
    ));
  }

  void updateModalField(type, key) {
    switch (type) {
      case "privacy":
        setState(() {
          privacySelected = key;
        });
        break;
      case "post_approval_setting":
        setState(() {
          postApprovalSelected = key;
        });
        break;
      case "post_permission_setting":
        setState(() {
          postPermissionSelected = key;
        });
        break;
      case "hide":
        setState(() {
          isVisible = key;
        });
        break;
      default:
        break;
    }
    popToPreviousScreen(context);
  }
}
