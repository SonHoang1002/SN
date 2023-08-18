import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key});

  @override
  State<PasswordChange> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordChange> {
  late double width = 0;

  late double height = 0;

  late TextEditingController currentPasswordController =
      TextEditingController(text: "");

  late TextEditingController newPasswordController =
      TextEditingController(text: "");

  late TextEditingController reEnterPasswordController =
      TextEditingController(text: "");

  bool isClickForChangePasswordButton = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Đổi mật khẩu'),
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
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Column(children: [
          // main content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              // color: Colors.grey[900],
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 5),
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  //subTitle

                  const SizedBox(
                    height: 10,
                  ),
                  // change password  bien mat khi click vao nut nay
                  Column(
                    children: [
                      //inputs
                      _buildInput(height, currentPasswordController,
                          "Mật khẩu hiện tại"),
                      _buildInput(
                          height, newPasswordController, "Nhập mật khẩu mới"),
                      _buildInput(height, reEnterPasswordController,
                          "Nhập lại mật khẩu"),
                      //save change
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(width * 0.9, 40),
                            backgroundColor: Colors.blue),
                        child: const Text(
                          "Lưu",
                          style: TextStyle(color: white, fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                            child: GestureDetector(
                          onTap: (() {}),
                          child: buildTextContent("Quên mật khẩu", false,
                              colorWord: Colors.blue[900], isCenterLeft: false),
                        )),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

_buildInput(double width, TextEditingController controller, String hintText) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
    height: 50,
    width: width * 0.9,
    child: TextFormField(
      // style: TextStyle(color:  white),
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            )),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            )),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
      ),
    ),
  );
}
