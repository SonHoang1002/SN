import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';
import 'theme/theme_manager.dart';

var routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => const Home(),
  // '/login': (BuildContext context) => const Auth()
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
      initialRoute: '/',
      routes: routes,
    );
  }
}
