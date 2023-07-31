import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/page/page_list_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screens/Page/PageCreate/page_create.dart';
import 'package:social_network_app_mobile/screens/Page/page_discover.dart';
import 'package:social_network_app_mobile/screens/Page/page_invite.dart';
import 'package:social_network_app_mobile/screens/Page/page_liked.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';
import 'package:social_network_app_mobile/widgets/page_item.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';

import '../MarketPlace/widgets/circular_progress_indicator.dart';

class PageGeneral extends ConsumerStatefulWidget {
  const PageGeneral({Key? key}) : super(key: key);

  @override
  ConsumerState<PageGeneral> createState() => _PageGeneralState();
}

class _PageGeneralState extends ConsumerState<PageGeneral> {
  final scrollController = ScrollController();
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        if (ref.read(pageListControllerProvider).pageAdmin.isNotEmpty &&
            ref.read(pageListControllerProvider).isMorePageAdmin) {
          String maxId =
              ref.read(pageListControllerProvider).pageAdmin.last['score'];
          ref
              .read(pageListControllerProvider.notifier)
              .getListPageAdmin({'limit': 20, 'max_id': maxId});
        }
      }
    });
  }

  void fetchData() async {
    await ref
        .read(pageListControllerProvider.notifier)
        .getListPageAdmin({'limit': 20});
    await ref
        .read(pageListControllerProvider.notifier)
        .getListPageSuggest({'limit': 10});
    await ref
        .read(pageListControllerProvider.notifier)
        .getListPageLiked({'page': 1, 'sort_direction': 'asc'});

    if (ref.read(pageListControllerProvider).pageInvitedLike.isEmpty) {
      await ref
          .read(pageListControllerProvider.notifier)
          .getListPageInvited('like');
    }
    if (ref.read(pageListControllerProvider).pageInvitedManage.isEmpty) {
      await ref
          .read(pageListControllerProvider.notifier)
          .getListPageInvited('manage');
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List pagesAdmin = ref.watch(pageListControllerProvider).pageAdmin;
    bool isMorePageAdmin =
        ref.watch(pageListControllerProvider).isMorePageAdmin;
    final size = MediaQuery.sizeOf(context);
    handlePressMenu(menu) {
      Widget body = const SizedBox();
      switch (menu['key']) {
        case 'create_page':
          body = const PageCreate();
          break;
        case 'liked_page':
          body = const PageLiked();
          break;
        case 'invite_page':
          body = const PageInvite();
          break;
        case 'page_discover':
          body = const PageDiscover();
          break;
      }

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CreateModalBaseMenu(
            title: menu['name'],
            body: body,
            buttonAppbar: const SizedBox(),
          ),
        ),
      );
    }

    List menuButton = [
      {
        'key': 'create_page',
        'name': 'Tạo',
        'icon': FontAwesomeIcons.circlePlus
      },
      {
        'key': 'page_discover',
        'name': 'Khám phá',
        'icon': FontAwesomeIcons.compass,
      },
      {
        'key': 'invite_page',
        'name': 'Lời mời',
        'icon': FontAwesomeIcons.userPlus
      },
      {
        'key': 'liked_page',
        'name': 'Trang đã thích',
        'icon': FontAwesomeIcons.solidThumbsUp
      },
    ];

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        fetchData();
      },
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    menuButton.length,
                    (index) => GestureDetector(
                      onTap: () {
                        handlePressMenu(menuButton[index]);
                      },
                      child: ChipMenu(
                        icon: Icon(
                          menuButton[index]['icon'],
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                          size: 14,
                        ),
                        isSelected: false,
                        label: menuButton[index]['name'],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                height: 2,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Text(
                'Trang bạn quản lý',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            _isLoading
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, i) {
                      return Center(
                        child: SkeletonCustom().postSkeletonInList(context),
                      );
                    })
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: pagesAdmin.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: PageItem(page: pagesAdmin[i]),
                      );
                    },
                  ),
            if (isMorePageAdmin)
              Center(
                child: SkeletonCustom().postSkeletonInList(context),
              )
          ],
        ),
      ),
    );
  }
}
