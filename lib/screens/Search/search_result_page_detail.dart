import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/search/search_provider.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/screens/Search/search.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/group_item.dart';
import 'package:social_network_app_mobile/widgets/page_item.dart';
import 'package:social_network_app_mobile/widgets/tab_social.dart';
import 'package:social_network_app_mobile/widgets/user_item.dart';

import '../../widgets/back_icon_appbar.dart';

class SearchResultPageDetail extends ConsumerStatefulWidget {
  final String keyword;
  const SearchResultPageDetail({Key? key, required this.keyword})
      : super(key: key);
  @override
  ConsumerState<SearchResultPageDetail> createState() =>
      _SearchResultPageDetailState();
}

class _SearchResultPageDetailState
    extends ConsumerState<SearchResultPageDetail> {
  @override
  Widget build(BuildContext context) {
    // var searchDetail = {};
    // var searchStatusDetail = [];
    // var searchAccountDetail = [];
    // var searchGroupDetail = [];
    // var searchPageDetail = [];

    // Future.delayed(const Duration(milliseconds: 100), () {
    //   searchDetail = ref.watch(searchControllerProvider).searchDetail;
    //   searchStatusDetail = searchDetail['statuses'];
    //   searchAccountDetail = searchDetail['accounts'];
    //   searchGroupDetail = searchDetail['groups'];
    //   searchPageDetail = searchDetail['pages'];
    //   setState(() {});
    // });

    var searchDetail = ref.watch(searchControllerProvider).searchDetail;
    var isLoading = ref.watch(searchControllerProvider).isLoading;
    var searchStatusDetail = searchDetail?['statuses'];
    var searchAccountDetail = searchDetail?['accounts'];
    var searchGroupDetail = searchDetail?['groups'];
    var searchPageDetail = searchDetail?['pages'];

    // searchDetail.isEmpty
    //               ? const Center(child: CupertinoActivityIndicator())
    //               : searchStatusDetail.isEmpty &&
    //                       searchAccountDetail.isEmpty &&
    //                       searchGroupDetail.isEmpty &&
    //                       searchPageDetail.isEmpty
    //                   ? const Center(child: Text('Không có dữ liệu'))
    //                   :

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
                    builder: (context) => Search(keyword: widget.keyword)));
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 40,
              maxWidth: 400,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextFormField(
                initialValue: widget.keyword,
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
              searchDetail.isEmpty || isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : searchStatusDetail.isEmpty &&
                          searchAccountDetail.isEmpty &&
                          searchGroupDetail.isEmpty &&
                          searchPageDetail.isEmpty
                      ? const Center(child: Text('Không có dữ liệu'))
                      : SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10.0,
                                ),
                                const Text(
                                  'Tài khoản',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                AccountWidget(
                                    searchAccountDetail: searchAccountDetail),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                const Text(
                                  'Nhóm',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                GroupWidget(
                                    searchGroupDetail: searchGroupDetail),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                const Text(
                                  'Trang',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                PageWidget(searchPageDetail: searchPageDetail),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                const Text(
                                  'Bài viết',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                StatusWidget(
                                    searchStatusDetail: searchStatusDetail),
                              ],
                            ),
                          ),
                        ),
              SingleChildScrollView(
                child: AccountWidget(searchAccountDetail: searchAccountDetail),
              ),
              SingleChildScrollView(
                child: StatusWidget(searchStatusDetail: searchStatusDetail),
              ),
              SingleChildScrollView(
                child: GroupWidget(searchGroupDetail: searchGroupDetail),
              ),
              SingleChildScrollView(
                child: PageWidget(searchPageDetail: searchPageDetail),
              ),
            ]),
      ),
    );
  }
}

class PageWidget extends ConsumerWidget {
  final dynamic searchPageDetail;
  const PageWidget({
    this.searchPageDetail,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchPageDetail == null) {
      return const SizedBox();
    }
    return Column(
        children: List.generate(searchPageDetail?.length, (index) {
      dynamic page = searchPageDetail?[index];
      return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            PageItem(
              page: page,
            )
          ]));
    }));
  }
}

class GroupWidget extends ConsumerWidget {
  final dynamic searchGroupDetail;
  const GroupWidget({
    this.searchGroupDetail,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchGroupDetail == null) {
      return const SizedBox();
    }
    return Column(
      children: List.generate(searchGroupDetail?.length, (index) {
        dynamic group = searchGroupDetail?[index];
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
  final dynamic searchStatusDetail;
  const StatusWidget({super.key, this.searchStatusDetail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchStatusDetail == null) {
      return const SizedBox();
    }
    return Column(
        children: List.generate(searchStatusDetail?.length,
            (index) => Post(post: searchStatusDetail?[index])));
  }
}

class AccountWidget extends ConsumerWidget {
  final dynamic searchAccountDetail;
  const AccountWidget({
    super.key,
    this.searchAccountDetail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchAccountDetail == null) {
      return const SizedBox();
    }
    return Column(
      children: List.generate(searchAccountDetail?.length, (index) {
        var user = searchAccountDetail?[index];
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
