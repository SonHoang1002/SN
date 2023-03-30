import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/providers/page/select_province_page_provider.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_button_chip.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import '../../../../constant/page_constants.dart';
import '../../../../theme/colors.dart';
import 'avatar_page_page.dart';

class InformationPagePage extends StatefulWidget {
  const InformationPagePage({super.key});

  @override
  State<InformationPagePage> createState() => _InformationPagePageState();
}

class _InformationPagePageState extends State<InformationPagePage> {
  late double width = 0;
  late double height = 0;
  List<int> radioGroupWorkTime = [0, 1, 2];
  final _informationKey = GlobalKey<FormState>();

  List infoField = [
    {
      'title': 'Chung',
      'iconTitle': Icons.info,
      'description': 'Mô tả về Trang của bạn',
      'placeholder': 'Tiểu sử'
    },
    {
      'title': 'Thông tin liên hệ',
      'iconTitle': Icons.card_giftcard,
      'description': null,
      'placeholder': 'Trang web'
    },
    {
      'title': null,
      'iconTitle': null,
      'description': null,
      'placeholder': 'Email'
    },
    {
      'title': null,
      'iconTitle': null,
      'description': null,
      'placeholder': 'Số điện thoại'
    },
    {
      'title': 'Vị trí',
      'iconTitle': Icons.location_history,
      'description': null,
      'placeholder': 'Địa chỉ'
    },
    {
      'title': null,
      'iconTitle': null,
      'description': null,
      'placeholder': 'Mã ZIP'
    },
    {
      'type': 'radio',
      'title': 'Giờ làm việc',
      'iconTitle': Icons.watch,
      'description': 'Thông báo về giờ làm việc tại vị trí của bạn.',
      'options': [
        {
          'title': 'Không có giờ làm việc',
          'description': 'Không hiển thị giờ làm việc.',
          'value': 0
        },
        {
          'title': 'Luôn mở cửa',
          'description': 'Bạn đang mở cửa 24 giờ mỗi ngày.',
          'value': 1
        },
        {
          'title': 'Giờ làm việc tiêu chuẩn',
          'description': 'Nhập khung giờ cụ thể',
          'value': 2
        },
      ]
    },
    {'type': 'blank'}
  ];

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
              // margin: EdgeInsets.only(bottom: 50),
              // color: Colors.black87,
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
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
                                    // color:  white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          buildSpacer(
                            height: 10,
                          ),
                          // congratulation subtitle
                          const Text(
                              'Thành công rồi! Bạn đã tạo trang thành công. Hãy bổ sung thông tin chi tiết để mọi người dễ dàng kết nối với bạn nhé.',
                              style: TextStyle(fontSize: 17)),
                          buildSpacer(
                            height: 10,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: infoField.length,
                            itemBuilder: (context, index) =>
                                infoField[index]['type'] == 'blank'
                                    ? const SizedBox(
                                        height: 50,
                                      )
                                    : infoField[index]['type'] == 'radio'
                                        ? _buildRadioWorkTime(
                                            infoField[index]['title'],
                                            infoField[index]['iconTitle'],
                                            infoField[index]['description'],
                                            infoField[index]['options'])
                                        : _buildTextFormField(
                                            infoField[index]['title'],
                                            infoField[index]['iconTitle'],
                                            infoField[index]['description'],
                                            infoField[index]['placeholder']),
                          ),

                          // // gio lam viec
                          // _buildTitlePart(Icons.timelapse_rounded, [
                          //   InformationPageConstants.TITLE_INFO[4],
                          //   InformationPageConstants.SUB_TITLE_WORK_TIME
                          // ]),
                          // // ko co gio lam viec
                          // _buildRadioWorkTime(0),
                          // // luon mo cua
                          // _buildRadioWorkTime(1),
                          // // gio lam viec tieu chuan
                          // _buildRadioWorkTime(2),
                        ],
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

  // Widget _buildProviceInput(BuildContext context, String title) {
  //   return GestureDetector(
  //     onTap: (() {
  //       _showBottomSheetForSelectProvince(context);
  //     }),
  //     child: Container(
  //         height: 60,
  //         decoration: BoxDecoration(
  //             borderRadius: const BorderRadius.all(
  //               Radius.circular(5),
  //             ),
  //             border: Border.all(color: Colors.black)),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 buildSpacer(
  //                   width: 10,
  //                 ),
  //                 Text(title,
  //                     style: TextStyle(color: Colors.grey, fontSize: 16)),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 Icon(
  //                   FontAwesomeIcons.caretDown,
  //                   color: Colors.grey[800],
  //                 ),
  //                 buildSpacer(
  //                   width: 10,
  //                 ),
  //               ],
  //             ),
  //           ],
  //         )),
  //   );
  // }

  Widget _buildTextFormField(
      // TextEditingController controller,
      String? title,
      IconData? iconTitle,
      String? description,
      String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          if (iconTitle != null && title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey[400]),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(right: 8),
                    child: Icon(
                      iconTitle,
                      size: 18,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
          TextFormField(
            maxLength:
                placeholder == InformationPageConstants.PLACEHOLDER_INFO[3]
                    ? 10
                    : 10000,
            // controller: controller,
            onChanged: ((value) {}),
            validator: (value) {
              if (value != null) {
                if (value.trim().isNotEmpty) {
                  if (placeholder ==
                      InformationPageConstants.PLACEHOLDER_INFO[1]) {
                    // validate web link
                    String pattern =
                        r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
                    RegExp regExp = RegExp(pattern);
                    if (regExp.hasMatch(value as String)) {
                      return "Đường dẫn không hợp lệ";
                    }
                  } else if (placeholder ==
                      InformationPageConstants.PLACEHOLDER_INFO[2]) {
                    // validate email

                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value as String)) {
                      return "Email không hợp lệ";
                    }
                  } else if (placeholder ==
                      InformationPageConstants.PLACEHOLDER_INFO[3]) {
                    // validate phone
                  } else if (placeholder ==
                      InformationPageConstants.PLACEHOLDER_INFO[6]) {
                    // validate ma zip
                  } else {}
                }
              }
            },
            // style: const TextStyle(color:  white),
            keyboardType:
                placeholder == InformationPageConstants.PLACEHOLDER_INFO[3]
                    ? TextInputType.number
                    : null,
            decoration: InputDecoration(
                suffix:
                    placeholder == InformationPageConstants.PLACEHOLDER_INFO[5]
                        ? Icon(
                            // Icons.next_plan,
                            CupertinoIcons.greaterthan,
                            color: white,
                          )
                        : null,
                counterText: "",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                hintText: placeholder,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 30),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioWorkTime(
      String title, IconData iconTitle, String description, List options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey[400]),
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(right: 8),
                child: Icon(
                  iconTitle,
                  size: 18,
                ),
              ),
              Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(description, style: const TextStyle(fontSize: 15))
                ],
              )
            ],
          ),
          // if (options.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => RadioListTile(
                groupValue: currentValue,
                title: Text(
                  options[index]['title'],
                  style: const TextStyle(fontSize: 17),
                ),
                subtitle: Text(
                  options[index]['description'],
                  style: const TextStyle(fontSize: 15),
                ),
                onChanged: ((value) {
                  setState(() {
                    currentValue = value as int;
                  });
                }),
                value: radioGroupWorkTime[1],
              ),
              itemCount: options.length,
            ),
          ),
        ],
      ),
    );
  }

  _showBottomSheetForSelectProvince(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: transparent,
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
                    style: const TextStyle(color: white),
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
                                          color: white,
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  )),
                                  Divider(
                                    height: 2,
                                    color: white,
                                  )
                                ],
                              ),
                            );
                          }
                          return Center(
                              child: Text(" Không có dữ liệu",
                                  style: TextStyle(color: white)));
                        }))),
              ]),
            );
          });
        });
  }
}
