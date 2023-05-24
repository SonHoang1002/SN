import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/refractor_time.dart';
import 'package:social_network_app_mobile/screen/Event/event_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';

class PostShareEvent extends StatelessWidget {
  final dynamic post;
  final dynamic type;
  const PostShareEvent({Key? key, this.post, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = post['shared_event'];
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        type != 'edit_post'
            ? Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        EventDetail(eventDetail: event, isUseEventData: true)))
            : null;
      },
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          ExtendedImage.network(
            event['banner']?['preview_url'] ?? linkBannerDefault,
            height: 250,
            width: size.width,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.background),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(children: [
                      Container(
                        height: 15,
                        width: 60,
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8))),
                      ),
                      Container(
                        height: 45,
                        width: 60,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8))),
                        child: Center(
                          child: Text(
                            DateFormat.d()
                                .format(DateTime.parse(event['start_time'])),
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: blueColor),
                          ),
                        ),
                      )
                    ]),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getRefractorTime(event['start_time']),
                          // DateFormat.yMd()
                          //     .add_jm()
                          //     .format(DateTime.parse(event['start_time'])),
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: size.width - 86,
                          child: Text(
                            event['title'],
                            style: const TextStyle(
                                color: blueColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Row(
                    children: [
                      buildTextContent(
                          "${event['users_interested_count']} người quan tâm",
                          false,
                          fontSize: 14),
                      const Text(" - "),
                      buildTextContent(
                          "${event['users_going_count']} người sẽ tham gia",
                          false,
                          fontSize: 14)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
