import 'package:easy_debounce/easy_debounce.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/Friend/friend_search.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import '../../theme/theme_manager.dart';
import '../../widgets/appbar_title.dart';

class FriendOfYou extends ConsumerStatefulWidget {
  const FriendOfYou({super.key});

  @override
  ConsumerState<FriendOfYou> createState() => _FriendOfYouState();
}

class _FriendOfYouState extends ConsumerState<FriendOfYou> {
  // List friends = [];
  // var meData = {};
  final TextEditingController _searchController = TextEditingController();
  bool _hasValue = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await fetchFriends({"limit": 20});
    });
  }

  fetchFriends(params) async {
    await ref
        .read(friendControllerProvider.notifier)
        .getListFriends(ref.watch(meControllerProvider)[0]['id'], params);
  }

  handleSearch(value) {
    if (value.isEmpty) {
      fetchFriends({"limit": 20});
      return;
    }
    EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
        () {
      fetchFriends({"keyword": value});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List friends = ref.watch(friendControllerProvider).friends;
    var meData = ref.watch(meControllerProvider)[0];
    final theme = pv.Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        leading: const BackIconAppbar(),
        title: const AppBarTitle(title: 'Bạn bè'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                FontAwesomeIcons.search,
                size: 17,
                color: colorWord(context),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchFriends({"limit": 20});
        },
        child: SingleChildScrollView(
          child: friends.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 38,
                          maxWidth: 420,
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _hasValue = value.isNotEmpty;
                            });
                            handleSearch(value);
                          },
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: 15, bottom: 10, top: 10, right: 15),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30.0)),
                            hintText: "Tìm kiếm bạn bè",
                            hintStyle: TextStyle(
                                color: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w400),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.3),
                            prefixIcon: Icon(
                              Icons.search,
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            suffixIcon: _hasValue
                                ? IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      handleSearch('');
                                      setState(() {
                                        _hasValue = false;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Text(
                            '${meData['friends_count']} người bạn',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16),
                          child: Text(
                            'Sắp xếp',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: friends.length,
                      itemBuilder: ((context, index) => ListTile(
                          visualDensity:
                              const VisualDensity(vertical: 4, horizontal: 0),
                          leading: FittedBox(
                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width / 2),
                            child: ExtendedImage.network(
                                friends[index]['avatar_media'] != null
                                    ? friends[index]['avatar_media']
                                        ['preview_url']
                                    : linkAvatarDefault,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover),
                          )),
                          title: Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: Text(friends[index]['display_name']),
                          ),
                          subtitle: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 16.0, top: 4),
                            child: Text(
                              '${friends[index]['relationships']['mutual_friend_count'] ?? 0} bạn chung',
                            ),
                          ),
                          trailing: const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Icon(FontAwesomeIcons.ellipsis),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserPageHome(),
                                settings: RouteSettings(
                                  arguments: {'id': friends[index]['id']},
                                ),
                              ),
                            );
                          })),
                    )
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
