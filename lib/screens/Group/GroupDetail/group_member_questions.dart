import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widgets/Market/image_cache.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
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
  dynamic listAns;
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    await ref
        .read(groupListControllerProvider.notifier)
        .getMemberQuestion(widget.groupDetail["id"]);
    listQuestion = ref.read(groupListControllerProvider).memberQuestionList;
    /* inspect(ref.read(groupListControllerProvider));
    inspect(widget.groupDetail); */
    for (var element in listQuestion) {
      int index = listQuestion.indexOf(element);
      if (element["question_type"] == "multiple_choice") {
        listAns = [];
        for (int i = 0; i < element["options"].length; i++) {
          listAns.add(false);
        }
      } else {
        listAns = "";
      }

      switch (index) {
        case 0:
          question1 = listAns;
          break;
        case 1:
          question2 = listAns;
          break;
        case 2:
          question3 = listAns;
          break;
        default:
          break;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CupertinoActivityIndicator(),
      ),
      child: Scaffold(
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
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
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
                  listQuestion.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listQuestion.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return questionContainer(index, question1);
                            } else if (index == 1) {
                              return questionContainer(index, question2);
                            } else {
                              return questionContainer(index, question3);
                            }
                          },
                        )
                      : Center(
                          child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildCircularProgressIndicator(),
                        )),
                  const Divider(
                    height: 1,
                    color: greyColor,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: ButtonPrimary(
                          isGrey: true,
                          label: "Huỷ",
                          handlePress: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ButtonPrimary(
                          isGrey: validateForm(),
                          label: "Gửi",
                          handlePress: () async {
                            if (validateForm()) {
                            } else {
                              List<Map> params = [];
                              for (var items in listQuestion) {
                                int index = listQuestion.indexOf(items);
                                dynamic selected;
                                switch (index) {
                                  case 0:
                                    selected = convertAnswered(question1, 0);
                                    break;
                                  case 1:
                                    selected = convertAnswered(question2, 1);
                                    break;
                                  case 2:
                                    selected = convertAnswered(question3, 2);
                                    break;
                                }
                                var newItem = {
                                  "question_id": items["id"],
                                  "answer": selected
                                };
                                params.add(newItem);
                              }
                              context.loaderOverlay.show();
                              //Navigator.of(context).pop();
                              await GroupApi().joinGroupRequestWithParams(
                                  widget.groupDetail["id"],
                                  {"answers": params});
                              await ref
                                  .read(groupListControllerProvider.notifier)
                                  .updateGroupDetail(widget.groupDetail["id"]);
                              if (mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget questionContainer(index, question) {
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
                              setState(() {
                                setAnswer(index,
                                    listQuestion[index]["options"][indexGes]);
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
                                  groupValue: question,
                                  value: listQuestion[index]["options"]
                                      [indexGes],
                                  onChanged: (value) {
                                    setState(() {
                                      setAnswer(
                                          index,
                                          listQuestion[index]["options"]
                                              [indexGes]);
                                    });
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
                            onTap: () {
                              setState(() {
                                question[indexQuestion] =
                                    !question[indexQuestion];
                              });
                            },
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
                                  value: question[indexQuestion],
                                  activeColor: secondaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      question[indexQuestion] =
                                          !question[indexQuestion];
                                    });
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
                      onChanged: (value) {
                        setState(() {
                          setAnswer(index, value);
                        });
                      },
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

  validateForm() {
    var totalQuestion = listQuestion.length;
    if (totalQuestion > 0) {
      switch (totalQuestion) {
        case 1:
          if (checkQuesion(question1) == false) {
            return true;
          } else {
            return false;
          }
        case 2:
          if (checkQuesion(question1) == false ||
              checkQuesion(question2) == false) {
            return true;
          } else {
            return false;
          }
        case 3:
          if (checkQuesion(question1) == false ||
              checkQuesion(question2) == false ||
              checkQuesion(question3) == false) {
            return true;
          } else {
            return false;
          }
      }
    } else {
      return true;
    }
  }

  checkQuesion(myVar) {
    if (myVar is List) {
      if (myVar.contains(true)) {
        return true;
      } else {
        return false;
      }
    } else {
      if (myVar != "") {
        return true;
      } else {
        return false;
      }
    }
  }

  setAnswer(index, answered) {
    switch (index) {
      case 0:
        question1 = answered;
        break;
      case 1:
        question2 = answered;
        break;
      case 2:
        question3 = answered;
        break;
      default:
        break;
    }
  }

  convertAnswered(answered, index) {
    if (answered is List) {
      List answeredSelected = [];
      for (int i = 0; i < answered.length; i++) {
        if (answered[i] == true) {
          answeredSelected.add(listQuestion[index]["options"][i]);
        }
      }
      return answeredSelected;
    } else {
      return answered.split(",");
    }
  }
}
