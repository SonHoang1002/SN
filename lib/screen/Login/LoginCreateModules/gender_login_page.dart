import 'package:flutter/material.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/divider_widget.dart';
import '../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../widget/GeneralWidget/show_bottom_sheet_widget.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevate_button_widget.dart';
import '../widgets/have_account_widget.dart';
import 'main_login_page.dart';
import 'phone_login_page.dart';

class GenderLoginPage extends StatefulWidget {
  const GenderLoginPage({super.key});

  @override
  State<GenderLoginPage> createState() => _GenderLoginPageState();
}

final selectionList = ["Nam", "Nữ", "Tùy chọn"];
String _anonymousName = "";

class _GenderLoginPageState extends State<GenderLoginPage> {
  late double width = 0;
  late double height = 0;
  String _selection = "Nam";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Column(children: [
          // main content
          Expanded(
            child: Container(
              child: Column(
                // padding: EdgeInsets.symmetric(vertical: 5),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // img
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Column(
                            children: [
                              // tiêu đề
                              buildTextContent(
                                  GenderLoginConstants.GENDER_LOGIN_TITLE, true,
                                  fontSize: 16,
                                  colorWord: blackColor,
                                  isCenterLeft: false),
                              // tiêu đề con
                              Text(
                                GenderLoginConstants.GENDER_LOGIN_SUBTITLE,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              buildSpacer(height: 10),
                              // lựa chọn
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: GenderLoginConstants
                                    .GENDER_LOGIN_NAME_SELECTIONS["data"]
                                    .length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      GeneralComponent(
                                        [
                                          buildTextContent(
                                              GenderLoginConstants
                                                      .GENDER_LOGIN_NAME_SELECTIONS[
                                                  "data"][index]["title"],
                                              true,
                                              fontSize: 16,
                                              colorWord: blackColor),
                                          GenderLoginConstants
                                                          .GENDER_LOGIN_NAME_SELECTIONS[
                                                      "data"][index]["subTitle"] !=
                                                  null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: buildTextContent(
                                                      GenderLoginConstants
                                                                  .GENDER_LOGIN_NAME_SELECTIONS[
                                                              "data"][index]
                                                          ["subTitle"],
                                                      false,
                                                      fontSize: 14,
                                                      colorWord: Colors.grey),
                                                )
                                              : const SizedBox()
                                        ],
                                        suffixWidget: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Radio(
                                              value: selectionList[index],
                                              groupValue: _selection,
                                              onChanged: (value) {
                                                setState(() {
                                                  _selection = value as String;
                                                });
                                              }),
                                        ),
                                        changeBackground: transparent,
                                        padding: const EdgeInsets.all(5),
                                        function: () {},
                                      ),
                                      buildDivider(color: Colors.grey)
                                    ],
                                  );
                                },
                              ),

                              buildSpacer(height: 10),
                              // tùy chọn thì hiện, ko thì ẩn
                              _selection == selectionList[2]
                                  ? Column(
                                      children: [
                                        // chọn danh xưng
                                        buildButtonForLoginWidget(
                                            bgColor: white,
                                            colorText: blackColor,
                                            width: width,
                                            isHaveBoder: true,
                                            title: _anonymousName == ""
                                                ? GenderLoginConstants
                                                    .GENDER_LOGIN_SELECTION_ANONYMOUS_NAME_PLACEHOLDER
                                                : _anonymousName,
                                            function: () {
                                              showBottomSheetCheckImportantSettings(
                                                  context,
                                                  250,
                                                  GenderLoginConstants
                                                      .GENDER_LOGIN_SELECTION_ANONYMOUS_NAME_PLACEHOLDER,
                                                  widget: StatefulBuilder(
                                                      builder: (context,
                                                          setStateFull) {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemCount: GenderLoginConstants
                                                      .GENDER_LOGIN_SELECTIONS_FOR_BOTTOM_SHEET[
                                                          "data"]
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        GeneralComponent(
                                                          [
                                                            buildTextContent(
                                                                GenderLoginConstants
                                                                            .GENDER_LOGIN_SELECTIONS_FOR_BOTTOM_SHEET[
                                                                        "data"][index]
                                                                    ["title"],
                                                                true,
                                                                fontSize: 16,
                                                                colorWord: Colors
                                                                    .orange),
                                                            GenderLoginConstants.GENDER_LOGIN_SELECTIONS_FOR_BOTTOM_SHEET["data"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "subTitle"] !=
                                                                    null
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            5.0),
                                                                    child: buildTextContent(
                                                                        GenderLoginConstants.GENDER_LOGIN_SELECTIONS_FOR_BOTTOM_SHEET["data"][index]
                                                                            [
                                                                            "subTitle"],
                                                                        false,
                                                                        fontSize:
                                                                            14,
                                                                        colorWord:
                                                                            Colors.grey),
                                                                  )
                                                                : const SizedBox()
                                                          ],
                                                          changeBackground:
                                                              Colors
                                                                  .transparent,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          function: () {
                                                            setState(() {
                                                              _anonymousName =
                                                                  GenderLoginConstants
                                                                              .GENDER_LOGIN_SELECTIONS_FOR_BOTTOM_SHEET["data"]
                                                                          [
                                                                          index]
                                                                      ["title"];
                                                            });
                                                            setStateFull(() {});
                                                            popToPreviousScreen(
                                                                context);
                                                          },
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 10,
                                                          ),
                                                          child: buildDivider(
                                                            color: white,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }));
                                            }),
                                        buildSpacer(height: 10),
                                        // nhạp giới tính input
                                        _buildTextFormField(
                                          GenderLoginConstants
                                              .GENDER_LOGIN_NAME_PLACEHOLODER,
                                        ),
                                        buildSpacer(height: 10),
                                        // mô tả
                                        buildTextContent(
                                            GenderLoginConstants
                                                .GENDER_LOGIN_DESCRIPTION,
                                            false,
                                            fontSize: 14,
                                            colorWord: Colors.grey),
                                      ],
                                    )
                                  : const SizedBox(),
                              buildButtonForLoginWidget(
                                  width: width,
                                  function: () {
                                    pushToNextScreen(context, PhoneLoginPage());
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildHaveAccountWidget(function: () {
            pushToNextScreen(context, MainLoginPage());
          })
        ]),
      ),
    );
  }
}

Widget _buildTextFormField(
    // TextEditingController controller,
    String placeHolder) {
  return SizedBox(
    height: 40,
    child: TextFormField(
      // controller: controller,
      onChanged: ((value) {}),
      obscureText:
          placeHolder == MainLoginConstants.MAIN_LOGIN_PASSWORD_PLACEHOLDER,
      decoration: InputDecoration(
          counterText: "",
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey, width: 0.6),
          ),
          hintText: placeHolder,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)))),
    ),
  );
}
