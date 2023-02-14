import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/app.dart';

void main() async {
  // if (!Platform.isWindows) {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform);
  // }
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
