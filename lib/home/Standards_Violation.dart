import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/common.dart';
import '../constant/standard_violation_constants.dart';
import '../theme/colors.dart';
import '../widgets/avatar_social.dart';

class AlertDialogUtils {
  static void showAlertDialog(BuildContext context, dynamic dataFilter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber,
                color: primaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: Post_violation_constants.POST_VIOLATION_TITLE,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Divider(),
        ],
      ),
              content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(
                  text: Post_violation_constants.POST_VIOLATION_CONTENT[0],
                ),
                TextSpan(text: Post_violation_constants.POST_VIOLATION_CONTENT[1]),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 0.1, color: greyColor),
                      ),
                      child: AvatarSocial(
                          width: 50,
                          height: 50,
                          path: dataFilter[0]['account']['avatar_media']
                              ['preview_url']),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            dataFilter[0]['account']["display_name"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  typeVisibility[0]['icon'],
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                typeVisibility[0]['label'],
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[600]),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Text(
                  dataFilter[0]["status"]["content"],
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          const Divider()
        ],
      ),
              actions: [
                ElevatedButton(
                  child: const Text("Tiếp tục"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    alertHowToDecideDialog(context, dataFilter);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void alertHowToDecideDialog(BuildContext context, dynamic dataFilter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        text: How_to_decide.HOW_TO_DECISION_TITLE),
                  ),
                  Divider(),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline_rounded),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                              text: How_to_decide.NOTICE_HOW_TO_DECIDE[0]),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.shield),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                              text: How_to_decide.NOTICE_HOW_TO_DECIDE[1]),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.public),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                              text: How_to_decide.NOTICE_HOW_TO_DECIDE[2]),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider()
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFB0B2B5), // Đặt màu cho nút
                    // Các thuộc tính khác của nút như textColor, textStyle, padding, borderRadius, v.v. cũng có thể được chỉnh sửa ở đây nếu cần.
                  ),
                  child: const Text("Quay lại"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showAlertDialog(context, dataFilter);
                  },
                ),
                ElevatedButton(
                  child: const Text("tiếp tục"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    alertDecideStandardsDialog(context,dataFilter);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void alertDecideStandardsDialog(BuildContext context,dynamic dataFilter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        text: Decision_criteria.POST_DECISION_STANDARDS_TITLE),
                  ),
                  const Divider(),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              text: Decision_criteria
                                  .POST_DECISIONZ_STANDARDS_CONTENT),
                          TextSpan(
                            text: Decision_criteria.STANDARDS_DECISION[0],
                          ),
                          TextSpan(
                            text: Decision_criteria.STANDARDS_DECISION[1],
                          ),
                          TextSpan(
                            text: Decision_criteria.STANDARDS_DECISION[2],
                          ),
                          TextSpan(
                            text: Decision_criteria.STANDARDS_DECISION[3],
                          ),
                          TextSpan(
                            text: Decision_criteria.STANDARDS_DECISION[4],
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider()
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFB0B2B5), // Đặt màu cho nút
                    // Các thuộc tính khác của nút như textColor, textStyle, padding, borderRadius, v.v. cũng có thể được chỉnh sửa ở đây nếu cần.
                  ),
                  child: const Text("Quay lại"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    alertHowToDecideDialog(context, dataFilter);
                  },
                ),
                ElevatedButton(
                  child: const Text("tiếp tục"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showAlertDecisionDialog(context,dataFilter);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void showAlertDecisionDialog(BuildContext context,dynamic dataFilter) {
    int? selectedValue = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: Decision.POST_DECISION_TITLE,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                          text: Decision.POST_DECISION_CONTENT,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: <Widget>[
                      Container(
                        decoration: selectedValue == 1
                            ? BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(10))
                            : null,
                        child: SimpleDialogOption(
                          onPressed: () {
                            // Navigator.pop(context,);
                            setState(() {
                              selectedValue = 1;
                            });
                          },
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                  text: Decision.ACCEPT_THE_DECISION[0],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: Decision.ACCEPT_THE_DECISION[1],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: selectedValue == 2
                            ? BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(10))
                            : null,
                        child: SimpleDialogOption(
                          onPressed: () {
                            // Navigator.pop(context);
                            setState(() {
                              selectedValue = 2;
                            });
                          },
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                  text: Decision.NOT_ACCEPT_THE_DECISION[0],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: Decision.NOT_ACCEPT_THE_DECISION[1],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider()
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFB0B2B5), // Đặt màu cho nút
                    // Các thuộc tính khác của nút như textColor, textStyle, padding, borderRadius, v.v. cũng có thể được chỉnh sửa ở đây nếu cần.
                  ),
                  child: const Text("Quay lại"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    alertDecideStandardsDialog(context,dataFilter);
                  },
                ),
                ElevatedButton(
                  child: const Text("Tiếp tục"),
                  onPressed: () {
                    if (selectedValue == 1) {
                      Navigator.of(context).pop();
                      alertAcceptDecisionDialog(context,dataFilter);
                    } else {
                      Navigator.of(context).pop();
                      alertNotAcceptDecisionDialog(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void alertAcceptDecisionDialog(BuildContext context,dynamic dataFilter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: Accept_Decision.POST_ACCEPT_DECISION_TITLE,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                          text: Accept_Decision.POST_ACCEPT_DECISION_CONTENT,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.dangerous_outlined,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                    text: Accept_Decision
                                        .NOTICE_OF_ACCEPT_THE_DECISION[0],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: Accept_Decision
                                      .NOTICE_OF_ACCEPT_THE_DECISION[1],
                                ),
                                TextSpan(
                                    text: Accept_Decision
                                        .NOTICE_OF_ACCEPT_THE_DECISION[2],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider()
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFB0B2B5), // Đặt màu cho nút
                    // Các thuộc tính khác của nút như textColor, textStyle, padding, borderRadius, v.v. cũng có thể được chỉnh sửa ở đây nếu cần.
                  ),
                  child: const Text("Quay lại"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showAlertDecisionDialog(context,dataFilter);
                  },
                ),
                ElevatedButton(
                  child: const Text("Chấp nhận quyết định"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void alertNotAcceptDecisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        text: Not_accept_decision.POST_ACCEPT_DECISION_TITLE),
                  ),
                  Divider(),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                          text: Not_accept_decision
                              .NOTICE_OF_ACCEPT_THE_DECISION[0],
                        ),
                        TextSpan(
                            text: Not_accept_decision
                                .NOTICE_OF_ACCEPT_THE_DECISION[1]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Divider()
                ],
              ),
              actions: [
                ElevatedButton(
                  child: Text("Đóng"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
