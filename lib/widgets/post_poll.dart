import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:helpers/helpers/extensions/extensions.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

// FlutterPolls widget.
// This widget is used to display a poll.
// It can be used in any way and also in a [ListView] or [Column].
class FlutterPolls extends HookWidget {
  FlutterPolls(
      {super.key,
      this.multipleVote,
      required this.pollId,
      this.hasVoted = false,
      required this.userVotedOptionId,
      required this.onVoted,
      this.allData,
      this.role,
      this.loadingWidget,
      required this.pollTitle,
      this.heightBetweenTitleAndOptions = 10,
      required this.pollOptions,
      this.heightBetweenOptions,
      this.votesText = 'bình chọn',
      this.votesTextStyle,
      this.metaWidget,
      this.createdBy,
      this.userToVote,
      this.pollStartDate,
      this.pollEnded = false,
      this.pollOptionsHeight = 36,
      this.pollOptionsWidth,
      this.pollOptionsBorderRadius,
      this.pollOptionsFillColor,
      this.pollOptionsSplashColor = Colors.grey,
      this.pollOptionsBorder,
      this.votedPollOptionsRadius,
      this.votedBackgroundColor = const Color(0xffEEF0EB),
      this.votedProgressColor = const Color(0xff84D2F6),
      this.leadingVotedProgessColor = secondaryColor,
      this.votedCheckmark,
      this.votedPercentageTextStyle,
      this.votedAnimationDuration = 1000,
      this.removeFunction,
      this.addSelectionFunction,
      this.signPollPostFunction,
      this.updatePollPost})
      : _isloading = false;

  /// The id of the poll.
  /// This id is used to identify the poll.
  /// It is also used to check if a user has already voted in this poll.
  final String? pollId;

  final bool? multipleVote;

  final String? role;

  final dynamic allData;

  /// Checks if a user has already voted in this poll.
  /// If this is set to true, the user can't vote in this poll.
  /// Default value is false.
  /// [userVotedOptionId] must also be provided if this is set to true.
  final bool hasVoted;

  /// Checks if the [onVoted] execution is completed or not
  /// it is true, if the [onVoted] exection is ongoing and
  /// false, if completed
  final bool _isloading;

  /// If a user has already voted in this poll.
  /// It is ignored if [hasVoted] is set to false or not set at all.
  final List<dynamic> userVotedOptionId;

  /// An asynchronous callback for HTTP call feature
  /// Called when the user votes for an option.
  /// The index of the option that the user voted for is passed as an argument.
  /// If the user has already voted, this callback is not called.
  /// If the user has not voted, this callback is called.
  /// If the callback returns true, the tapped [PollOption] is considered as voted.
  /// Else Nothing happens,
  final Future<bool> Function(PollOption pollOption, int newTotalVotes) onVoted;

  /// The title of the poll. Can be any widget with a bounded size.
  final Widget pollTitle;

  /// Data format for the poll options.
  /// Must be a list of [PollOptionData] objects.
  /// The list must have at least two elements.
  /// The first element is the option that is selected by default.
  /// The second element is the option that is selected by default.
  /// The rest of the elements are the options that are available.
  /// The list can have any number of elements.
  ///
  /// Poll options are displayed in the order they are in the list.
  /// example:
  ///
  /// pollOptions = [
  ///
  ///  PollOption(id: 1, title: Text('Option 1'), votes: 2),
  ///
  ///  PollOption(id: 2, title: Text('Option 2'), votes: 5),
  ///
  ///  PollOption(id: 3, title: Text('Option 3'), votes: 9),
  ///
  ///  PollOption(id: 4, title: Text('Option 4'), votes: 2),
  ///
  /// ]
  ///
  /// The [id] of each poll option is used to identify the option when the user votes.
  /// The [title] of each poll option is displayed to the user.
  /// [title] can be any widget with a bounded size.
  /// The [votes] of each poll option is the number of votes that the option has received.
  final List<PollOption> pollOptions;

  /// The height between the title and the options.
  /// The default value is 10.
  final double? heightBetweenTitleAndOptions;

  /// The height between the options.
  /// The default value is 0.
  final double? heightBetweenOptions;

  /// Votes text. Can be "Votes", "Votos", "Ibo" or whatever language.
  /// If not specified, "Votes" is used.
  final String? votesText;

  /// [votesTextStyle] is the text style of the votes text.
  /// If not specified, the default text style is used.
  /// Styles for [totalVotes] and [votesTextStyle].
  final TextStyle? votesTextStyle;

