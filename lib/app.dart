<<<<<<< HEAD
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

import 'theme/theme_manager.dart';
=======

import 'package:flutter/material.dart';
import 'package:market_place/providers/meProvider.dart';
import 'package:market_place/screens/Auth/storage.dart';
import 'package:market_place/screens/MarketPlace/screen/main_market_page.dart';
import 'package:market_place/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'services/notifications/local_notification.dart';

var routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => const MainMarketPage(),
 
};
>>>>>>> f56dcef2a796db0d1d32221a6904e4b9b102af26

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
<<<<<<< HEAD
  // ignore: library_private_types_in_public_api
=======
>>>>>>> f56dcef2a796db0d1d32221a6904e4b9b102af26
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
<<<<<<< HEAD
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
      child: const MaterialAppWithTheme(),
    );
  }
}
=======
  ThemeManager themeManager = ThemeManager();
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    getCurrentTheme();
  }

  void getCurrentTheme() async {
    final themeCurrent = await SecureStorage().getKeyStorage('theme');
    themeManager.themeMode = themeCurrent == 'light'
        ? ThemeMode.light
        : themeCurrent == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ThemeManager()),
      ChangeNotifierProvider(create: (_) => MeProvider()),
    ], child: const MaterialAppWithTheme());
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
  String? _token;
  String? initialMessage;
  bool _resolved = false;
  late final LocalNotificationService service;


  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: theme.themeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      initialRoute: '/',
      routes: routes,
      navigatorKey: GlobalVariable.navState,
    );
  }
}

class GlobalVariable {
  /// This global key is used in material app for navigation through firebase notifications.
  /// [navState] usage can be found in [notification_notifier.dart] file.
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}
>>>>>>> f56dcef2a796db0d1d32221a6904e4b9b102af26
