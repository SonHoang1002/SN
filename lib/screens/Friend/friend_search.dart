import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/friends_api.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import '../../theme/theme_manager.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool _hasValue = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  fetchFriends(params) async {
    var response = await FriendsApi()
        .getListFriendApi(ref.watch(meControllerProvider)[0]['id'], params);
    if (response != null) {
      setState(() {
        searchResults = response;
      });
    }
  }

  handleSearch(value) {
    if (value.isEmpty) {
      fetchFriends({"keyword": ''});
      return;
    }
    EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
        () {
      fetchFriends({"keyword": value});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        leading: const BackIconAppbar(),
        title: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 40,
            maxWidth: 400,
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
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
                    color: theme.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.3),
                suffixIcon: _hasValue
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          handleSearch('');
                          setState(() {
                            _hasValue = false;
                          });
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 20,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ),
        ),
      ),
      body: searchResults.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) => ListTile(
                        leading: AvatarSocial(
                            width: 48,
                            height: 48,
                            path: searchResults[index]['avatar_media'] != null
                                ? searchResults[index]['avatar_media']
                                    ['show_url']
                                : searchResults[index]['avatar_static']),
                        title: Text(searchResults[index]['display_name']),
                        subtitle: Text(
                            '${searchResults[index]['relationships']['mutual_friend_count']} bạn chung'),
                        trailing:
                            const Icon(FontAwesomeIcons.arrowRight, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserPage(),
                              settings: RouteSettings(
                                arguments: {'id': searchResults[index]['id']},
                              ),
                            ),
                          );
                        }),
                  ),
                )
              ],
            )
          : const Center(
              child: Text('Search Results'),
            ),
    );
  }
}
