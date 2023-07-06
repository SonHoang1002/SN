import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/post_poll.dart';

const roleAdmin = "Admin";
const roleGuest = "Guest";

class PostPollCenter extends ConsumerStatefulWidget {
  final dynamic post;
  final dynamic type;
  const PostPollCenter({Key? key, this.post, this.type}) : super(key: key);

  @override
  ConsumerState<PostPollCenter> createState() => _PostPollCenterState();
}

class _PostPollCenterState extends ConsumerState<PostPollCenter> {
  bool isUserVote = false;
  String role = roleGuest;
  dynamic poll;
  @override
  void initState() {
    super.initState();
    poll = widget.post['poll'];
  }

  signPollPost(dynamic params) {
    ref
        .read(postControllerProvider.notifier)
        .signPollPost(poll['id'], params, widget.type);
  }

  updatePollPost(dynamic params) {
    ref
        .read(postControllerProvider.notifier)
        .updatePollPost(poll['id'], params, widget.type);
  }

  renderTimeExpires(time, timeStamps) {
    if ((timeStamps / (24 * 3600 * 1000)).round() > 0) {
      return '${(timeStamps / (24 * 3600 * 1000)).round()} ngày';
    } else if ((timeStamps / (60 * 60 * 1000)).round() > 0) {
      return '${(timeStamps / (60 * 60 * 1000)).round()} giờ`';
    } else {
      return '${DateFormat.jm().format(DateTime.parse(poll['expires_at']))} phút';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(meControllerProvider)[0]['id'] ==
        widget.post?["account"]?["id"]) {
      role = roleAdmin;
    }

    var timeStamps = DateTime.parse(poll['expires_at']).millisecondsSinceEpoch -
        DateTime.now().millisecondsSinceEpoch;

    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
      child: FlutterPolls(
        pollId: widget.post['id'],
        role: role,
        onVoted: (PollOption pollOption, int newTotalVotes) async {
          await Future.delayed(const Duration(seconds: 1), () {});
          return true;
        },
        allData: poll,
        multipleVote: poll['multiple'] == true,
        signPollPostFunction: signPollPost,
        updatePollPost: updatePollPost,
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
        removeFunction: (int index) {
          if (poll['options'].length >= 3) {
            setState(() {
              poll["options"].removeAt(index);
            });
          }
        },
        addSelectionFunction: (dynamic newOptions) {
          setState(() {
            poll["options"].add(newOptions);
          });
        },
        hasVoted: poll['own_votes'].isNotEmpty,
        pollTitle: const Text(''),
        userVotedOptionId:
            poll['own_votes'].isNotEmpty ? poll['own_votes'] : [],
        pollOptions: poll['options'].map<PollOption>(
          (option) {
            return PollOption(
                title: Text(
                  option['title'],
                  style: TextStyle(
                      fontSize: 16,
                      color: isUserVote
                          ? blueColor
                          : Theme.of(context).textTheme.bodyMedium!.color),
                ),
                id: poll["options"].indexOf(option),
                votes: option['votes_count'],
                pollData: option);
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
                  ? 'Còn ${renderTimeExpires(poll['expires_at'], timeStamps)}'
                  : "Đã kết thúc",
            ),
          ],
        ),
      ),
    );
  }
}