  /// [metaWidget] is displayed at the bottom of the poll.
  /// It can be any widget with an unbounded size.
  /// If not specified, no meta widget is displayed.
  /// example:
  /// metaWidget = Text('Created by: $createdBy')
  final Widget? metaWidget;

  /// Who started the poll.
  final String? createdBy;

  /// Current user about to vote.
  final String? userToVote;

  /// The date the poll was created.
  final DateTime? pollStartDate;

  /// If poll is closed.
  final bool pollEnded;

  /// Height of a [PollOption].
  /// The height is the same for all options.
  /// Defaults to 36.
  final double? pollOptionsHeight;

  /// Width of a [PollOption].
  /// The width is the same for all options.
  /// If not specified, the width is set to the width of the poll.
  /// If the poll is not wide enough, the width is set to the width of the poll.
  /// If the poll is too wide, the width is set to the width of the poll.
  final double? pollOptionsWidth;

  /// Border radius of a [PollOption].
  /// The border radius is the same for all options.
  /// Defaults to 0.
  final BorderRadius? pollOptionsBorderRadius;

  /// Border of a [PollOption].
  /// The border is the same for all options.
  /// Defaults to null.
  /// If null, the border is not drawn.
  final BoxBorder? pollOptionsBorder;

  /// Color of a [PollOption].
  /// The color is the same for all options.
  /// Defaults to [Colors.blue].
  final Color? pollOptionsFillColor;

  /// Splashes a [PollOption] when the user taps it.
  /// Defaults to [Colors.grey].
  final Color? pollOptionsSplashColor;

  /// Radius of the border of a [PollOption] when the user has voted.
  /// Defaults to Radius.circular(8).
  final Radius? votedPollOptionsRadius;

  /// Color of the background of a [PollOption] when the user has voted.
  /// Defaults to [const Color(0xffEEF0EB)].
  final Color? votedBackgroundColor;

  /// Color of the progress bar of a [PollOption] when the user has voted.
  /// Defaults to [const Color(0xff84D2F6)].
  final Color? votedProgressColor;

  /// Color of the leading progress bar of a [PollOption] when the user has voted.
  /// Defaults to [const Color(0xff0496FF)].
  final Color? leadingVotedProgessColor;

  /// Widget for the checkmark of a [PollOption] when the user has voted.
  /// Defaults to [Icons.check_circle_outline_rounded].
  final Widget? votedCheckmark;

  /// TextStyle of the percentage of a [PollOption] when the user has voted.
  final TextStyle? votedPercentageTextStyle;

  /// Animation duration of the progress bar of the [PollOption]'s when the user has voted.
  /// Defaults to 1000 milliseconds.
  /// If the animation duration is too short, the progress bar will not animate.
  /// If you don't want the progress bar to animate, set this to 0.
  final int votedAnimationDuration;

  /// Loading animation widget for [PollOption] when [onVoted] callback is invoked
  /// Defaults to [CircularProgressIndicator]
  /// Visible until the [onVoted] execution is completed,
  final Widget? loadingWidget;

  /// removeFunction will be called to remove poll options when role is 'Admin'
  final Function? removeFunction;

  /// addSelectionFunction will be called  to add selection for poll options when role is 'Admin'
  final Function? addSelectionFunction;

  final Function? signPollPostFunction;

  final Function? updatePollPost;

  TextEditingController newController = TextEditingController(text: '');

  List<PollOption> _initPollOptions() {
    List<PollOption> mainList = [];
    for (int i = 0; i < pollOptions.length; i++) {
      for (int y = 0; y < userVotedOptionId.length; y++) {
        if (pollOptions[i].id == userVotedOptionId[y]) {
          mainList.add(pollOptions[i]);
        }
      }
    }
    return mainList;
  }

