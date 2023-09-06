import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/apis/user.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/connectivity_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/main_login_page.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/onboarding_login_page.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/widgets/snack_bar_custom.dart';

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
      Future.delayed(Duration.zero, () async {
        await ref
            .read(connectivityControllerProvider.notifier)
            .checkConnectivity();
      });
      SecureStorage().getKeyStorage("token").then((value) {
        if (value != 'noData') {
          Future.delayed(Duration.zero, () async {
            final connectionStatus =
                ref.read(connectivityControllerProvider).connectInternet;
            if (connectionStatus) {
              final response =
                  await UserApi().getAccountSettingApiWithToken(value);
              // {status_code: 403, content: {error: Your login is currently disabled, type: suspended}}
              if (response == null || response['status_code'] == 403) {
                // ignore: use_build_context_synchronously
                buildSnackBar(
                    context, "Tài khoản của bạn đang bị vô hiệu hoá !!");
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const OnboardingLoginPage())));
                return;
              }
            }
          });
          Future.delayed(const Duration(seconds: 1), () async {
            await ref.read(meControllerProvider.notifier).getMeData();
            // ignore: use_build_context_synchronously
            pushAndRemoveUntil(context, const Home());
          });
        } else {
          SecureStorage().getKeyStorage("dataLogin").then((value) {
            if (value.toString() == "[]" || value == "noData") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const MainLoginPage(null))));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const OnboardingLoginPage())));
            }
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(),
          SizedBox(
            child: Image.asset(
              "assets/Logo_Preview.png",
              height: 160.0,
              width: 160.0,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                const Text(
                  "From",
                  style: TextStyle(color: greyColor),
                ),
                Image.asset(
                  "assets/Logo_Producer.png",
                  height: 70.0,
                  width: 70.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
