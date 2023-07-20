import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../theme/theme_manager.dart';
import '../../../../widgets/appbar_title.dart';
import '../../../../widgets/back_icon_appbar.dart';
import '../../../../widgets/button_primary.dart';
import 'package:provider/provider.dart' as pv;

class AddLifeEvent extends ConsumerStatefulWidget {
  final String type;
  const AddLifeEvent({super.key, required this.type});

  @override
  AddLifeEventState createState() => AddLifeEventState();
}

class AddLifeEventState extends ConsumerState<AddLifeEvent> {
  bool isLoading = false;
  String title = '';

  Widget buildTitleBox(
      Size size, String title, Function onHandle, ThemeManager theme) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(
        //     builder: (context) => ConfirmAddSchool(eventTitle: title),
        //   ),
        // );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.35,
            color: theme.isDarkMode ? Colors.white54 : Colors.black54,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: size.height * 0.07,
        width: double.infinity,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w400,
                color: theme.isDarkMode ? Colors.white54 : Colors.black54),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            const AppBarTitle(title: "Tạo sự kiện trong đời"),
            ButtonPrimary(
              label: isLoading ? null : "Lưu",
              icon: isLoading
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : null,
              handlePress: () {},
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 17.5),
                height: size.height * 0.35,
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: widget.type == 'study'
                          ? SvgPicture.network(
                              'https://media.emso.vn/sn/hoc_van_lm.svg',
                              height: 100,
                              width: 100,
                            )
                          : SvgPicture.network(
                              'https://media.emso.vn/sn/cong_viec_lm.svg',
                              height: 100,
                              width: 100,
                            ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tiêu đề của bạn',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 7.5),
                          Text(
                            'Ví dụ: bạn cùng phòng mới, nhà mới, xe hơi mới ...',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: theme.isDarkMode
                                  ? Colors.white54
                                  : Colors.black54,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12.5),
                            height: 80.0,
                            child: CupertinoTextField(
                              placeholder: "Nhập tiêu đề ...",
                              placeholderStyle: const TextStyle(
                                color: CupertinoColors.placeholderText,
                                fontSize: 16.5,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  title = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Hoặc sử dụng tiêu đề gợi ý',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: theme.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              widget.type == 'study'
                  ? Column(
                      children: [
                        buildTitleBox(size, "Thôi học", () {}, theme),
                        buildTitleBox(size, "Đã tốt nghiệp", () {}, theme),
                        buildTitleBox(size, "Trường mới", () {}, theme),
                      ],
                    )
                  : const SizedBox(),
              widget.type == 'work'
                  ? Column(
                      children: [
                        buildTitleBox(size, "Nghỉ hưu", () {}, theme),
                        buildTitleBox(size, "Nghỉ việc", () {}, theme),
                        buildTitleBox(size, "Thăng chức", () {}, theme),
                        buildTitleBox(size, "Công việc mới", () {}, theme),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
