import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/password/forget_password.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/snack_bar_custom.dart';

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

  final _formKey = GlobalKey<FormState>();
  int selectedOption = 0;
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
        child: Form(
          key: _formKey,
          child: Column(children: [
            // main content
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                // color: Colors.grey[900],
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  children: [
                    Column(
                      children: [
                        //inputs
                        _buildInput(height, currentPasswordController,
                            "Mật khẩu hiện tại"),
                        _buildInput(
                            height, newPasswordController, "Nhập mật khẩu mới"),
                        _buildInput(height, reEnterPasswordController,
                            "Nhập lại mật khẩu"),
                        const Text(
                            "Nếu bạn cho rằng ai đó có thể biết mật khẩu cũ của mình, bạn nên đăng xuất khỏi mọi điện thoại, máy tính khác và kiểm tra các thay đổi gần đây cho tài khoản của mình."),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Duy trì đăng nhập',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Chúng tôi giúp bạn tiếp tục đăng nhập trên thiết bị.',
                                style:
                                    TextStyle(color: greyColor, fontSize: 14),
                              ),
                            ],
                          ),
                          leading: Radio(
                            value: 0,
                            activeColor: Colors.blue,
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Đăng xuất trên tất cả các thiết bị',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Chúng tôi giúp bạn bảo mật thông tin.',
                                style:
                                    TextStyle(color: greyColor, fontSize: 14),
                              ),
                            ],
                          ),
                          leading: Radio(
                            value: 1,
                            groupValue: selectedOption,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                        ),
                        ButtonPrimary(
                          label: 'Lưu',
                          handlePress: () async {
                            if (_formKey.currentState!.validate()) {
                              if (newPasswordController.text.trim() !=
                                  reEnterPasswordController.text.trim()) {
                                buildSnackBar(context,
                                    "Xác nhận mật khẩu mới không đúng, vui lòng kiểm tra lại");
                              } else {
                                var res = await UserPageApi().changePassword({
                                  "current_password":
                                      currentPasswordController.text.trim(),
                                  "new_password":
                                      newPasswordController.text.trim(),
                                  "new_password_confirmation":
                                      reEnterPasswordController.text.trim(),
                                  "revoke_token":
                                      selectedOption == 1 ? true : false
                                });

                                if (mounted) {
                                  if (res == null) {
                                    buildSnackBar(context,
                                        "Thay đổi mật khẩu thành công");
                                  } else {
                                    if (res["content"] != null &&
                                        res["content"]["error"] != null) {
                                      buildSnackBar(
                                          context, res["content"]["error"]);
                                    } else {
                                      buildSnackBar(context,
                                          "Thay đổi mật khẩu thành công");
                                    }
                                  }
                                }
                              }
                            }
                          },
                        ),
                        ButtonPrimary(
                          label: 'Huỷ',
                          isGrey: true,
                          handlePress: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                          child: GestureDetector(
                        onTap: (() {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ForgetPassword()));
                        }),
                        child: buildTextContent("Quên mật khẩu", false,
                            colorWord: Colors.blue[900], isCenterLeft: false),
                      )),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

_buildInput(double width, TextEditingController controller, String hintText) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
    height: 50,
    child: TextFormField(
      obscureText: true,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Hãy nhập đầy đủ thông tin';
        }
        if (value.length < 8) {
          return "Mật khẩu phải tối thiểu 8 kí tự";
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
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
