import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/icons/back_icon.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';
import 'package:social_network_app_mobile/widgets/user_item.dart';

class PageMention extends StatelessWidget {
  final List mentions;
  const PageMention({Key? key, required this.mentions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title:   Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const[
            BackIcon(),
            AppBarTitle(
              title: "Được gắn thẻ",
            ),
            SizedBox()
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextDescription(
                  description: "Những người được gắn thẻ trong bài viết này"),
              const SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    mentions.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: UserItem(user: mentions[index]),
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
