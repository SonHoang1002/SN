import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class InviteFriend extends ConsumerStatefulWidget {
  final dynamic inviteFriend;
  const InviteFriend({Key? key, this.inviteFriend}) : super(key: key);
  @override
  ConsumerState<InviteFriend> createState() => _InviteFriendState();
}

class _InviteFriendState extends ConsumerState<InviteFriend> {
  var paramsConfig = {"excluded_invitation_event": 109853875958872608};

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref
            .read(eventControllerProvider.notifier)
            .getListFriendExcludes(paramsConfig));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List friendExcludes = ref.watch(eventControllerProvider).friendExcludes;
    return SizedBox(
      width: double.infinity,
      child: Expanded(
        child: ListView.builder(
            itemCount: friendExcludes.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      friendExcludes[index]['avatar_media'] != null
                          ? friendExcludes[index]['avatar_media']['preview_url']
                          : friendExcludes[index]['avatar_static']),
                ),
                title: Text(friendExcludes[index]['display_name']),
                trailing: Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                      child: InkWell(
                        child: Text('Mời',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: secondaryColor)),
                      ),
                    )),
              );
            }),
      ),
    );
  }
}
