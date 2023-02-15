import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

import 'watch_drawer.dart';
import 'watch_render.dart';

class Watch extends StatefulWidget {
  const Watch({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WatchState createState() => _WatchState();
}

class _WatchState extends State<Watch> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey();

    List iconAction = [
      {"icon": Icons.search, 'type': 'icon'},
    ];

    return Scaffold(
        key: _key,
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: const WatchDrawer(),
        ),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => _key.currentState!.openDrawer(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Icon(
                          Icons.menu,
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    const AppBarTitle(title: 'Watch'),
                  ]),
              Row(
                children: List.generate(
                    iconAction.length,
                    (index) => Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.3)),
                        child: Icon(
                          iconAction[index]['icon'],
                          size: 20,
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                        ))),
              )
            ],
          ),
        ),
        body: const WatchRender());
  }
}
