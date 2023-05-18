import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/material_app_theme.dart';
import 'package:social_network_app_mobile/providers/event/selection_private_event_provider.dart';
import 'package:social_network_app_mobile/providers/group/hide_group_provider.dart';
import 'package:social_network_app_mobile/providers/group/select_target_group_provider.dart';
import 'package:social_network_app_mobile/providers/page/category_provider.dart';
import 'package:social_network_app_mobile/providers/page/route_provider.dart';
import 'package:social_network_app_mobile/providers/page/search_category_provider.dart';
import 'package:social_network_app_mobile/providers/page/select_province_page_provider.dart';
import 'package:social_network_app_mobile/providers/setting/choose_object_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'theme/theme_manager.dart';

class App extends StatefulWidget {
  final WebSocketChannel webSocketChannel;
  const App({Key? key, required this.webSocketChannel}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => ChooseObjectProvider()),
        ChangeNotifierProvider(create: (_) => RouteProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SearchCategoryProvider()),
        ChangeNotifierProvider(create: (_) => SelectProvinceProvider()),
        ChangeNotifierProvider(create: (_) => HideGroupProvider()),
        ChangeNotifierProvider(create: (_) => SelectTargetGroupProvider()),
        ChangeNotifierProvider(create: (_) => SelectionPrivateEventProvider()),
      ],
      child: MaterialAppWithTheme(webSocketChannel: widget.webSocketChannel),
    );
  }
}
