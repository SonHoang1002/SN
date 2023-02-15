import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

class QuestionAnwer extends StatefulWidget {
  final String type;
  final dynamic handleUpdateData;
  const QuestionAnwer({Key? key, this.handleUpdateData, required this.type})
      : super(key: key);

  @override
  State<QuestionAnwer> createState() => _QuestionAnwerState();
}

class _QuestionAnwerState extends State<QuestionAnwer> {
  dynamic gradientSelected = colorsGradient[0];
  String question = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        hiddenKeyboard(context);
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width - 30,
                height: size.width + 70,
                decoration: BoxDecoration(
                    gradient: gradientSelected['gradient'],
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.type == 'target'
                        ? SvgPicture.asset(
                            "assets/target.svg",
                            width: size.width * 0.35,
                            height: size.width * 0.35,
                          )
                        : AvatarSocial(
                            width: size.width * 0.35,
                            height: size.width * 0.35,
                            path: meData['avatar_media']['preview_url']),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        autofocus: true,
                        onChanged: (value) {
                          if (value.length <= 150) {
                            setState(() {
                              question = value;
                            });
                          }
                        },
                        maxLength: 150,
                        textAlign: TextAlign.center,
                        maxLines: 9,
                        minLines: 1,
                        enabled: true,
                        style: const TextStyle(
                            color: white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22),
                        decoration: InputDecoration(
                          hintText: widget.type == 'target'
                              ? 'Đặt mục tiêu của bạn'
                              : "Đặt câu hỏi...",
                          hintStyle:
                              const TextStyle(color: white, fontSize: 22),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    colorsGradient.length,
                    (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              gradientSelected = colorsGradient[index];
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(right: 6.0),
                            decoration: BoxDecoration(
                                border: gradientSelected['color'] ==
                                        colorsGradient[index]['color']
                                    ? Border.all(width: 3, color: greyColor)
                                    : null,
                                borderRadius: BorderRadius.circular(8.0),
                                gradient: colorsGradient[index]['gradient']),
                          ),
                        )),
              ),
              const SizedBox(
                height: 12.0,
              ),
              SizedBox(
                height: 32,
                child: ButtonPrimary(
                  label: "Xong",
                  handlePress: question.trim().isNotEmpty
                      ? () {
                          widget.handleUpdateData('update_status_question', {
                            ...gradientSelected,
                            "content": question,
                            'postType': widget.type
                          });
                          Navigator.of(context)
                            ..pop()
                            ..pop();
                        }
                      : null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
