import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/authen_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/home/preview_screen.dart';
import 'package:social_network_app_mobile/home/home.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/confirm_login_page.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

import 'begin_join_emso_login_page.dart';

class MainLoginPage extends ConsumerStatefulWidget {
  final dynamic accountChoose;
  const MainLoginPage(this.accountChoose, {Key? key}) : super(key: key);

  @override
  ConsumerState<MainLoginPage> createState() => _MainLoginPageState();
}

class _MainLoginPageState extends ConsumerState<MainLoginPage> {
  String username = '';
  String password = '';
  bool showPassword = false;
  bool isLoading = false;
  dynamic currentAccount;
  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      _googleSignIn = GoogleSignIn();
    } else {
      _googleSignIn = GoogleSignIn(
        clientId:
            '210278496786-7esfchosldt9ontl99089f8hg35ear8i.apps.googleusercontent.com',
      );
    }

    if (mounted) {
      _googleSignIn.signInSilently();
    }

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (mounted) {
        account?.authentication.then((value) {
          handleLoginByGoogle(value.accessToken);
        });
      }
    });

    if (widget.accountChoose != null) {
      if (mounted) {
        setState(() {
          currentAccount = widget.accountChoose;
        });
      }
    }
  }

  Future<void> _handleSignIn() async {
    try {
      if (mounted) {
        await _googleSignIn.signIn();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        hiddenKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Container()],
          ),
        ),
        body: getBody(context, size),
      ),
    );
  }

  void completeLogin() {
   pushAndRemoveUntil(context, const Home());
  }

  handleLogin() async {
    hiddenKeyboard(context);
    setState(() {
      isLoading = true;
    });
    var data = {
      "client_id": "Ev2mh1kSfbrea3IodHtNd7aA4QlkMbDIOPr4Y5eEjNg",
      "client_secret": "f2PrtRsNb7scscIn_3R_cz6k_fzPUv1uj7ZollSWBBY",
      "grant_type": "password",
      "scope": "write read follow",
      "username": currentAccount?['username'] ?? username.trim(),
      "password": password.trim(),
    };

    var response = await AuthenApi().fetchDataToken(data);
    if (response != null && response?['access_token'] != null) {
      await SecureStorage().saveKeyStorage(response['access_token'], 'token');
      completeLogin();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: response?['status'] == 500
              ? const Text("Máy chủ đang gặp vấn đề. Vui lòng thử lại sau")
              : const Text(
                  "Tài khoản hoặc mật khẩu không đúng, vui lòng kiểm tra lại",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
          duration: const Duration(seconds: 3),
          backgroundColor: secondaryColor,
        ));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  handleLoginByGoogle(token) async {
    var response = await AuthenApi().loginByGoogle(token);
    if (response != null && response['access_token'] != null) {
      SecureStorage()
          .saveKeyStorage(response['access_token'], 'token')
          .then((value) async {
        await _handleSignOut();
        // ignore: use_build_context_synchronously
        pushAndRemoveUntil(context,const PreviewScreen());
        // }
      });
    }
  }

  getBody(context, size) {
    return SizedBox(
      height: size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          const SizedBox(
            height: 15,
          ),
          if (currentAccount == null)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Sử dụng email/số điện thoại hoặc tài khoản Google",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                if (currentAccount == null)
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 5, top: 5),
                      child: TextField(
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              username = value;
                            });
                          }
                        },
                        cursorColor:
                            Theme.of(context).textTheme.displayLarge?.color,
                        decoration: const InputDecoration(
                            hintText: "Email hoặc số điện thoại",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17),
                            border: InputBorder.none),
                      ),
                    ),
                  )
                else
                  Column(children: [
                    Stack(alignment: AlignmentDirectional.topEnd, children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                              bottom: 5, right: 5, left: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: ImageCacheRender(
                              path: currentAccount?['show_url'] ??
                                  linkAvatarDefault,
                              width: 99.8,
                              height: 99.8,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              currentAccount = null;
                            });
                          }
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.withOpacity(0.9)),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(
                            FontAwesomeIcons.xmark,
                            size: 18,
                          ),
                        ),
                      )
                    ]),
                    SizedBox(
                        width: 100,
                        child: Text(
                          currentAccount['name'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ))
                  ]),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.only(
                          topLeft: currentAccount != null
                              ? const Radius.circular(15)
                              : Radius.zero,
                          topRight: currentAccount != null
                              ? const Radius.circular(15)
                              : Radius.zero,
                          bottomLeft: const Radius.circular(15),
                          bottomRight: const Radius.circular(15))),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 5, bottom: 5),
                    child: Stack(
                        alignment: const Alignment(1.0, 1.0),
                        children: <Widget>[
                          TextField(
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  password = value;
                                });
                              }
                            },
                            obscureText: !showPassword,
                            cursorColor:
                                Theme.of(context).textTheme.displayLarge?.color,
                            decoration: const InputDecoration(
                                hintText: "Mật khẩu",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 17),
                                border: InputBorder.none),
                          ),
                          IconButton(
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              }
                            },
                            icon: Icon(
                                showPassword
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.eye,
                                size: 18),
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: const Size.fromHeight(47),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: (username.trim().isNotEmpty ||
                              currentAccount?['username'] != null) &&
                          password.trim().isNotEmpty
                      ? isLoading
                          ? null
                          : handleLogin
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.arrowRightToBracket,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      isLoading
                          ? const CupertinoActivityIndicator()
                          : const Text(
                              'Đăng nhập',
                              style: TextStyle(fontSize: 17),
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: const Size.fromHeight(47),
                      backgroundColor: const Color(0xfff1f2f5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    _handleSignIn();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.google,
                        size: 18,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Đăng nhập bằng Google',
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      )
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      pushToNextScreen(context, const ConfirmLoginPage());
                    },
                    child: const Text(
                      "Bạn quên mật khẩu ư?",
                      style: TextStyle(color: primaryColor, fontSize: 17),
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: const Size.fromHeight(47),
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                pushToNextScreen(context, BeginJoinEmsoLoginPage());
              },
              child: const Text(
                'Đăng ký tài khoản Emso',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
