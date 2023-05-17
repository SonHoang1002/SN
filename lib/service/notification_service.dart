import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();
  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/launcher_icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          if (payload != null) {
            onNotificationClick.add(payload);
          }
        });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload != null &&
          notificationResponse.payload!.isNotEmpty) {
        onNotificationClick.add(notificationResponse.payload);
      }
    });
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  notificationDetails(String? largeIcon) async {
    final String largeIconPath = Platform.isAndroid
        ? await _downloadAndSaveFile('$largeIcon', 'largeIcon')
        : await _downloadAndSaveFile('$largeIcon', 'largeIcon.jpg');

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(largeIconPath),
            hideExpandedLargeIcon: true,
            htmlFormatContentTitle: true,
            htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            styleInformation: bigPictureStyleInformation,
            ticker: 'ticker');
    final DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(attachments: <DarwinNotificationAttachment>[
      DarwinNotificationAttachment(
        largeIconPath,
        hideThumbnail: false,
      )
    ]);
    return NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }

  Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      String? largeIcon}) async {
    return notificationsPlugin.show(
        id++, title, body, await notificationDetails(largeIcon));
  }
}