  @override
  Widget build(BuildContext context) {
    final hasPollEnded = useState(pollEnded);
    final userHasVoted = useState(hasVoted);
    final isLoading = useState(_isloading);
    final votedOptions = useState<List<PollOption>?>(
        hasVoted == false ? [] : _initPollOptions());
    final totalVotes = useState<int>(pollOptions.fold(
      0,
      (acc, option) => acc + option.votes,
    ));

    double caculatePercent(int index, PollOption pollOption) {
      final options =
          allData['options'].map((ele) => ele['votes_count']).toList(); 
      int sum = options.reduce((value, element) => value + element);
      double result;
      if (votedOptions.value!.contains(pollOption)) {
        result = ((allData['options'][index]['votes_count'] + 1) /
            (sum + votedOptions.value!.length)); 
        return result;
      } else {
        result = (allData['options'][index]['votes_count'] /
            (sum + votedOptions.value!.length)); 
        return result;
      }
    }

    handleActionVote(PollOption pollOption) async {
      // multi false
      if (multipleVote == false) {
        //nguoi dung chon vote
        if (isLoading.value) return;
        if (userHasVoted.value == false || votedOptions.value!.isEmpty) {
          !votedOptions.value!.contains(pollOption)
              ? votedOptions.value!.add(pollOption)
              : null;
          isLoading.value = true;
          bool success = await onVoted(
            pollOption,
            totalVotes.value,
          );
          isLoading.value = false;
          if (success) {
            pollOption.votes++;
            userHasVoted.value = true;
            totalVotes.value++;
            signPollPostFunction != null
                ? signPollPostFunction!({
                    'choices': [pollOption.id]
                  })
                : null;
          }
        } else {
          !votedOptions.value!.contains(pollOption)
              ? votedOptions.value!.remove(pollOption)
              : null;
          pollOption.votes--;
          userHasVoted.value = false;
          totalVotes.value--;
          updatePollPost != null
              ? updatePollPost!(
                  {'choices': votedOptions.value!.map((e) => e.id).toList()})
              : null;
        }
      } else {
        // nguoi dung muon vote
        if (pollOption.votes == 0) {
          bool pollOptionsIsEmpty = votedOptions.value!.isEmpty;
          if (votedOptions.value!.isEmpty) {
            totalVotes.value != 0 ? totalVotes.value++ : null;
          }
          !votedOptions.value!.contains(pollOption)
              ? votedOptions.value!.add(pollOption)
              : null;
          isLoading.value = true;
          bool success = await onVoted(
            pollOption,
            totalVotes.value,
          );
          isLoading.value = false;
          if (success) {
            pollOption.votes++;
            userHasVoted.value = true;
            pollOptionsIsEmpty
                ? signPollPostFunction != null
                    ? signPollPostFunction!({
                        'choices': votedOptions.value!.map((e) => e.id).toList()
                      })
                    : null
                : updatePollPost != null
                    ? updatePollPost!({
                        'choices': votedOptions.value!.map((e) => e.id).toList()
                      })
                    : null;
          }
          // nguoi dung muon huy vote
        } else {
          pollOption.votes--;
          !votedOptions.value!.contains(pollOption)
              ? votedOptions.value!.remove(pollOption)
              : null;
          if (votedOptions.value!.isEmpty) {
            userHasVoted.value = false;
            totalVotes.value--;
            updatePollPost != null ? updatePollPost!({'choices': []}) : null;
          } else {
            updatePollPost != null
                ? updatePollPost!(
                    {'choices': votedOptions.value!.map((e) => e.id).toList()})
                : null;
          }
        }
      }
    }

    return Column(
      key: ValueKey(pollId),
      children: [
        pollTitle,
        SizedBox(height: heightBetweenTitleAndOptions),
        if (pollOptions.length < 2)
          throw ('>>>Flutter Polls: Poll must have at least 2 options.<<<')
        else
          ...pollOptions.map(
            (pollOption) {
              int index = pollOptions.indexOf(pollOption);
              if (hasVoted && userVotedOptionId == null) {
                throw ('>>>Having "hasVoted" property require "userVotedOptionId" property !=null<<<');
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: userHasVoted.value || hasPollEnded.value
                            ? InkWell(
                                onTap: () async {
                                  handleActionVote(pollOption);
                                },
                                child: Container(
                                  key: UniqueKey(),
                                  margin: EdgeInsets.only(
                                    bottom: heightBetweenOptions ?? 8,
                                  ),
                                  child: LinearPercentIndicator(
                                    width: pollOptionsWidth,
                                    lineHeight: pollOptionsHeight!,
                                    barRadius: votedPollOptionsRadius ??
                                        const Radius.circular(8),
                                    padding: EdgeInsets.zero,
                                    percent: totalVotes.value == 0
                                        ? 0
                                        : pollOption.votes / totalVotes.value,
                                    animation: true,
                                    animationDuration: votedAnimationDuration,
                                    backgroundColor: votedBackgroundColor,
                                    progressColor:
                                        // votedOptions.value!
                                        //         .map((e) => e.id)
                                        //         .toList()
                                        //         .contains(pollOption.id)
                                        pollOption.votes ==
                                                pollOptions
                                                    .reduce(
                                                      (max, option) =>
                                                          max.votes >
                                                                  option.votes
                                                              ? max
                                                              : option,
                                                    )
                                                    .votes
                                            ? leadingVotedProgessColor
                                            : votedProgressColor,
                                    center: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      child: Row(
                                        children: [
                                          pollOption.title,
                                          const SizedBox(width: 10),
                                          // if (votedOptions.value != null &&
                                          //     votedOptions.value?.id == pollOption.id)
                                          //   votedCheckmark ??
                                          //       const Icon(
                                          //         Icons.check_circle_outline_rounded,
                                          //         color: Colors.black,
                                          //         size: 16,
                                          //       ),
                                          const Spacer(),
                                          Text(
                                            totalVotes.value == 0
                                                ? "0 $votesText"
                                                : '${(caculatePercent(pollOptions.indexOf(pollOption), pollOption) * 100).toStringAsFixed(1)}%',
                                            style: votedPercentageTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                key: UniqueKey(),
                                margin: EdgeInsets.only(
                                  bottom: heightBetweenOptions ?? 8,
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    handleActionVote(pollOption);
                                    // if (isLoading.value) return;
                                    // if (userHasVoted.value == false) {
                                    //   votedOptions.value!.add(pollOption);
                                    //   isLoading.value = true;
                                    //   bool success = await onVoted(
                                    //     pollOption,
                                    //     totalVotes.value,
                                    //   );
                                    //   isLoading.value = false;
                                    //   if (success) {
                                    //     pollOption.votes++;
                                    //     userHasVoted.value = true;
                                    //     if (votedOptions.value!.isEmpty) {
                                    //       totalVotes.value != 0
                                    //           ? totalVotes.value++
                                    //           : null;
                                    //       signPollPostFunction != null
                                    //           ? signPollPostFunction!({
                                    //               'choices': [pollOption.id]
                                    //             })
                                    //           : null;
                                    //     }
                                    //   }
                                    // }
                                  },
                                  splashColor: pollOptionsSplashColor,
                                  borderRadius: pollOptionsBorderRadius ??
                                      BorderRadius.circular(
                                        8,
                                      ),
                                  child: Container(
                                    height: pollOptionsHeight,
                                    width: pollOptionsWidth,
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      color: pollOptionsFillColor,
                                      border: pollOptionsBorder ??
                                          Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                      borderRadius: pollOptionsBorderRadius ??
                                          BorderRadius.circular(
                                            8,
                                          ),
                                    ),
                                    child: Center(
                                      child: isLoading.value &&
                                              votedOptions.value!
                                                  .map((e) => e.id)
                                                  .toList()
                                                  .contains(pollOption.id)
                                          ? loadingWidget ??
                                              const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                          : pollOption.title,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    // role == "Admin"
                    //     ? InkWell(
                    //         onTap: () {
                    //           removeFunction != null
                    //               ? removeFunction!(
                    //                   pollOptions.indexOf(pollOption))
                    //               : null;
                    //         },
                    //         child: const Padding(
                    //           padding: EdgeInsets.only(left: 10),
                    //           child: Icon(FontAwesomeIcons.xmark, size: 20),
                    //         ),
                    //       )
                    //     : const SizedBox()
                  ],
                );
              }
            },
          ),
        // role == "Admin"
        //     ? _buildInputPoll(newController, "Thêm lựa chọn thăm dò ý kiến...",
        //         onEditingComplete: () {
        //         hiddenKeyboard(context);
        //         addSelectionFunction != null
        //             ? addSelectionFunction!(
        //                 {"title": newController.text, "votes_count": 0})
        //             : null;
        //         newController.text = '';
        //       })
        //     : const SizedBox(),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '${totalVotes.value} $votesText',
              style: votesTextStyle ??
                  const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Expanded(
              child: metaWidget ?? Container(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputPoll(TextEditingController controller, String hintText,
      {double? height,
      TextInputType? keyboardType,
      Function? onEditingComplete}) {
    return Row(
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: height ?? 40,
            child: TextFormField(
              controller: controller,
              maxLines: null,
              keyboardType: keyboardType ?? TextInputType.text,
              onChanged: (value) {},
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: red),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                prefixIcon: const Icon(
                  FontAwesomeIcons.add,
                  size: 20,
                ),
                hintText: hintText,
              ),
              onEditingComplete: () {
                onEditingComplete != null ? onEditingComplete() : null;
              },
            ),
          ),
        ),
      ],
    );
  }
}

class PollOption {
  PollOption(
      {this.id,
      required this.title,
      required this.votes,
      required this.pollData});

  final int? id;
  final Widget title;
  int votes;
  dynamic pollData;
}
