import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/Memories/memories_block_page.dart';
import 'package:social_network_app_mobile/screens/Page/PageCreate/CreateStep/settting_page_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class MemoriesSetting extends StatefulWidget {
  const MemoriesSetting({
    Key? key,
  }) : super(key: key);

  @override
  State<MemoriesSetting> createState() => _MemoriesSettingState();
}

class _MemoriesSettingState extends State<MemoriesSetting> {
  final radioOptions = [
    NotificationOptions(
        0, "Tất cả kỷ niệm", "Chúng tôi sẽ chỉ thông báo một lần mỗi ngày."),
    NotificationOptions(1, "Nổi bật",
        "Chúng tôi sẽ cập nhật thông tin định kỳ cho bạn về một số kỷ niệm."),
    NotificationOptions(
        2, "Không có", "Chúng tôi sẽ không thông báo về kỷ niệm."),
  ];
  int _selectedOption = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
          ],
        ),
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Cài đặt về kỉ niệm",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Thông báo",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Text(
                    "Bạn có thể chọn tần suất nhận thông báo về kỷ niệm của mình.",
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: radioOptions.length,
                    itemBuilder: (context, index) {
                      final option = radioOptions[index];
                      return RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(option.title,
                            style: const TextStyle(fontSize: 15)),
                        subtitle: Text(option.description,
                            style: const TextStyle(
                                fontSize: 15, color: greyColor)),
                        value: option.key,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => secondaryColor),
                        groupValue: _selectedOption,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                      );
                    },
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Ẩn kỷ niệm",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Text(
                    "Bạn có thể chọn ẩn những kỷ niệm liên quan đến những người và ngày mình không muốn xem.",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          //fullscreenDialog: true,
                          builder: (context) {
                            return const MemoriesBlocked();
                          },
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.people_alt),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mọi người",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Đã ẩn 0 người",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: greyColor),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  top: 8,
                  right: 16,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 22,
                  ), //CircularAvatar
                ),
              ],
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationOptions {
  final int key;
  final String title;
  final String description;
  NotificationOptions(this.key, this.title, this.description);
}
