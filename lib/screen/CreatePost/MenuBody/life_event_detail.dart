import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/checkin.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/date_time_custom.dart';
import 'package:social_network_app_mobile/widget/text_form_field_custom.dart';
import 'package:social_network_app_mobile/widget/video_player.dart';
import 'package:transparent_image/transparent_image.dart';

class LifeEventDetail extends StatefulWidget {
  final dynamic event;
  const LifeEventDetail({Key? key, this.event}) : super(key: key);

  @override
  State<LifeEventDetail> createState() => _LifeEventDetailState();
}

class _LifeEventDetailState extends State<LifeEventDetail> {
  String path = '';
  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    if (!mounted) return;

    if (widget.event != null && widget.event['video_url'] != null) {
      path = widget.event['video_url'][0];
    }

    flickMultiManager = FlickMultiManager();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 230,
              color: Theme.of(context).canvasColor,
              child: path != ''
                  ? FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: path,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    )
                  : const Center(
                      child: Text(
                        "Chưa có video",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.event['video_url'] != null
                        ? Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.only(
                                    right: 8.0, left: 4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    border: Border.all(
                                      width: 0.2,
                                      color: greyColor,
                                    )),
                                child: const Icon(
                                  FontAwesomeIcons.xmark,
                                  size: 18,
                                ),
                              ),
                              Row(
                                children: List.generate(
                                    widget.event['video_url'].length,
                                    (index) => InkWell(
                                          onTap: () {
                                            setState(() {
                                              path = widget.event['video_url']
                                                  [index];
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            margin: const EdgeInsets.only(
                                                right: 8.0),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 0.2,
                                                    color: greyColor)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: VideoPlayerRender(
                                                  autoPlay: false,
                                                  path:
                                                      widget.event['video_url']
                                                          [index]),
                                            ),
                                          ),
                                        )),
                              ),
                            ],
                          )
                        : Container(),
                    Container(
                        margin: const EdgeInsets.only(right: 4.0),
                        child: ButtonPrimary(
                            label: "Ảnh/video", handlePress: () {})),
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
            margin: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 80,
                    child: TextFormFieldCustom(
                      autofocus: true,
                      maxLines: 1,
                      hintText: "Tiêu đề",
                      initialValue: widget.event['name'],
                      helperText:
                          "Ví dụ: thành tích, hoạt động tình nguyện, kĩ năng hoặc bằng cấp mới",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 46,
                    child: ButtonPrimary(
                      label: "Chọn địa điểm",
                      handlePress: () {
                        // Navigator.push(
                        //     context,
                        //     CupertinoPageRoute(
                        //         builder: (context) => const CreateModalBaseMenu(
                        //             title: 'Chọn địa điểm',
                        //             body: Checkin(),
                        //             buttonAppbar: SizedBox())));
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const DateTimeCustom()
                ],
              ),
            )),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
