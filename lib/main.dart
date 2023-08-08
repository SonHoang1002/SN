import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/app.dart';
import 'package:social_network_app_mobile/services/isar_post_service.dart';
import 'package:social_network_app_mobile/services/notification_service.dart';

void main() async {
  // if (!Platform.isWindows) {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform);
  // }
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  HttpOverrides.global = MyHttpOverrides();

  debugProfileBuildsEnabled = true;
  runApp(
    const ProviderScope(
      child: App(),
    ),
  ); 
    await IsarPostService().getEarlyPost();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
