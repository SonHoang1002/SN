import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/post_poll.dart';

class PostPollCenter extends StatefulWidget {
  final dynamic post;
  const PostPollCenter({Key? key, this.post}) : super(key: key);

  @override
  State<PostPollCenter> createState() => _PostPollCenterState();
}

class _PostPollCenterState extends State<PostPollCenter> {
  @override
  Widget build(BuildContext context) {
    var poll = widget.post['poll'];
    var timeStamps = DateTime.parse(poll['expires_at']).millisecondsSinceEpoch -
        DateTime.now().millisecondsSinceEpoch;

    renderTimeExpires(time) {
      if ((timeStamps / (24 * 3600 * 1000)).round() > 0) {
        return '${(timeStamps / (24 * 3600 * 1000)).round()} ngày';
      } else if ((timeStamps / (60 * 60 * 1000)).round() > 0) {
        return '${(timeStamps / (60 * 60 * 1000)).round()} giờ`';
      } else {
        return '${DateFormat.jm().format(DateTime.parse(poll['expires_at']))} phút';
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
      child: FlutterPolls(
        pollId: widget.post['id'],
        onVoted: (PollOption pollOption, int newTotalVotes) async {
          await Future.delayed(const Duration(seconds: 1));

          return true;
        },
        pollOptionsSplashColor: Theme.of(context).colorScheme.background,
        votedProgressColor: Colors.grey.withOpacity(0.3),
        votedBackgroundColor: Colors.grey.withOpacity(0.2),
        votedCheckmark: const Icon(
          Icons.check,
          color: primaryColor,
          size: 18,
        ),
        // votesTextStyle: themeData.textTheme.subtitle1,
        votedPercentageTextStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        pollTitle: const Text(''),
        pollOptions: poll['options'].map<PollOption>(
          (option) {
            return PollOption(
              title: Text(
                option['title'],
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              votes: option['votes_count'],
            );
          },
        ).toList(),
        metaWidget: Row(
          children: [
            const SizedBox(width: 6),
            const Text(
              '•',
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              timeStamps > 0
                  ? 'Còn ${renderTimeExpires(poll['expires_at'])} ngày'
                  : "Đã kết thúc",
            ),
          ],
        ),
      ),
    );
  }
}
