import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/search_input.dart';

import '../apis/events_api.dart';

class InviteFriend extends StatefulWidget {
  final String? id;
  final dynamic type;
  const InviteFriend({
    Key? key,
    this.id,
    this.type,
  }) : super(key: key);
  @override
  State<InviteFriend> createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List friendInvited = [];
  List friendUnInvited = [];
  dynamic paramsExcluded;
  dynamic paramsIncluded;
  List inviteSuccess = [];
  List inviteCheck = [];
  bool fetchInvitedCheck = false;

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    setState(() {
      switch (widget.type) {
        case 'page':
          if (widget.id != null) {
            paramsExcluded = {"excluded_page": widget.id ?? ''};
            paramsIncluded = {
              'included_invitation_follow_page': widget.id ?? ''
            };
          }
          break;
        case 'event':
          if (widget.id != null) {
            paramsExcluded = {"excluded_invitation_event": widget.id};
            paramsIncluded = {"included_invitation_event": widget.id};
          }
          break;
        default:
      }
    });
    searchFriendInvite(null);
      _tabController.addListener(() {
      print("aaaaa");
      if (_tabController.index != 0) {
        if(fetchInvitedCheck == false){
          fetchFriendInvited(null);
          fetchInvitedCheck = true;
        }
      }
    });
  }

  void searchFriendInvite(key) async {
    if(key!= null){
      EasyDebounce.debounce(
                  'my-debouncer', const Duration(milliseconds: 800), () {
        fetchFriendUnInvited(key);
    });
    }
    else{
      fetchFriendUnInvited(key);
    }  
  }

  void fetchFriendUnInvited(key) async {
    var response = await FriendsApi().getListFriendsApi(key == null || key == ''
        ? paramsExcluded
        : {...paramsExcluded, 'keyword': key});
    if (response != null) {
      if (mounted) {
        setState(() {
          friendUnInvited = response['data'];
          fetchInvitedCheck = false;
        });
      }
    }
  }

  void fetchFriendInvited(key) async {
    if (paramsIncluded != null) {
      var response = await FriendsApi().getListFriendsApi(
          key == null || key == ''
              ? paramsIncluded
              : {...paramsIncluded, 'keyword': key});
      if (response != null) {
        if (mounted) {
          setState(() {
            friendInvited = response['data'];
          });
        }
      }
    }
  }

  void handleInviteFriend(value) async {
    switch (widget.type) {
      case 'page':
        var res = await PageApi().createInviteLikePage(
            {'target_account_ids': value, 'invitation_type': 'like'},
            widget.id);
        if (res != null) {
          setState(() {
            inviteSuccess = inviteSuccess + value;
          });
        }
        break;
      case 'event':
        var res = await EventApi().sendInvitationFriendEventApi(
            widget.id, {'target_account_ids': value});
        if (res != null) {
          setState(() {
            inviteSuccess = inviteSuccess + value;
            fetchInvitedCheck = false;
          });
        }
        break;

      default:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return secondaryColor;
      }
      return secondaryColor;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const AppBarTitle(title: "Mời bạn bè"),
          actions: [
            if (_tabController.index == 0)
              InkWell(
                onTap: () {
                  handleInviteFriend(inviteCheck);
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(22, 18, 22, 0),
                  child: const Text(
                    'Mời',
                    style: TextStyle(
                        fontSize: 14,
                        color: secondaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
          ],
          bottom: TabBar(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 3),
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
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                Column(
                  children: [
                    Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                child: SearchInput(handleSearch: (value) async {   
                  searchFriendInvite(value);
                })),
                Expanded(child: ListView.builder(
                    itemCount: friendUnInvited.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              friendUnInvited[index]['avatar_media'] != null
                                  ? friendUnInvited[index]['avatar_media']
                                      ['preview_url']
                                  : friendUnInvited[index]['avatar_static']),
                        ),
                        title: Text(friendUnInvited[index]['display_name'],
                            style: TextStyle(color: colorWord(context))),
                        trailing: inviteSuccess
                                .contains(friendUnInvited[index]['id'])
                            ? const Text(
                                'Đã gửi',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: secondaryColor),
                              )
                            : Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: inviteCheck
                                    .contains(friendUnInvited[index]['id']),
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    setState(() {
                                      var tempInviteCheck = inviteCheck;
                                      inviteCheck = tempInviteCheck +
                                          [friendUnInvited[index]['id']];
                                    });
                                  } else {
                                    setState(() {
                                      var tempInviteCheck = inviteCheck;
                                      inviteCheck = tempInviteCheck
                                          .where((element) =>
                                              element !=
                                              friendUnInvited[index]['id'])
                                          .toList();
                                    });
                                  }
                                },
                              ),
                      );
                    }),)
                     
                  ],
                ),
               
                ListView.builder(
                    itemCount: friendInvited.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              friendInvited[index]['avatar_media'] != null
                                  ? friendInvited[index]['avatar_media']
                                      ['preview_url']
                                  : friendInvited[index]['avatar_static']),
                        ),
                        title: Text(friendInvited[index]['display_name'],
                            style: TextStyle(color: colorWord(context))),
                      );
                    }),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
