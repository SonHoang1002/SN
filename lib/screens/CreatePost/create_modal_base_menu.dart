import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/Memories/memories_setting_page.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class CreateModalBaseMenu extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget buttonAppbar;

  const CreateModalBaseMenu(
      {Key? key,
      required this.title,
      required this.body,
      required this.buttonAppbar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            AppBarTitle(
              title: title,
            ),
            buttonAppbar
          ],
        ),
        actions: title == "Kỷ niệm"
            ? <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: theme.isDarkMode ? Colors.white : Colors.black,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        //fullscreenDialog: true,
                        builder: (context) {
                          return const MemoriesSetting();
                        },
                      ),
                    );
                  },
                )
              ]
            : [],
      ),
      body: body,
    );
  }
}
