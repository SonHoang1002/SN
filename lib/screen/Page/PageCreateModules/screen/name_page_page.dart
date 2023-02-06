import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreateModules/screen/category_page_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_with_button_and_chip_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

const List<String> QUESTION_NAME = [
  "Tên Trang của bạn là gì ?",
  "Hãy dùng tên doanh nghiệp/thương hiệu/tổ chức của bạn hoặc tên góp phần giải thích về Trang"
];
const String next = "Tiếp";
const String done = "Xong";

class NamePagePage extends StatefulWidget {
  @override
  State<NamePagePage> createState() => _NamePagePageState();
}

class _NamePagePageState extends State<NamePagePage> {
  late double width = 0;
  final _nameFormKey = GlobalKey<FormState>();
  late TextEditingController nameController = TextEditingController(text: "");
  bool _ischeckValitdator = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              SizedBox(),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: (() {
            FocusManager.instance.primaryFocus!.unfocus();
          }),
          child: Column(children: [
            Expanded(
              child: Container(
                // color: Colors.black87,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            QUESTION_NAME[0],
                            style: const TextStyle(
                                // color:  white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(QUESTION_NAME[1],
                          style: const TextStyle(
                              // color:  white ,
                              fontSize: 15)),
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _nameFormKey,
                        child: Container(
                          height: 80,
                          child: TextFormField(
                            validator: ((value) {
                              if (value!.length < 6) {
                                setState(() {
                                  _ischeckValitdator = false;
                                });
                                return "Tên ${value} không hợp lệ. Nếu bạn muốn tạo Trang mới, hãy chọn một tên khác như '${value} không chính thức'";
                              }

                              setState(() {
                                _ischeckValitdator = true;
                              });
                            }),
                            controller: nameController,
                            onChanged: ((value) {}),
                            style: const TextStyle(
                                // color:  white
                                ),
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 2),
                                ),
                                hintText: "Tên Trang",
                                hintStyle: TextStyle(color: Colors.grey),
                                labelText: "Tên Trang",
                                labelStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(.10)))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // bottom
            buildBottomNavigatorWithButtonAndChipWidget(
                context: context,
                isPassCondition: _nameFormKey.currentState == null
                    ? false
                    : _nameFormKey.currentState!.validate(),
                width: width,
                newScreen: CategoryPage(),
                title: next,
                currentPage: 1)
          ]),
        ));
  }
}
