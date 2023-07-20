import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/screens/Watch/WatchDetail/watch_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_none_controller.dart';

import 'home/PreviewScreen.dart';
import 'home/home.dart';
import 'screens/Page/PageDetail/page_detail.dart';
import 'screens/UserPage/user_page.dart';
import 'theme/theme_manager.dart';

var routes = <String, WidgetBuilder>{
  '/home': (BuildContext context) => const Home(),
  '/page': (BuildContext context) => const PageDetail(),
  '/user': (BuildContext context) => const UserPageHome(),
  // '/login': (BuildContext context) => const OnboardingLoginPage(),
  '/': (BuildContext context) => const PreviewScreen(),
};

class MaterialAppWithTheme extends ConsumerStatefulWidget {
  const MaterialAppWithTheme({
    super.key,
  });

  @override
  ConsumerState<MaterialAppWithTheme> createState() =>
      _MaterialAppWithThemeState();
}

class _MaterialAppWithThemeState extends ConsumerState<MaterialAppWithTheme> {
  bool _isPlaying = true;
  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    final selectedVideo = ref.watch(selectedVideoProvider);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: theme.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            initialRoute: '/',
            routes: routes,
          ),
          if (selectedVideo != null)
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 100, right: 10, left: 10),
              child: SizedBox(
                // width: double.infinity,
                // height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Card(
                    elevation: 10,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              color: Color(int.parse(
                                  '0xFF${selectedVideo['media_attachments'][0]['meta']['small']['average_color'].substring(1)}')),
                              child: Center(
                                child: VideoPlayerNoneController(
                                  isShowVolumn: false,
                                  media: selectedVideo['media_attachments'][0],
                                  type: 'miniPlayer',
                                  path: selectedVideo['media_attachments'][0]
                                      ['remote_url'],
                                  aspectRatio: 1.0,
                                  isPause: !_isPlaying,
                                ),
                              ),
                            ),
                            Positioned.fill(child: InkWell(
                              onTap: () {
                                setState(
                                  () {
                                    _isPlaying = !_isPlaying;
                                  },
                                );
                              },
                              // child: AnimatedIcon(icon: AnimatedIcons.pause_play,progress: ,)
                            ))
                          ],
                        ),
                        Flexible(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(left: 18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    selectedVideo['content'].isNotEmpty
                                        ? SizedBox(
                                            height: 20,
                                            width: 150,
                                            child: Marquee(
                                              text:
                                                  "${selectedVideo['content']}   ",
                                              velocity: 30,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        : const SizedBox(),
                                    Flexible(
                                      child: Text(
                                        selectedVideo['account']
                                                ['display_name'] ??
                                            selectedVideo['page']['title'] ??
                                            '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      FontAwesomeIcons
                                          .upRightAndDownLeftFromCenter,
                                      size: 15),
                                  onPressed: () {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (GlobalVariable
                                              .navState.currentContext !=
                                          null) {
                                        MaterialPageRoute(
                                            builder: (context) => WatchDetail(
                                                  post: selectedVideo,
                                                  media: selectedVideo[
                                                      'media_attachments'][0],
                                                ));
                                      }
                                    });
                                    ref
                                        .read(selectedVideoProvider.notifier)
                                        .update((state) => null);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    ref
                                        .read(selectedVideoProvider.notifier)
                                        .update((state) => null);
                                  },
                                )
                              ],
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void navigateToSecondPageByNameWithoutContext(routeName) {
  navigatorKey.currentState!.pushReplacementNamed(routeName);
}

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}
