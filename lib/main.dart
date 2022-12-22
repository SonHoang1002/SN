import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/app.dart';
import 'package:social_network_app_mobile/firebase_options.dart';

void main() async {
  if (!Platform.isWindows) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  runApp(const App());
}
