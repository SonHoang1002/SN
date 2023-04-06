import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/watch.dart';
import 'package:social_network_app_mobile/providers/page/page_list_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreate/page_create.dart';
import 'package:social_network_app_mobile/screen/Page/page_invite.dart';
import 'package:social_network_app_mobile/screen/Page/page_liked.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
import 'package:social_network_app_mobile/widget/page_item.dart';

class PageGeneral extends ConsumerStatefulWidget {
  const PageGeneral({Key? key}) : super(key: key);

  @override
  ConsumerState<PageGeneral> createState() => _PageGeneralState();
}

class _PageGeneralState extends ConsumerState<PageGeneral> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (ref.read(pageListControllerProvider).pageAdmin.isEmpty) {
        await ref
            .read(pageListControllerProvider.notifier)
            .getListPageAdmin({'limit': 20});
      }
      if (ref.read(pageListControllerProvider).pageLiked.isEmpty) {
        await ref
            .read(pageListControllerProvider.notifier)
            .getListPageLiked({'page': 1, 'sort_direction': 'asc'});
      }
      if (!mounted) return;
    });

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

  @override
  Widget build(BuildContext context) {
    List pagesAdmin = ref.watch(pageListControllerProvider).pageAdmin;

    final size = MediaQuery.of(context).size;
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
      }

      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: ((context) => CreateModalBaseMenu(
                  title: menu['name'],
                  body: body,
                  buttonAppbar: const SizedBox()))));
    }

    List menuButton = [
      {
        'key': 'create_page',
        'name': 'Tạo',
        'icon': FontAwesomeIcons.circlePlus
      },
      {
        'key': 'liked_page',
        'name': 'Trang đã thích',
        'icon': FontAwesomeIcons.solidThumbsUp
      },
      {
        'key': 'invite_page',
        'name': 'Lời mời',
        'icon': FontAwesomeIcons.userPlus
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width,
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
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .color,
                              size: 14,
                            ),
                            isSelected: false,
                            label: menuButton[index]['name']),
                      ))),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            height: 2,
          ),
        ),
        SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Text(
                'Trang bạn quản lý',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              controller: scrollController,
              itemCount: pagesAdmin.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: PageItem(page: pagesAdmin[i]),
                );
              },
            ),
          ],
        ))
      ],
    );
  }
}
