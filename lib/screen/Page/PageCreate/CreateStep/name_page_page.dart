import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreate/CreateStep/category_page_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_button_chip.dart';

const List<String> QUESTION_NAME = [
  "Tên Trang của bạn là gì ?",
  "Hãy dùng tên doanh nghiệp/thương hiệu/tổ chức của bạn hoặc tên góp phần giải thích về Trang"
];
const String next = "Tiếp";
const String done = "Xong";

class NamePagePage extends StatefulWidget {
  const NamePagePage({super.key});

  @override
  State<NamePagePage> createState() => _NamePagePageState();
}

class _NamePagePageState extends State<NamePagePage> {
  late double width = 0;
  final _nameFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();

  bool _ischeckValitdatorName = false;
  bool _ischeckValitdatorDescription = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    return GestureDetector(
      onTap: (() {
        FocusManager.instance.primaryFocus!.unfocus();
      }),
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                child: SizedBox(
                  height: 80,
                  child: TextFormField(
                    validator: ((value) {
                      if (value!.isNotEmpty && value.length < 3) {
                        setState(() {
                          _ischeckValitdatorName = false;
                        });
                        return "Tên người dùng phải lớn hơn 2 ký tự.";
                      }

                      setState(() {
                        _ischeckValitdatorName = true;
                      });
                      return null;
                    }),
                    controller: nameController,
                    onChanged: (value) {
                      if (value.length > 2) {
                        setState(() {
                          _ischeckValitdatorName = false;
                        });
                      } else {
                        setState(() {
                          _ischeckValitdatorName = true;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        alignLabelWithHint: true,
                        labelText: "Tên Trang",
                        labelStyle: TextStyle(color: secondaryColor),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                  ),
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Mô tả về Trang của bạn.',
                    style: TextStyle(
                        // color:  white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                validator: ((value) {
                  if (value!.isNotEmpty && value.length < 3) {
                    setState(() {
                      _ischeckValitdatorDescription = false;
                    });
                    return "Tên người dùng phải lớn hơn 2 ký tự.";
                  }

                  setState(() {
                    _ischeckValitdatorDescription = true;
                  });
                  return null;
                }),
                controller: descriptionController,
                onChanged: (value) {
                  if (value.length > 2) {
                    setState(() {
                      _ischeckValitdatorDescription = false;
                    });
                  } else {
                    setState(() {
                      _ischeckValitdatorDescription = true;
                    });
                  }
                },
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    labelText: "Trang này nói về",
                    labelStyle: TextStyle(color: secondaryColor),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: buildBottomNavigatorWithButtonAndChipWidget(
              context: context,
              isPassCondition: (_nameFormKey.currentState == null
                      ? false
                      : _nameFormKey.currentState!.validate()) &&
                  nameController.text.length > 2 &&
                  descriptionController.text.length > 2,
              width: width,
              newScreen: CategoryPage(
                dataCreate: {
                  'title': nameController.text,
                  'description': descriptionController.text
                },
              ),
              title: next,
              currentPage: 1),
        )
      ]),
    );
  }
}
