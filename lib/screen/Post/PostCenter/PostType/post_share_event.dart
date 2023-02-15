import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PostShareEvent extends StatelessWidget {
  final dynamic post;
  const PostShareEvent({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = post['event'];
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        ImageCacheRender(path: event['banner']['preview_url']),
        Container(
          padding: const EdgeInsets.all(8),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
          child: Row(
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
                      color: white,
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
                    DateFormat.yMd()
                        .add_jm()
                        .format(DateTime.parse(event['start_time'])),
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
        )
      ],
    );
  }
}
