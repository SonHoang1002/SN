import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/Market/image_cache.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';

class GroupMemberQuestions extends ConsumerStatefulWidget {
  final dynamic groupDetail;
  const GroupMemberQuestions({super.key, required this.groupDetail});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupMemberQuestionsState();
}

class _GroupMemberQuestionsState extends ConsumerState<GroupMemberQuestions> {
  List<dynamic> listQuestion = [];
  dynamic question1;
  dynamic question2;
  dynamic question3;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    await ref
        .read(groupListControllerProvider.notifier)
        .getMemberQuestion(widget.groupDetail["id"]);

    inspect(ref.read(groupListControllerProvider));
    inspect(widget.groupDetail);
    List<ListItem> listAns = [];
    if (listQuestion[1]["question_type"] == "multiple_choice") {
      for (int i = 0; i < listQuestion[1]["options"].length; i++) {
        String name = listQuestion[1]["options"][i];
        bool isChecked = false;

        ListItem item = ListItem(name, isChecked);
        listAns.add(item);
      }
      question2 = listAns;
    }
  }

  @override
  Widget build(BuildContext context) {
    listQuestion = ref.watch(groupListControllerProvider).memberQuestionList;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppBarTitle(
            title: "Trả lời câu hỏi",
          ),
          leading: const BackIconAppbar(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(width: 0.3, color: greyColor)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: ImageCacheRender(
                          path: widget.groupDetail['banner'] != null
                              ? (widget.groupDetail?['banner']
                                      ?['preview_url']) ??
                                  (widget.groupDetail?['banner']?['url'])
                              : linkBannerDefault,
                          width: 34.0,
                          height: 34.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.groupDetail['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 1.0,
                                    right: 5.0,
                                  ),
                                  child: Icon(
                                    Icons.lock,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: widget.groupDetail['is_private'] == true
                                    ? 'Nhóm Riêng tư'
                                    : 'Nhóm Công khai',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' \u{2022} ${widget.groupDetail['member_count']} thành viên',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: greyColorOutlined,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    "Yêu cầu tham gia của bạn đang chờ phê duyệt. Hãy trả lời những câu hỏi sau của quản trị viên nhóm để họ có thể xem xét yêu cầu tham gia của bạn. Câu trả lời của bạn sẽ chỉ hiển thị với quản trị viên và người kiểm duyệt.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Không nhập mật khẩu hoặc thông tin nhạy cảm khác tại đây, ngay cả khi quản trị viên nhóm ${widget.groupDetail['title']} yêu cầu.",
                  style: const TextStyle(color: greyColor, fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listQuestion.length,
                  itemBuilder: (context, index) {
                    return questionContainer(index);
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget questionContainer(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Câu hỏi ${index + 1}. ${listQuestion[index]["question_text"]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          listQuestion[index]["question_type"] == "checkboxes"
              ? Column(
                  children: List.generate(
                      listQuestion[index]["options"].length,
                      (indexGes) => GestureDetector(
                            onTap: () {
                              //Navigator.pop(context);
                              setState(() {
                                question1 =
                                    listQuestion[index]["options"][indexGes];
                              });
                            },
                            child: ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 0.0),
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -1),
                              title:
                                  Text(listQuestion[index]["options"][indexGes],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      )),
                              trailing: Radio(
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => secondaryColor),
                                  groupValue: question1,
                                  value: listQuestion[index]["options"]
                                      [indexGes],
                                  onChanged: (value) {
                                    setState(() {
                                      question1 = value;
                                    });
                                    //Navigator.pop(context);
                                  }),
                            ),
                          )),
                )
              : listQuestion[index]["question_type"] == "multiple_choice"
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listQuestion[index]["options"].length,
                      shrinkWrap: true,
                      itemBuilder: (context, indexQuestion) => GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  listQuestion[index]["options"][indexQuestion],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Checkbox(
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => const BorderSide(
                                        width: 2.0, color: secondaryColor),
                                  ),
                                  value: question2 != null
                                      ? question2[indexQuestion].isChecked
                                      : false,
                                  activeColor: secondaryColor,
                                  onChanged: (value) {
                                    question2[indexQuestion].isChecked =
                                        !question2[indexQuestion].isChecked;
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ))
                  : TextFormField(
                      enabled: true,
                      autofocus: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Câu trả lời của bạn',
                      ),
                      maxLines: 3,
                    ),
          const Divider(
            height: 1,
            color: greyColor,
          )
        ],
      ),
    );
  }
}

class ListItem {
  String name;
  bool isChecked;

  ListItem(this.name, this.isChecked);
}
