import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/home/PreviewScreen.dart';
import 'package:social_network_app_mobile/providers/choose_object_provider.dart';
import 'package:social_network_app_mobile/providers/current_number_page.dart';
import 'package:social_network_app_mobile/providers/event/selection_private_event_provider.dart';
import 'package:social_network_app_mobile/providers/group/hide_group_provider.dart';
import 'package:social_network_app_mobile/providers/group/select_private_rule_provider.dart';
import 'package:social_network_app_mobile/providers/group/select_target_group_provider.dart';
import 'package:social_network_app_mobile/providers/page/category_bloc.dart';
import 'package:social_network_app_mobile/providers/route_provider.dart';
import 'package:social_network_app_mobile/providers/search_category_provider.dart';
import 'package:social_network_app_mobile/providers/select_province_page_provider.dart';

import 'theme/theme_manager.dart';

var routes = <String, WidgetBuilder>{
  '/preview': (BuildContext context) => const PreviewScreen()
};

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

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
        ChangeNotifierProvider(create: (_) => CurrentNumberPageProvider()),
        ChangeNotifierProvider(create: (_) => HideGroupProvider()),
        ChangeNotifierProvider(create: (_) => SelectTargetGroupProvider()),
        ChangeNotifierProvider(create: (_) => SelectionPrivateEventProvider()),
        ChangeNotifierProvider(create: (_) => SelectionPrivateGroupProvider()),
      ],
      child: const MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatefulWidget {
  const MaterialAppWithTheme({
    super.key,
  });

  @override
  State<MaterialAppWithTheme> createState() => _MaterialAppWithThemeState();
}

class _MaterialAppWithThemeState extends State<MaterialAppWithTheme> {
  @override
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: theme.themeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      initialRoute: '/preview',
      routes: routes,
    );
  }
}
