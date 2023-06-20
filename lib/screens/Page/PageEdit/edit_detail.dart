import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/screens/Page/PageEdit/select_category.dart';
import 'package:social_network_app_mobile/screens/Page/PageEdit/textfield_edit_page.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

import '../../../theme/colors.dart';

class EditDetail extends ConsumerStatefulWidget {
  final dynamic detailPage;
  final dynamic data;
  const EditDetail({super.key, this.detailPage, this.data});

  @override
  ConsumerState<EditDetail> createState() => _EditDetailState();
}

class _EditDetailState extends ConsumerState<EditDetail> {
  dynamic editPage;
  @override
  void initState() {
    super.initState();
    editPage = {
      "email": widget.data['email'],
      "phone_number": widget.data['phone_number'],
      "address": widget.data['address'],
      "description": widget.data['description'],
      "title": widget.data['title'],
      "username": widget.data['username'],
      "page_categories": widget.data['page_categories'],
    };
    Future.delayed(Duration.zero, () {
      ref.read(pageControllerProvider.notifier).getPageDetailCategory(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Chỉnh sửa chi tiết'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chỉnh sửa phần giới thiệu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 5,
            ),
            const Text('Chi tiết bạn chọn sẽ hiển thị công khai.',
                style: TextStyle(color: greyColor)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 20,
                  thickness: 1,
                ),
                const Text(
                  'Hạng mục',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  trailing: const Icon(Icons.edit),
                  title: Text(editPage?['page_categories'].isNotEmpty
                      ? "Trang \u2022 ${editPage?['page_categories']?[0]?['text']}"
                      : "Trang"),
                  onTap: () async {
                    final selectedCategory = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectCategory()),
                    );
                    if (selectedCategory != null) {}
                  },
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 20,
                  thickness: 1,
                ),
                const Text('Thông tin liên hệ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text("${editPage?['address'] ?? "Địa chỉ"}"),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => TextFieldEdit(
                              label: "Địa chỉ",
                              field: 'address',
                              initialValue: editPage?['address'],
                              title: "Chỉnh sửa vị trí",
                              onChange: (value) {
                                setState(() {
                                  editPage['address'] = value;
                                });
                              })),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text("${editPage?['phone_number'] ?? "Điện thoại"}"),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => TextFieldEdit(
                              label: "Số điện thoại",
                              field: 'phone_number',
                              initialValue: editPage?['phone_number'],
                              keyboardType: TextInputType.number,
                              title: "Chỉnh sửa số điện thoại",
                              hintText:
                                  "Số điện thoại này sẽ hiển thị trên Trang của bạn. EMSO sẽ không dùng thông tin này để liên hệ bạn",
                              onChange: (value) {
                                setState(() {
                                  editPage['phone_number'] = value;
                                });
                              })),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text("${editPage?['email'] ?? "Email"}"),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => TextFieldEdit(
                              label: "Email",
                              field: 'email',
                              initialValue: editPage?['email'],
                              title: "Chỉnh sửa email",
                              validateInput: (value) {
                                final regex = RegExp(
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|'
                                    r'(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.'
                                    r'[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                if (value.isEmpty) {
                                  return false;
                                }
                                if (!regex.hasMatch(value)) {
                                  return true;
                                }
                                return false;
                              },
                              hintText:
                                  "Email này sẽ hiển thị trên Trang của bạn. EMSO sẽ không dùng thông tin này để liên hệ bạn",
                              onChange: (value) {
                                setState(() {
                                  editPage['email'] = value;
                                });
                              })),
                    );
                  },
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 20,
                  thickness: 1,
                ),
                const Text('Thông tin cơ bản',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  trailing: const Icon(Icons.edit),
                  title: Text("${editPage?['title'] ?? "Tên trang"}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => TextFieldEdit(
                              label: "Tên trang",
                              field: 'title',
                              initialValue: editPage?['title'],
                              title: "Chỉnh sửa tên Trang",
                              onChange: (value) {
                                setState(() {
                                  editPage['title'] = value;
                                });
                              })),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  trailing: const Icon(Icons.edit),
                  title: Text("${editPage?['username'] ?? "Tên người dùng"}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => TextFieldEdit(
                              label: "Tên người dùng",
                              field: editPage?['username'],
                              title: "Chỉnh sửa tên người dùng",
                              onChange: (value) {
                                setState(() {
                                  editPage['username'] = value;
                                });
                              })),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  trailing: const Icon(Icons.edit),
                  title: Text("${editPage?['description'] ?? "Mô tả"}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => TextFieldEdit(
                              label: "Mô tả",
                              field: 'description',
                              initialValue: editPage?['description'],
                              title: "Chỉnh sửa tên người dùng",
                              onChange: (value) {
                                setState(() {
                                  editPage['description'] = value;
                                });
                              })),
                    );
                  },
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Divider(
                      height: 20,
                      thickness: 1,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonPrimary(
                        label: 'Lưu',
                        handlePress: () {
                          Navigator.pop(
                            context,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
