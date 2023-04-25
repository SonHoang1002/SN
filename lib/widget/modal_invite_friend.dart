import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/friend_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

class InviteFriend extends ConsumerStatefulWidget {
  final dynamic inviteFriend;
  final Function? handleInvite;
  final String? id;
  final dynamic type;
  const InviteFriend({
    Key? key,
    this.inviteFriend,
    this.handleInvite,
    this.id,
    this.type,
  }) : super(key: key);
  @override
  ConsumerState<InviteFriend> createState() => _InviteFriendState();
}

class _InviteFriendState extends ConsumerState<InviteFriend>
    with TickerProviderStateMixin {
  late TabController _tabController;
  var paramsConfig = {"excluded_invitation_event": '109853875958872608'};

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    setState(() {
      switch (widget.type) {
        case 'page':
          if (widget.id is String) {
            paramsConfig = {"excluded_page": widget.id ?? ''};
          }
          break;
        case 'event':
          paramsConfig = {"excluded_invitation_event": "109853875958872608"};
          break;
        default:
      }
    });

    Future.delayed(
        Duration.zero,
        () => ref
            .read(friendControllerProvider.notifier)
            .getListFriendExcludes(paramsConfig));
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List friendExcludes = ref.watch(friendControllerProvider).friendExcludes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const AppBarTitle(title: "Mời bạn bè"),
        bottom: TabBar(
          padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
          labelColor: secondaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
          indicatorColor: secondaryColor,
          dividerColor: secondaryColor,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Text(
                'Chưa mời',
                style: TextStyle(fontSize: 15),
              ),
            ),
            Tab(
              icon: Text(
                'Đã mời',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
              child: SearchInput(handleSearch: (value) async {
                await ref
                    .read(friendControllerProvider.notifier)
                    .getListFriendExcludes({paramsConfig});
              })),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              ListView.builder(
                  itemCount: friendExcludes.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {},
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            friendExcludes[index]['avatar_media'] != null
                                ? friendExcludes[index]['avatar_media']
                                    ['preview_url']
                                : friendExcludes[index]['avatar_static']),
                      ),
                      title: Text(friendExcludes[index]['display_name'],
                          style: TextStyle(color: colorWord(context))),
                      trailing: Container(
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                              color: secondaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                if (widget.handleInvite != null) {
                                  widget.handleInvite!(
                                      friendExcludes[index]['id']);
                                }
                              },
                              child: const Text('Mời',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: secondaryColor)),
                            ),
                          )),
                    );
                  }),
              ListView.builder(
                  itemCount: friendExcludes.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {},
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            friendExcludes[index]['avatar_media'] != null
                                ? friendExcludes[index]['avatar_media']
                                    ['preview_url']
                                : friendExcludes[index]['avatar_static']),
                      ),
                      title: Text(friendExcludes[index]['display_name'],
                          style: TextStyle(color: colorWord(context))),
                      trailing: Container(
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                              color: secondaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                if (widget.handleInvite != null) {
                                  widget.handleInvite!(
                                      friendExcludes[index]['id']);
                                }
                              },
                              child: const Text('Mời',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: secondaryColor)),
                            ),
                          )),
                    );
                  }),
            ]),
          ),
        ],
      ),
    );
  }
}
