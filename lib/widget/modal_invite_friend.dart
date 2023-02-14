import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

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
  Widget build(BuildContext context) {
    List friendExcludes = ref.watch(eventControllerProvider).friendExcludes;

    return Container(
      child: Column(
        children: [
          ListView.builder(
              itemCount: friendExcludes.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) => Row(
                    children: [
                      ListTile(
                        leading: AvatarSocial(
                          width: 18,
                          height: 18,
                          path: friendExcludes[index]['banner']['preview_url'],
                        ),
                      )
                    ],
                  ))
        ],
      ),
    );
  }
}
