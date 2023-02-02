import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/constant/page_constants.dart';
import 'package:social_network_app_mobile/providers/select_province_page_bloc.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreateModules/screen/avatar_page_page.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';import 'package:social_network_app_mobile/screen/Page/PageCreateModules/screen/avatar_page_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_with_button_and_chip_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class InformationPagePage extends StatefulWidget {
  @override
  State<InformationPagePage> createState() => _InformationPagePageState();
}

class _InformationPagePageState extends State<InformationPagePage> {
  late double width = 0;
  late double height = 0;
  List<int> radioGroupWorkTime = [0, 1, 2];
  final _informationKey = GlobalKey<FormState>();

  int currentValue = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [BackIconAppbar(), SizedBox()],
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GestureDetector(
          onTap: (() {
            FocusManager.instance.primaryFocus!.unfocus();
          }),
          child: Column(children: [
            Container(
              height: height * 0.78055,
              // color: Colors.black87,
              child: ListView(
                children: [
                  Container(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Form(
                        key: _informationKey,
                        child: Column(
                          children: [
                            // set up page title
                            Row(
                              children: [
                                Text(
                                  InformationPageConstants.TITLE_INFO[0],
                                  style: const TextStyle(
                                      // color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            buildSpacer(
                              height: 10,
                            ),
                            // congratulation subtitle
                            Text(InformationPageConstants.TITLE_INFO[1],
                                style: const TextStyle(
                                    // color: Colors.white,
                                    fontSize: 18)),
                            buildSpacer(
                              height: 10,
                            ),
                            // chung
                            _buildTitlePart(CupertinoIcons.info_circle_fill,
                                [InformationPageConstants.TITLE_INFO[2]]),
                            _buildTextFormField(
                                InformationPageConstants.PLACEHOLDER_INFO[0]),
                            // mo ta ve trang cua ban
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Text("Mô tả về Trang của bạn",
                                      style: const TextStyle(
                                          // color: Colors.white,
                                          fontSize: 14)),
                                ],
                              ),
                            ),
                            buildSpacer(
                              height: 20,
                            ),
                            // Thong tin lien he
                            // trang web input
                            _buildTitlePart(Icons.person,
                                [InformationPageConstants.TITLE_INFO[3]]),
                            _buildTextFormField(
                                InformationPageConstants.PLACEHOLDER_INFO[1]),
                            buildSpacer(
                              height: 10,
                            ),
                            //email input
                            _buildTextFormField(
                                InformationPageConstants.PLACEHOLDER_INFO[2]),
                            buildSpacer(
                              height: 10,
                            ),
                            //sdt input
                            _buildTextFormField(
                                InformationPageConstants.PLACEHOLDER_INFO[3]),
                            buildSpacer(
                              height: 10,
                            ),

                            // Vi tri title
                            _buildTitlePart(Icons.location_on,
                                [InformationPageConstants.TITLE_INFO[4]]),
                            //vi tri input
                            _buildTextFormField(
                                InformationPageConstants.PLACEHOLDER_INFO[4]),
                            buildSpacer(
                              height: 10,
                            ),
                            // tinh, thanh pho input
                            _buildProviceInput(context,
                                InformationPageConstants.PLACEHOLDER_INFO[5]),
                            buildSpacer(
                              height: 10,
                            ),
                            // ma zip input
                            _buildTextFormField(
                                InformationPageConstants.PLACEHOLDER_INFO[6]),
                            buildSpacer(
                              height: 10,
                            ),
                            // gio lam viec
                            _buildTitlePart(Icons.timelapse_rounded, [
                              InformationPageConstants.TITLE_INFO[5],
                              InformationPageConstants.SUB_TITLE_WORK_TIME
                            ]),
                            // ko co gio lam viec
                            _buildRadioWorkTime(0),
                            // luon mo cua
                            _buildRadioWorkTime(1),
                            // gio lam viec tieu chuan
                            _buildRadioWorkTime(2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildBottomNavigatorWithButtonAndChipWidget(
                context: context,
                width: width,
                newScreen: AvatarPage(),
                isPassCondition: _informationKey.currentState == null
                    ? true
                    : _informationKey.currentState!.validate(),
                title: "Tiếp",
                currentPage: 3)
          ]),
        ));
  }

  Widget _buildProviceInput(BuildContext context, String title) {
    return GestureDetector(
      onTap: (() {
        _showBottomSheetForSelectProvince(context);
      }),
      child: Container(
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(color: Colors.black)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  buildSpacer(
                    width: 10,
                  ),
                  Text(title,
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.caretDown,
                    color: Colors.grey[800],
                  ),
                  buildSpacer(
                    width: 10,
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildTextFormField(
      // TextEditingController controller,
      String placeHolder) {
    return TextFormField(
      maxLength: placeHolder == InformationPageConstants.PLACEHOLDER_INFO[3]
          ? 10
          : 10000,
      // controller: controller,
      onChanged: ((value) {}),
      validator: (value) {
        if (value != null) {
          if (value.trim().length > 0) {
            if (placeHolder == InformationPageConstants.PLACEHOLDER_INFO[1]) {
              // validate web link
              String pattern =
                  r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
              RegExp regExp = RegExp(pattern);
              if (regExp.hasMatch(value as String)) {
                return "Đường dẫn không hợp lệ";
              }
            } else if (placeHolder ==
                InformationPageConstants.PLACEHOLDER_INFO[2]) {
              // validate email

              if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value as String)) {
                return "Email không hợp lệ";
              }
            } else if (placeHolder ==
                InformationPageConstants.PLACEHOLDER_INFO[3]) {
              // validate phone
            } else if (placeHolder ==
                InformationPageConstants.PLACEHOLDER_INFO[6]) {
              // validate ma zip
            } else {}
          }
        }
      },
      // style: const TextStyle(color: Colors.white),
      keyboardType: placeHolder == InformationPageConstants.PLACEHOLDER_INFO[3]
          ? TextInputType.number
          : null,
      decoration: InputDecoration(
          suffix: placeHolder == InformationPageConstants.PLACEHOLDER_INFO[5]
              ? Icon(
                  // Icons.next_plan,
                  CupertinoIcons.greaterthan,
                  color: Colors.white,
                )
              : null,
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          hintText: placeHolder,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 30),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }

  Widget _buildRadioWorkTime(int indexOfRadio) {
    return RadioListTile(
      groupValue: currentValue,
      title: Text(
        InformationPageConstants.CONTENT_OF_WORK_TIME[indexOfRadio][0],
        style: TextStyle(
            // color: Colors.white,
            fontSize: 17),
      ),
      subtitle: Text(
        InformationPageConstants.CONTENT_OF_WORK_TIME[indexOfRadio][1],
        style: TextStyle(
            // color: Colors.grey,
            fontSize: 15),
      ),
      onChanged: ((value) {
        setState(() {
          currentValue = value as int;
        });
      }),
      value: radioGroupWorkTime[indexOfRadio],
    );
  }

  Widget _buildTitlePart(IconData icon, List<String> listValue) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Flexible(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
          Flexible(
            flex: 20,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: listValue.map(
                  (value) {
                    if (value == InformationPageConstants.SUB_TITLE_WORK_TIME) {
                      return Row(
                        children: [
                          Text(value,
                              style: const TextStyle(
                                  // color: Colors.grey,
                                  fontSize: 15)),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Text(value,
                            style: const TextStyle(
                                // color: Colors.white,
                                fontSize: 18)),
                      ],
                    );
                  },
                ).toList()),
          ),
        ],
      ),
    );
  }

  _showBottomSheetForSelectProvince(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateFull) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: height * 0.8,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
              child: Column(children: [
                // drag and drop navbar
                Container(
                  padding: EdgeInsets.only(top: 5),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15))),
                  ),
                ),
                // province input

                Container(
                  height: 80,
                  child: TextFormField(
                    // controller: controller,
                    onChanged: ((value) {
                      context
                          .read<SelectProvinceProvider>()
                          .setSelectProvinceProvider(value);
                    }),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        hintText: "Tìm kiếm tỉnh/ thành phố/ thị xã/ thị trấn",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 30),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                ),
                Container(
                    height: 250,
                    child: ListView.builder(
                        itemCount: Provider.of<SelectProvinceProvider>(context)
                            .selectList
                            .length,
                        itemBuilder: ((context, index) {
                          if (Provider.of<SelectProvinceProvider>(context)
                                  .selectList
                                  .length !=
                              0) {
                            return Container(
                              padding: EdgeInsets.only(left: 10),
                              height: 40,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Text(
                                        Provider.of<SelectProvinceProvider>(
                                                context)
                                            .selectList[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  )),
                                  Divider(
                                    height: 2,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            );
                          }
                          return Center(
                              child: Text(" Không có dữ liệu",
                                  style: TextStyle(color: Colors.white)));
                        }))),
              ]),
            );
          });
        });
  }
}
