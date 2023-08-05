import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class MemoriesBlocked extends StatefulWidget {
  const MemoriesBlocked({
    Key? key,
  }) : super(key: key);

  @override
  State<MemoriesBlocked> createState() => _MemoriesSettingState();
}

class _MemoriesSettingState extends State<MemoriesBlocked> {
  TextEditingController textFieldController = TextEditingController();
  Timer? _debounceTimer;

  void _onTextChanged(String value) {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    textFieldController.dispose();
    super.dispose();
  }

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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Mọi người",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  "Hãy cho biết bạn không muốn thấy ai trong kỷ niệm của mình. Chúng tôi sẽ không gửi thông báo cho họ.",
                  style: TextStyle(fontSize: 15, color: greyColor),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  size: 30,
                  color: greyColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: textFieldController,
                    onChanged: _onTextChanged,
                    style: const TextStyle(color: greyColor),
                    decoration: const InputDecoration(
                      hintText: "Bắt đầu nhập tên",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          textFieldController.text.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        size: 100,
                      ),
                      Text(
                          "Không tìm thấy kết quả nào cho ${textFieldController.text}"),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
