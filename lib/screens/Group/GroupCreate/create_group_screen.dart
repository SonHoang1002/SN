import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/screens/Group/GroupCreate/text_field_group.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({
    super.key,
  });

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List categories = [];
  TextEditingController controllerPrivate = TextEditingController(text: "");
  TextEditingController controllerVisible =
      TextEditingController(text: "Hiển thị");
  TextEditingController controllerTitle = TextEditingController(text: "");
  TextEditingController controllerDes = TextEditingController(text: "");
  TextEditingController controllerCate = TextEditingController(text: "");

  dynamic isPrivateValue;
  dynamic isCategoriesValue;
  dynamic isVisibleValue = {
    'is_visible': true,
    'title': 'Hiển thị',
    'icon': 'assets/groups/trueVisible.png'
  };
  handlePress(BuildContext context) async {
    FormData formData = FormData.fromMap({
      'title': controllerTitle.text,
      'description': controllerDes.text,
      'category_id': isCategoriesValue['id'],
      'is_private': isPrivateValue['is_private'],
      'is_visible': isVisibleValue['is_visible'] ?? true,
    });
    await GroupApi().createGroup(formData);
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Tạo nhóm'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Tên',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldGroup(
                    controller: controllerTitle,
                    label: 'Đặt tên nhóm',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Mô tả',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldGroup(
                    controller: controllerDes,
                    label: 'Mô tả',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Danh mục nhóm',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
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
                            isValue: isCategoriesValue,
                            onSelected: (value) {
                              setState(() {
                                isCategoriesValue = value;
                                controllerCate.text = value['text'];
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                    child: TextFieldGroup(
                      controller: controllerCate,
                      label: 'Danh mục nhóm',
                      readOnly: true,
                      enabled: false,
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Quyền riêng tư',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showBarModalBottomSheet(
                        barrierColor: Colors.transparent,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        context: context,
                        builder: (context) {
                          return _PrivacyBottomSheet(
                            data: isPrivate,
                            title: 'Chọn quyền riêng tư',
                            isValue: isPrivateValue,
                            onSelected: (value) {
                              setState(() {
                                isPrivateValue = value;
                                controllerPrivate.text = value['title'];
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                    child: TextFieldGroup(
                      label: 'Chọn quyền riêng tư',
                      controller: controllerPrivate,
                      readOnly: true,
                      enabled: false,
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isPrivateValue != null && isPrivateValue['is_private']
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ẩn nhóm',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showBarModalBottomSheet(
                                  barrierColor: Colors.transparent,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  context: context,
                                  builder: (context) {
                                    return _PrivacyBottomSheet(
                                      data: isVisible,
                                      title: 'Ẩn nhóm',
                                      isValue: isVisibleValue,
                                      onSelected: (value) {
                                        setState(() {
                                          isVisibleValue = value;
                                          controllerVisible.text =
                                              value['title'];
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              },
                              child: TextFieldGroup(
                                label: 'Ẩn nhóm',
                                controller: controllerVisible,
                                readOnly: true,
                                enabled: false,
                                suffixIcon: const Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: ButtonPrimary(
                      handlePress: () {
                        handlePress(context);
                      },
                      label: 'Tạo nhóm',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyBottomSheet extends StatefulWidget {
  final dynamic isValue;
  final dynamic data;
  final String title;
  final Function(dynamic) onSelected;

  const _PrivacyBottomSheet({
    required this.isValue,
    required this.data,
    required this.title,
    required this.onSelected,
  });

  @override
  State<_PrivacyBottomSheet> createState() => _PrivacyBottomSheetState();
}

class _PrivacyBottomSheetState extends State<_PrivacyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => SizedBox(
        height: 300,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            widget.title != '' ? Text(widget.title) : const SizedBox(),
            ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 0.0,
                  ),
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: 0),
                  leading: Image.asset(
                    widget.data[index]['icon'],
                    width: 22,
                    height: 22,
                  ),
                  title: Text(
                    widget.data[index]['title'] ?? "",
                  ),
                  subtitle: Text(
                    widget.data[index]['subTitle'] ?? "",
                  ),
                  trailing: widget.isValue != null &&
                          widget.isValue['title'] == widget.data[index]['title']
                      ? const Icon(
                          Icons.check,
                          color: Colors.blue,
                        )
                      : const SizedBox(),
                  onTap: () {
                    widget.onSelected(widget.data[index] ?? "");
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Categories extends StatefulWidget {
  final dynamic isValue;
  final dynamic data;
  final String title;
  final Function(dynamic) onSelected;

  const Categories({
    super.key,
    required this.isValue,
    required this.data,
    required this.title,
    required this.onSelected,
  });

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => SizedBox(
        height: 300,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            widget.title != '' ? Text(widget.title) : const SizedBox(),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection: Axis.vertical,
                  itemCount: widget.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      minLeadingWidth: 30,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 0.0,
                      ),
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: 0),
                      leading: widget.data[index]['icon'] != null
                          ? Image.network(
                              widget.data[index]['icon'],
                              width: 22,
                              height: 22,
                            )
                          : const SizedBox(),
                      title: Text(
                        widget.data[index]['text'] ?? "",
                      ),
                      trailing: widget.isValue != null &&
                              widget.isValue['text'] ==
                                  widget.data[index]['text']
                          ? const Icon(
                              Icons.check,
                              color: Colors.blue,
                            )
                          : const SizedBox(),
                      onTap: () {
                        widget.onSelected(widget.data[index] ?? "");
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
