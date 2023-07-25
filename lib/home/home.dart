import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/notification/notification_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_post.dart';
import 'package:social_network_app_mobile/screens/Feed/feed.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/onboarding_login_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/main_market_page.dart';
import 'package:social_network_app_mobile/screens/Menu/menu.dart';
import 'package:social_network_app_mobile/screens/Moment/moment.dart';
import 'package:social_network_app_mobile/screens/Notification/notification_page.dart';
import 'package:social_network_app_mobile/screens/Search/search.dart';
import 'package:social_network_app_mobile/screens/Watch/watch.dart';
import 'package:social_network_app_mobile/services/notification_service.dart';
import 'package:social_network_app_mobile/services/web_socket_service.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/Home/bottom_navigator_bar_emso.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Home extends ConsumerStatefulWidget {
  final int? selectedIndex;
  const Home({Key? key, this.selectedIndex}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  ValueNotifier<bool> isShowSnackBar = ValueNotifier(false);
  ValueNotifier<bool> showBottomNavigatorNotifier = ValueNotifier(true);
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Size? size;
  ThemeManager? theme;
  ValueNotifier<bool?> isDisconnected = ValueNotifier(null);
  WebSocketChannel? webSocketChannel;
  StreamSubscription<dynamic>? subscription;
  double valueFromPercentageInRange(
      {required final double min, max, percentage}) {
    return percentage * (max - min) + min;
  }

  double percentageFromValueInRange({required final double min, max, value}) {
    return (value - min) / (max - min);
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      showBarModalBottomSheet(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (context) => const CreatePost());
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    if (mounted) {
      SecureStorage().getKeyStorage("token").then((value) {
        if (value != 'noData') {
          Future.delayed(Duration.zero, () async {
            if (ref.watch(meControllerProvider).isEmpty) {
              await ref.read(meControllerProvider.notifier).getMeData();
              await setTheme();
            }
          });
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: ((context) => const OnboardingLoginPage())));
        }
      });
      Future.delayed(Duration.zero, () => fetchNotifications(null));
      connectToWebSocket();
      initConnectivity();
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    }
  }

  void connectToWebSocket() async {
    webSocketChannel = await WebSocketService().connectToWebSocket();
    listenToWebSocket();
  }

  void listenToWebSocket() {
    subscription = webSocketChannel?.stream.listen(
      (data) {
        if (data.contains('42')) {
          int startIndex = data.indexOf('[') + 1;
          int endIndex = data.lastIndexOf(']');
          String jsonString = data.substring(startIndex, endIndex);
          List<dynamic> dataList = jsonDecode("[$jsonString]");
          Map<String, dynamic> object = dataList[1];
          if (data.contains('transactionId')) {
            fetchNotifications(null).then((value) async {
              dynamic dataFilter = ref
                  .read(notificationControllerProvider)
                  .notifications
                  .where((element) => element['id'] == object['id'])
                  .toList();
              if (dataFilter != null && dataFilter.isNotEmpty) {
                await NotificationService().showNotification(
                    title: 'EMSO',
                    payLoad: jsonEncode(dataFilter),
                    largeIcon: dataFilter[0]['account']['avatar_media'] != null
                        ? dataFilter[0]['account']['avatar_media']
                            ['preview_url']
                        : dataFilter[0]['account']['avatar_static'],
                    body:
                        '${renderName(dataFilter)}${renderContent(dataFilter)['textNone'] ?? ''} ${renderContent(dataFilter)['textBold'] ?? ''}');
              }
            });
          }
        }
      },
      onDone: () {
        print('WebSocket closed');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
    );
  }

  void cancelListening() {
    webSocketChannel?.sink.close();
  }

  dynamic renderContent(noti) {
    dynamic status = noti[0]['status'] ?? {};
    String type = noti[0]['type'];

    if (type == 'folow') {
      return {'textNone': ' đã theo dõi bạn'};
    } else if (type == 'reblog') {
      return {'textNone': ' đã chia sẻ bài viết của bạn'};
    } else if (type == 'mention') {
      return {'textNone': ' đã nhắc đến bạn trong một bài viết'};
    } else if (type == 'poll') {
      return {'textNone': ' đã bầu chọn trong cuộc thăm dò của bạn'};
    } else if (type == 'friendship_request') {
      return {'textNone': ' đã gửi cho bạn lời mời kết bạn'};
    } else if (type == 'event_invitation') {
      return {'textNone': ' đã gửi cho bạn lời mời tham gia sự kiện'};
    } else if (type == 'event_invitation_host') {
      return {'textNone': ' đã mời bạn đồng tổ chức sự kiện:'};
    } else if (type == 'page_follow') {
      return {'textNone': ' đã thích'};
    } else if (type == 'page_invitation') {
      return {'textNone': ' đã mời bạn làm quản trị viên '};
    } else if (type == 'page_invitation_follow') {
      return {'textNone': ' đã mời bạn thích trang'};
    } else if (type == 'group_invitation') {
      return {'textNone': ' đã mời bạn tham gia nhóm'};
    } else if (type == 'accept_event_invitation') {
      return {'textNone': ' đã đồng ý tham gia sự kiện'};
    } else if (type == 'accept_event_invitation_host') {
      return {'textNone': ' đã đồng ý đồng tổ chức sự kiện'};
    } else if (type == 'accept_page_invitation') {
      return {'textNone': ' đã đồng ý làm quản trị viên trang'};
    } else if (type == 'accept_page_invitation_follow') {
      return {'textNone': ' đã chấp nhận lời mời thích trang'};
    } else if (type == 'accept_group_invitation') {
      return {'textNone': ' đã chấp nhận lời mời tham gia nhóm'};
    } else if (type == 'accept_friendship_request') {
      return {'textNone': ' đã chấp nhận lời mời kết bạn'};
    } else if (type == 'group_join_request') {
      return {'textNone': ' đã yêu cầu tham gia'};
    } else if (type == 'created_status') {
      return {
        'textNone': ' Video của bạn đã sẵn sàng.Bây giờ bạn có thể mở xem'
      };
    } else if (type == 'status_tag') {
      return {
        'textNone': status['in_reply_to_parent_id'] != null ||
                status['in_reply_to_id'] != null
            ? ' đã nhắc đến bạn trong một bình luận'
            : ' đã gắn thẻ bạn trong một bài viết'
      };
    } else if (type == 'comment') {
      return {
        'textNone':
            ' đã bình luận về một bài viết có thể bạn quan tâm: ${status['content']}'
      };
    } else if (type == 'approved_group_join_request') {
      return {
        'textNone':
            ' Quản trị viên đã phê duyệt yêu cầu tham gia của bạn. Chào mừng bạn đến với'
      };
    } else if (type == 'course_invitation') {
      return {'textNone': ' đã mời bạn tham gia khóa học'};
    } else if (type == 'product_invitation') {
      return {'textNone': ' đã mời bạn quan tâm đến sản phẩm'};
    } else if (type == 'admin_page_invitation') {
      return {
        'textNone': ' đã mời bạn làm quản trị viên',
        'textBold': '${status?['page']?['title']}'
      };
    } else if (type == 'approved_group_status') {
      return {
        'textNone':
            '  bài viết của bạn tại ${status['group'] != null ? 'nhóm' : 'trang'} ${status['group'] != null ? status['group']['title'] : status['page']['title']} đã được phê duyệt',
      };
    } else if (type == 'accept_admin_page_invitation') {
      return {
        'textNone': ' đã đồng ý làm quản trị viên trang',
        'textBold': '${status?['page']?['title']}'
      };
    } else if (type == 'recruit_apply') {
      return {
        'textNone': ' đã ứng tuyển vào công việc',
        'textBold': '${status?['recruit']?['title']}'
      };
    } else if (type == 'recruit_invitation') {
      return {
        'textNone': ' đã mời bạn tham gia tuyển dụng',
        'textBold': '${status?['recruit']?['title']}'
      };
    } else if (type == 'moderator_page_invitation') {
      return {
        'textNone': ' đã đồng ý làm kiểm duyệt viên trang',
        'textBold': '${status?['page']?['title']}'
      };
    }
    if (type == 'favourite') {
      return {
        'textNone':
            ' đã bày tỏ cảm xúc về ${status['in_reply_to_parent_id'] != null || status['in_reply_to_id'] != null ? 'bình luận' : 'bài viết'} ${status['page_owner'] == null && status['account']?['id'] == ref.watch(meControllerProvider)[0]['id'] ? 'của bạn' : ''} ${status['content'] ?? ""}'
      };
    } else if (type == 'status') {
      if (status['reblog'] != null) {
        return {
          'textNone':
              ' đã chia sẻ một bài viết ${status['reblog']?['page'] != null || status['reblog']?['group'] != null ? 'trong' : ''}'
        };
      } else if (status['page_owner'] != null) {
        return {
          'textNone': status['post_type'] == 'event_shared}'
              ? ' đã tạo một sự kiện '
              : ' có một bài viết mới: ${status['content'] ?? ""}]} '
        };
      } else if (status['group'] != null || status['page'] != null) {
        if (noti[0]['account']['relationship'] != null &&
            noti[0]['account']['relationship']['friendship_status'] ==
                'ARE_FRIENDS') {
          return {
            'textNone': status['post_type'] == 'event_shared}'
                ? ' đã tạo một sự kiện trong '
                : ' có tạo bài viết trong ',
            'textBold': status['post_type'] == 'event_shared}'
                ? '${status['group'] != null ? 'nhóm' : 'trang'} ${status['group'] != null ? status['group']['title'] : status['page']['title']}'
                : '${status['group'] != null ? 'nhóm' : 'trang'} ${status['group'] != null ? status['group']['title'] : status['page']['title']}'
          };
        } else {
          return {
            'textNone': status['post_type'] == 'event_shared}'
                ? ' có sự kiện mới: ${status['content'] ?? ""}'
                : ' có bài viết mới: ${status['content'] ?? ""}'
          };
        }
      } else if (status['post_type'] == 'moment') {
        return {'textNone': ' đã đăng một khoảnh khắc mới'};
      } else if (status['post_type'] == 'watch') {
        return {'textNone': ' đã đăng một video mới trong watch'};
      } else if (status['post_type'] == 'question') {
        return {'textNone': ' đã đặt một câu hỏi'};
      } else if (status['post_type'] == 'target') {
        return {'textNone': ' đã đặt một mục tiêu mới'};
      } else {
        return {'textNone': ' đã tạo bài viết mới ${status['content'] ?? ""}'};
      }
    }
  }

  renderName(noti) {
    dynamic status = noti[0]['status'];
    dynamic account = noti[0]['account'];
    switch (noti[0]['type']) {
      case 'event_invitation_host':
        return status['event']?['page']?['title'] ?? account['display_name'];
      case 'status':
        return status['group']?['title'] ??
            status['page']?['title'] ??
            account['display_name'];

      default:
        return account['display_name'];
    }
  }

  fetchNotifications(params) async {
    await ref
        .read(notificationControllerProvider.notifier)
        .getListNotifications(params);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Connectivity Error: $e");
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result != ConnectivityResult.mobile ||
        result != ConnectivityResult.wifi) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    isShowSnackBar.dispose();
    showBottomNavigatorNotifier.dispose();
    _connectivitySubscription.cancel();
    isDisconnected.dispose();
    subscription?.cancel();
    cancelListening();
    super.dispose();
  }

  useIsolate() async {
    final ReceivePort receivePort = ReceivePort();
    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    try {
      await Isolate.spawn(checkConnectivity, [
        receivePort.sendPort,
        [rootIsolateToken]
      ]);
    } on Object {
      debugPrint('Isolate Failed');
      receivePort.close();
    }
    final response = await receivePort.first;
    return response;
  }

  static Future<void> checkConnectivity(List<dynamic> args) async {
    SendPort resultPort = args[0];
    BackgroundIsolateBinaryMessenger.ensureInitialized(args[1][0]);
    bool isDisconnected;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      isDisconnected = false;
    } else {
      isDisconnected = true;
    }
    Isolate.exit(resultPort, isDisconnected);
  }

  Future setTheme() async {
    final theme = pv.Provider.of<ThemeManager>(context, listen: false);
    final token = await SecureStorage().getKeyStorage('token');
    final dataLogin = await SecureStorage().getKeyStorage('dataLogin');
    SecureStorage().getKeyStorage('theme').then((value) {
      if (value != 'noData') {
        theme.getThemeInitial(value);
      } else {
        var currentTheme = jsonDecode(dataLogin)
            .firstWhere((e) => e['token'] == token)['theme'];
        if (currentTheme != null) {
          theme.toggleTheme(currentTheme);
        }
      }
    });
  }

  handleClick(key) {
    if (key == 'notification') {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => const CreateModalBaseMenu(
                    title: 'Thông báo',
                    body: NotificationPage(),
                    buttonAppbar: SizedBox(),
                  )));
    } else if (key == 'search') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Search()));
    } else if (key == 'chat') {}
  }

  _showBottomNavigator(bool value) {
    if (showBottomNavigatorNotifier.value != value) {
      setState(() {
        showBottomNavigatorNotifier.value = value;
      });
    }
  }

  List iconActionWatch = [
    {"icon": Icons.search, 'type': 'icon'},
  ];

  List titles = const [
    SizedBox(),
    SizedBox(),
    SizedBox(),
    AppBarTitle(title: 'Watch')
  ];

  @override
  Widget build(BuildContext context) {
    size ??= MediaQuery.sizeOf(context);
    theme ??= pv.Provider.of<ThemeManager>(context);
    String modeTheme = theme!.themeMode == ThemeMode.dark
        ? 'dark'
        : theme!.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    List iconActionFeed = [
      {
        "key": "notification",
        "icon": modeTheme == 'dark'
            ? 'assets/NotiDM.svg'
            : 'assets/notification.svg',
        'type': 'image',
        "top": 6.0,
        "left": 6.0,
        "right": 6.0,
        "bottom": 6.0,
      },
      {"key": "search", "icon": Icons.search, 'type': 'icon'},
      {
        "key": "chat",
        "icon": modeTheme == 'dark' ? 'assets/ChatDM.svg' : 'assets/chat.svg',
        'type': 'image',
        "top": modeTheme == 'dark' ? 5.0 : 6.0,
        "left": modeTheme == 'dark' ? 5.0 : 5.5,
        "right": modeTheme == 'dark' ? 5.0 : 0.0,
        "bottom": modeTheme == 'dark' ? 5.0 : 0.0,
      }
    ];
    if (widget.selectedIndex != null) {
      setState(() {
        _selectedIndex = widget.selectedIndex!;
      });
    }
    List<Widget> pages = [
      Feed(
        callbackFunction: _showBottomNavigator,
      ),
      const Moment(typePage: 'home'),
      const SizedBox(),
      const Watch(),
      MainMarketPage(
        isBack: false,
        callbackFunction: _showBottomNavigator,
      )
    ];
    List actions = [
      List.generate(
          iconActionFeed.length,
          (index) => GestureDetector(
                onTap: () {
                  handleClick(iconActionFeed[index]['key']);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(left: 5, right: 8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.3)),
                  child: iconActionFeed[index]['type'] == 'icon'
                      ? Icon(
                          iconActionFeed[index]['icon'],
                          size: 20,
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              top: iconActionFeed[index]['top'],
                              left: iconActionFeed[index]['left'],
                              right: iconActionFeed[index]['right'],
                              bottom: iconActionFeed[index]['bottom']),
                          child: SvgPicture.asset(
                            iconActionFeed[index]['icon'],
                          ),
                        ),
                ),
              )),
      [const SizedBox()],
      [const SizedBox()],
      List.generate(
          iconActionWatch.length,
          (index) => Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(left: 5, right: 8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.withOpacity(0.3)),
              child: Icon(
                iconActionWatch[index]['icon'],
                size: 20,
                color: Theme.of(context).textTheme.displayLarge!.color,
              )))
    ];
    return Scaffold(
        drawer: _selectedIndex == 1 || _selectedIndex == 4
            ? null
            : Drawer(
                width: size!.width - 20,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: const Menu(),
              ),
        appBar: _selectedIndex == 1 || _selectedIndex == 4
            ? null
            : AppBar(
                elevation: 0,
                centerTitle: false,
                iconTheme: const IconThemeData(color: primaryColor),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                actions: actions.elementAt(_selectedIndex),
                title: titles.elementAt(_selectedIndex),
              ),
        body: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: showBottomNavigatorNotifier.value
            ? BottomNavigatorBarEmso(
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
              )
            : null);
  }
}
