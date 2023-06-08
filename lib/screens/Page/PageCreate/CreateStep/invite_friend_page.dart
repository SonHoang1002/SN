import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/UserPage/user_information_provider.dart';
import 'package:social_network_app_mobile/screens/Page/PageCreate/CreateStep/settting_page_page.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/widgets/list_stack_avatar.dart';

import '../../../../widgets/GeneralWidget/bottom_navigator_button_chip.dart';
import '../../../../widgets/back_icon_appbar.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class InviteFriendPage extends ConsumerStatefulWidget {
  final dynamic dataCreate;
  const InviteFriendPage({
    super.key,
    this.dataCreate,
  });

  @override
  ConsumerState<InviteFriendPage> createState() => _InviteFriendPageState();
}

class _InviteFriendPageState extends ConsumerState<InviteFriendPage> {
  late double width = 0;
  final TextEditingController _codeNumberController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      SecureStorage().getKeyStorage('userId').then((value) => ref
          .read(userInformationProvider.notifier)
          .getUserFriend(value, {"limit": 10}));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List friends = ref.watch(userInformationProvider).friends.length >= 6
        ? ref.watch(userInformationProvider).friends.sublist(0, 6)
        : ref.watch(userInformationProvider).friends;
    width = size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: const BackIconAppbar(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(alignment: Alignment.bottomCenter, children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 12),
            child: Center(
                child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text(
                  'Xây dựng đối tượng cho trang',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hãy mời bạn bè kết nối tới ${widget.dataCreate['title']} để phát triển Trang.',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (friends.isNotEmpty)
                  ListStackAvatar(
                      listStack: friends
                          .map((e) => {
                                ...e,
                                'url_avatar': (e['avatar_media']
                                        ?['show_url']) ??
                                    (e['avatar_media']?['preview_url']) ??
                                    (e['avatar_static'])
                              })
                          .toList(),
                      maxItem: 8,
                      keyPath: 'url_avatar'),
                const SizedBox(height: 8),
                ElevatedButton(
                  child: const Text('Mời bạn bè'),
                  onPressed: () {},
                )
              ],
            )),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: buildBottomNavigatorWithButtonAndChipWidget(
                context: context,
                width: width,
                isPassCondition: true,
                newScreen: SettingsPage(dataCreate: widget.dataCreate),
                title: "Tiếp",
                currentPage: 5),
          )
        ]));
  }
}
