import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/search/search_provider.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/screen/Search/search.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/group_item.dart';
import 'package:social_network_app_mobile/widget/page_item.dart';
import 'package:social_network_app_mobile/widget/tab_social.dart';
import 'package:social_network_app_mobile/widget/user_item.dart';

import '../../widget/back_icon_appbar.dart';

class SearchResultPageDetail extends StatelessWidget {
  final String keyword;
  const SearchResultPageDetail({Key? key, required this.keyword})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        leading: const BackIconAppbar(),
        title: InkWell(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => Search(keyword: keyword)));
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 40,
              maxWidth: 400,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextFormField(
                initialValue: keyword,
                key: UniqueKey(),
                readOnly: true,
                autofocus: false,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 15, bottom: 10, top: 10, right: 15),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30.0)),
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: TabSocial(
            tabHeader: const [
              'Tất cả',
              'Mọi người',
              'Bài viết',
              'Nhóm',
              'Trang'
            ].toList(),
            childTab: [
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Tài khoản',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      AccountWidget(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Nhóm',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      GroupWidget(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Trang',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      PageWidget(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Bài viết',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      // StatusWidget(),
                    ],
                  ),
                ),
              ),
              const SingleChildScrollView(
                child: AccountWidget(),
              ),
              const SingleChildScrollView(
                child: StatusWidget(),
              ),
              const SingleChildScrollView(
                child: GroupWidget(),
              ),
              const SingleChildScrollView(
                child: PageWidget(),
              ),
            ]),
      ),
    );
  }
}

class PageWidget extends ConsumerWidget {
  const PageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var searchPageDetail =
        ref.watch(searchControllerProvider).searchDetail ?? [];

    return Column(
        children: List.generate(searchPageDetail['pages']!.length, (index) {
      dynamic page = searchPageDetail['pages'];
      return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            PageItem(
              page: page[index],
            )
          ]));
    }));
  }
}

class GroupWidget extends ConsumerWidget {
  const GroupWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var searchGroupDetail =
        ref.watch(searchControllerProvider).searchDetail ?? [];
    return Column(
      children: List.generate(searchGroupDetail['groups']!.length, (index) {
        dynamic group = searchGroupDetail['groups'][index];
        return Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              GroupItem(
                group: group,
              )
            ]));
      }),
    );
  }
}

class StatusWidget extends ConsumerWidget {
  const StatusWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var searchStatusDetail =
        ref.watch(searchControllerProvider).searchDetail ?? [];
    return Column(
        children: List.generate(searchStatusDetail['statuses']!.length,
            (index) => Post(post: searchStatusDetail['statuses']![index])));
  }
}

class AccountWidget extends ConsumerWidget {
  const AccountWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var searchAccountDetail =
        ref.watch(searchControllerProvider).searchDetail ?? [];
    return Column(
      children: List.generate(searchAccountDetail['accounts']!.length, (index) {
        var user = searchAccountDetail['accounts']![index];
        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserItem(
                user: user,
                subText: user['relationships'] == null
                    ? "Xem trang cá nhân"
                    : user['relationships']['friendship_status'] ==
                            'ARE_FRIENDS'
                        ? 'Bạn bè'
                        : '',
              ),
              ButtonPrimary(
                  isPrimary: user['relationships'] != null &&
                          user['relationships']['friendship_status'] ==
                              'ARE_FRIENDS'
                      ? true
                      : false,
                  handlePress: () {},
                  label: user['relationships'] == null
                      ? 'Xem trang cá nhân'
                      : user['relationships']['friendship_status'] ==
                              'ARE_FRIENDS'
                          ? 'Bạn bè'
                          : 'Kết bạn')
            ],
          ),
        );
      }),
    );
  }
}
