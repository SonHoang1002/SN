import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

class PostPoll extends StatelessWidget {
  final dynamic pollData;
  final Function? functionAdditional;
  final Function? functionClose;
  const PostPoll(
      {Key? key, this.pollData, this.functionAdditional, this.functionClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Stack(children: [
        GestureDetector(
          onTap: () {
            pollData['id'] == null
                ? functionAdditional != null
                    ? functionAdditional!()
                    : null
                : null;
          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(width: 0.4, color: greyColor)),
              padding: const EdgeInsets.fromLTRB(6.0, 15, 6.0, 12),
              margin: const EdgeInsets.fromLTRB(8.0, 15, 8, 0),
              child: Column(
                children: [
                  SizedBox(
                    // height: pollData["options"].length * 50.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: pollData["options"].length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = pollData["options"][index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: const BoxDecoration(),
                            child: _buildInputPoll(
                                index,
                                TextEditingController(
                                    text:
                                        data is String ? data : data['title']),
                                "Lựa chọn ${index + 1}"),
                          );
                        }),
                  ),
                  // pollData['id'] == null
                  //     ?
                       Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(width: 0.4, color: greyColor)),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.fromLTRB(8, 5, 8, 3),
                          child: buildTextContent(
                              "+ Thêm lựa chọn thăm dò ý kiến...", false,
                              fontSize: 17),
                        )
                      // : const SizedBox(),
                ],
              )),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              pollData['id'] == null
                  ? functionClose != null
                      ? functionClose!()
                      : null
                  : null;
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: greyColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                FontAwesomeIcons.xmark,
                color: white,
                size: 20,
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget _buildInputPoll(
    int index,
    TextEditingController controller,
    String hintText, {
    double? height,
  }) {
    return Row(
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: height ?? 40,
            child: TextFormField(
              controller: controller,
              maxLines: null,
              readOnly: true,
              onChanged: (value) {},
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                prefixIcon: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                hintText: hintText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
