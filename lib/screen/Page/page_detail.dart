import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:provider/provider.dart' as pv;

class PageDetail extends StatefulWidget {
  const PageDetail({super.key});

  @override
  State<PageDetail> createState() => _PageDetailState();
}

class _PageDetailState extends State<PageDetail> {
  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';
    return Container(
      child: Scaffold(
          appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child:
              Icon(FontAwesomeIcons.angleLeft, color: Colors.green, size: 18),
        ),
        title: Text(
          'Không có việc gì khó',
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 15),
        ),
        centerTitle: true,
        actions: [
          Container(
            width: 38,
            height: 38,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                modeTheme == 'dark' ? 'assets/ChatDM.svg' : 'assets/chat.svg',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Icon(
              Icons.search,
              size: 22,
              color: Theme.of(context).textTheme.displayLarge!.color,
            ),
          )
        ],
      )),
    );
  }
}
