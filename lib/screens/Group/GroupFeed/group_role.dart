import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class GroupRole extends ConsumerStatefulWidget {
  final dynamic groupMember;
  final dynamic groupAdmin;
  final dynamic groupFriend;

  const GroupRole(
      {super.key, this.groupMember, this.groupAdmin, this.groupFriend});

  @override
  ConsumerState<GroupRole> createState() => _GroupRoleState();
}

class _GroupRoleState extends ConsumerState<GroupRole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Mọi người'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quản trị viên và người kiểm duyệt',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.groupAdmin.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(widget.groupAdmin[index]
                                    ['account']['avatar_media'] !=
                                null
                            ? widget.groupAdmin[index]['account']['avatar_media']
                                ['preview_url']
                            : linkAvatarDefault),
                      ),
                      title: Text(
                          widget.groupAdmin[index]['account']['display_name']),
                    );
                  })),
              const Divider(
                thickness: 1,
                height: 20,
              ),
              const Text(
                'Bạn bè',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.groupFriend.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(widget.groupFriend[index]
                                    ['account']['avatar_media'] !=
                                null
                            ? widget.groupFriend[index]['account']['avatar_media']
                                ['preview_url']
                            : linkAvatarDefault),
                      ),
                      title: Text(
                          widget.groupFriend[index]['account']['display_name']),
                    );
                  })),
              const Divider(
                thickness: 1,
                height: 20,
              ),
              const Text(
                'Thành viên khác',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.groupMember.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(widget.groupMember[index]
                                    ['account']['avatar_media'] !=
                                null
                            ? widget.groupMember[index]['account']['avatar_media']
                                ['preview_url']
                            : linkAvatarDefault),
                      ),
                      title: Text(
                          widget.groupMember[index]['account']['display_name']),
                    );
                  })),
            ],
          ),
        ),
      ),
    );
  }
}
