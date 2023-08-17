import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';

import '../../../theme/theme_manager.dart';
import '../../../widgets/avatar_social.dart';
import '../../../widgets/back_icon_appbar.dart';

class PageSearch extends StatefulWidget {
  final dynamic data;
  const PageSearch({super.key, this.data});

  @override
  State<PageSearch> createState() => _PageSearchState();
}

class _PageSearchState extends State<PageSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  fetchSearchPage(params) async {
    var response =
        await PageApi().fetchSearchPageDetail(widget.data['id'], params);
    if (response != null) {
      setState(() {
        searchResults = response['statuses'];
      });
    }
  }

  handleSearch(value) {
    if (value.isEmpty) {
      fetchSearchPage({"q": '', "limit": 5});
    }
    EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
        () {
      fetchSearchPage({"q": value, "limit": 5});
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
              maxHeight: 35,
              maxWidth: 400,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextFormField(
                onChanged: (value) {
                  handleSearch(value);
                },
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 15, bottom: 0, top: 10, right: 15),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30.0)),
                  hintText:
                      "Tìm kiếm trong bài viết, ảnh và thẻ của ${widget.data['title']}",
                  hintStyle: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ),
        body: searchResults.isEmpty
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AvatarSocial(
                      width: 72,
                      height: 72,
                      path: widget.data['avatar_media'] != null
                          ? widget.data['avatar_media']['preview_url']
                          : linkAvatarDefault,
                    ),
                    const SizedBox(height: 10),
                    const Text('Bạn đang tìm kiếm thứ gì đó?',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        'Tìm kiếm trên trang cá nhân của ${widget.data['title']} để xem bài viết, ảnh và các hoạt động hiển thị khác.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          height: 1.5,
                        ),
                      ),
                    )
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Post(
                    type: postPage,
                    post: searchResults[index],
                  );
                }));
  }
}
