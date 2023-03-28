import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/authen_api.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/home/PreviewScreen.dart';
import 'package:social_network_app_mobile/home/home.dart';
import 'package:social_network_app_mobile/screen/Login/LoginCreateModules/confirm_login_page.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId:
      '465933365763-5kq97dko2a2tq95vpb3gna47vm2svna1.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class MainLoginPage extends ConsumerStatefulWidget {
  const MainLoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MainLoginPage> createState() => _MainLoginPageState();
}

class _MainLoginPageState extends ConsumerState<MainLoginPage> {
  String username = '';
  String password = '';
  bool showPassword = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (mounted) {
        account?.authentication.then((value) {
          handleLoginByGoogle(value.accessToken);
        });
      }
    });
    if (mounted) {
      _googleSignIn.signInSilently();
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
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        hiddenKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const BackIconAppbar(), Container()],
          ),
        ),
        body: getBody(context, size),
      ),
    );
  }

  void completeLogin() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const Home(),
      ),
    );
  }

  handleLogin() async {
    setState(() {
      isLoading = true;
    });
    var data = {
      "client_id": "Ev2mh1kSfbrea3IodHtNd7aA4QlkMbDIOPr4Y5eEjNg",
      "client_secret": "f2PrtRsNb7scscIn_3R_cz6k_fzPUv1uj7ZollSWBBY",
      "grant_type": "password",
      "scope": "write read follow",
      "username": username,
      "password": password,
    };

    var response = await AuthenApi().fetchDataToken(data);
    if (response != null && response['access_token'] != null) {
      await SecureStorage().saveKeyStorage(response['access_token'], 'token');
      completeLogin();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
                "Tài khoản hoặc mật khẩu không đúng, vui lòng kiểm tra lại")));
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
        // completeLogin();
        // if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const PreviewScreen(),
          ),
        );
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
          const SizedBox(
            height: 15,
          ),
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
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 5, top: 5),
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
                ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18))),
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
                  onPressed:
                      username.trim().isNotEmpty && password.trim().isNotEmpty
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
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
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    pushToNextScreen(context, const ConfirmLoginPage());
                  },
                  child: const Text(
                    "Bạn quên mật khẩu ư?",
                    style: TextStyle(color: primaryColor, fontSize: 17),
                  )),
            ],
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
