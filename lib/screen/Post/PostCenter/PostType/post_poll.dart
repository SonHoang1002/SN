import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';

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
            functionAdditional != null ? functionAdditional!() : null;
          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(width: 0.4, color: greyColor)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 13),
              margin: const EdgeInsets.fromLTRB(8.0, 15, 8, 0),
              child: Column(
                children: [
                  SizedBox(
                    height: pollData["options"].length * 50.0,
                    child: ListView.builder(
                        itemCount: pollData["options"].length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = pollData["options"][index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: const BoxDecoration(),
                            child: _buildInputPoll(
                                index,
                                TextEditingController(text: data ),
                                "Lựa chọn ${index + 1}"),
                          );
                        }),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(width: 0.4, color: greyColor)),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: buildTextContent(
                        "+ Thêm lựa chọn thăm dò ý kiến...", false,
                        fontSize: 17),
                  ),
                ],
              )),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              functionClose != null ? functionClose!() : null;
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
