import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Login/LoginCreateModules/onboarding_login_page.dart';
import 'package:social_network_app_mobile/storage/storage.dart';

import '../theme/colors.dart';
import 'home.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  void initState() {
    if (mounted) {
      SecureStorage().getKeyStorage("userId").then((value) {
        if (value != 'noData') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: ((context) => const Home())));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => OnboardingLoginPage())));
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Text(
              "Emso",
              style: TextStyle(
                  fontSize: 26,
                  color: primaryColor,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              "Social",
              style: TextStyle(
                  fontSize: 26,
                  color: secondaryColor,
                  fontWeight: FontWeight.w700),
            )
          ]),
        ),
      ),
    );
  }
}
