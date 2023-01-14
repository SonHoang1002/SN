import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/search.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/group_item.dart';
import 'package:social_network_app_mobile/widget/page_item.dart';
import 'package:social_network_app_mobile/widget/tab_social.dart';
import 'package:social_network_app_mobile/widget/user_item.dart';

class SearchResultPageDetail extends StatelessWidget {
  final String keyword;
  const SearchResultPageDetail({Key? key, required this.keyword})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: TabSocial(tabHeader: const [
        'Tất cả',
        'Mọi người',
        'Bài viết',
        'Nhóm',
        'Trang'
      ], childTab: [
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                AccountWidget(),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Nhóm',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                GroupWidget(),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Trang',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                PageWidget(),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Bài viết',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
    );
  }
}

class PageWidget extends StatelessWidget {
  const PageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(searchPageDetail['pages']!.length, (index) {
      dynamic page = searchPageDetail['pages'];
      return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            PageItem(
              page: page![index],
            )
          ]));
    }));
  }
}

class GroupWidget extends StatelessWidget {
  const GroupWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(searchGroupDetail['groups']!.length, (index) {
        dynamic group = searchGroupDetail['groups']![index];
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

class StatusWidget extends StatelessWidget {
  const StatusWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(searchStatusDetail['statuses']!.length,
            (index) => Post(post: searchStatusDetail['statuses']![index])));
  }
}

class AccountWidget extends StatelessWidget {
  const AccountWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(searchAccountDetail['accounts']!.length, (index) {
        dynamic user = searchAccountDetail['accounts']![index];
        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserItem(
                user: user,
                subText:
                    user['relationships']['friendship_status'] == 'ARE_FRIENDS'
                        ? 'Bạn bè'
                        : '',
              ),
              ButtonPrimary(
                  isPrimary: user['relationships']['friendship_status'] ==
                          'ARE_FRIENDS'
                      ? true
                      : false,
                  handlePress: () {},
                  label: user['relationships']['friendship_status'] ==
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
