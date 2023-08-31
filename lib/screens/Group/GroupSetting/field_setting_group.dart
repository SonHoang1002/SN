import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

class FieldDataWidget extends StatelessWidget {
  final String title;
  final double height;
  final List<Widget> children;
  final VoidCallback dropdown;
  final VoidCallback saveData;
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
      required this.saveData,
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
          GestureDetector(
            onTap: dropdown,
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  isDropdownVisible
                      ? const Icon(
                          Icons.keyboard_arrow_up_outlined,
                          size: 30,
                        )
                      : const Icon(Icons.edit)
                ],
              ),
            ),
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
                              } else {
                                saveData();
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
