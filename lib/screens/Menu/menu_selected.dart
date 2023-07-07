import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screens/Event/CreateEvent/create_event.dart';
import 'package:social_network_app_mobile/screens/Event/event_render.dart';
import 'package:social_network_app_mobile/screens/Friend/friend.dart';
import 'package:social_network_app_mobile/screens/Friend/friend_search.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group.dart';
import 'package:social_network_app_mobile/screens/Grows/grow_render.dart';
import 'package:social_network_app_mobile/screens/Page/page_general.dart';
import 'package:social_network_app_mobile/screens/Payment/payment.dart';
import 'package:social_network_app_mobile/screens/Recruit/recruit_render.dart';
import 'package:social_network_app_mobile/screens/Saved/saved.dart';
import 'package:social_network_app_mobile/screens/Watch/watch_render.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';

import '../../helper/push_to_new_screen.dart';
import '../Group/GroupCreateModules/screen/create_group_page.dart';
import '../LearnSpace/learn_space.dart';
// import 'package:social_network_app_mobile/screen/Page/page_general.dart';

class MenuSelected extends StatelessWidget {
  final dynamic menuSelected;
  final dynamic data;
  const MenuSelected({
    Key? key,
    this.menuSelected,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);

    Color colorWord = theme.isDarkMode ? white : blackColor;
    Widget buttonAppbar = const SizedBox();
    Widget body = const SizedBox();
    switch (menuSelected['key']) {
      case 'pageSocial':
        body = const PageGeneral();
        break;
      case 'watch':
        body = const WatchRender();
        break;
      case 'grow':
        body = const GrowRender();

        // buttonAppbar = Row(
        //   children: [
        //     GestureDetector(
        //       onTap: () {},
        //       child: const Icon(
        //         FontAwesomeIcons.calendarDay,
        //         size: 18,
        //         color: Colors.black,
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 7.0,
        //     ),
        //     GestureDetector(
        //       onTap: () {},
        //       child: const Icon(
        //         FontAwesomeIcons.plus,
        //         size: 18,
        //         color: Colors.black,
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 7.0,
        //     ),
        //     GestureDetector(
        //         onTap: () {},
        //         child: const Icon(
        //           FontAwesomeIcons.magnifyingGlass,
        //           size: 18,
        //           color: Colors.black,
        //         ))
        //   ],
        // );
        break;
      case 'friendSocial':
        body = const Friend();
        buttonAppbar = Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Icon(
              FontAwesomeIcons.search,
              size: 17,
              color: colorWord,
            ),
          ),
        );
        break;
      case 'eventSocial':
        body = const EventRender();
        buttonAppbar = Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const CreateEvents()),
                  );
                },
                child: Icon(FontAwesomeIcons.plus, size: 18, color: colorWord),
              ),
              const SizedBox(
                width: 10.0,
              ),
              InkWell(
                  onTap: () {},
                  child: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 18,
                    color: colorWord,
                  ))
            ],
          ),
        );
        break;
      case 'groupSocial':
        body = const Group();
        buttonAppbar = Row(
          children: [
            GestureDetector(
              onTap: () {
                pushToNextScreen(context, CreateGroupPage());
              },
              child: Icon(
                FontAwesomeIcons.plus,
                size: 20,
                color: colorWord,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 18,
              color: colorWord,
            )
          ],
        );
        break;
      case 'payment':
        body = const Payment();
        buttonAppbar = Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Icon(
                FontAwesomeIcons.plus,
                size: 20,
                color: colorWord,
              ),
            ),
          ],
        );
        break;
      case "job":
        body = const RecruitRender();
        // buttonAppbar = Row(
        //   children: [
        //     InkWell(
        //       onTap: () {},
        //       child: const Icon(
        //         FontAwesomeIcons.calendarDay,
        //         size: 18,
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 7.0,
        //     ),
        //     InkWell(
        //       onTap: () {},
        //       child: const Icon(
        //         FontAwesomeIcons.plus,
        //         size: 18,
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 7.0,
        //     ),
        //     InkWell(
        //         onTap: () {},
        //         child: const Icon(
        //           FontAwesomeIcons.magnifyingGlass,
        //           size: 18,
        //         ))
        //   ],
        // );
        break;
      case "lessonSocial":
        body = const LearnSpace();
        break;
      case 'saveSocial':
        body = const Saved();
        break;
      case 'marketPlace':
        break;
      default:
    }

    return CreateModalBaseMenu(
        title: menuSelected['label'], body: body, buttonAppbar: buttonAppbar);
  }
}
