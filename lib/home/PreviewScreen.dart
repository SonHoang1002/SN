import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/main_login_page.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/onboarding_login_page.dart';
import 'package:social_network_app_mobile/storage/storage.dart';

import '../theme/colors.dart';
import 'home.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    if (mounted) {
      SecureStorage().getKeyStorage("token").then((value) {
        if (value != 'noData') {
          Future.delayed(const Duration(seconds: 1), () async {
            await ref.read(meControllerProvider.notifier).getMeData();
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => const Home())));
          });
        } else {
            SecureStorage().getKeyStorage("dataLogin").then((value) {
            if(value.toString() == "[]" || value == "noData"){
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => const MainLoginPage(null))));
            }
            else{
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => const OnboardingLoginPage())));
            }
          });
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
