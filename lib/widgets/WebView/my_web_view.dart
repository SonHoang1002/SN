import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/show_modal_message.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String title;
  final String selectedUrl;

  MyWebView({
    super.key,
    required this.title,
    required this.selectedUrl,
  });

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  dynamic _selectedOption;

  List dropDownItems = [
    "Xem các mục đã lưu",
    "Mở trong trình duyệt",
    "Sao chép liên kết",
    "Đánh dấu là đáng ngờ",
    "Cài đặt trình duyệt"
  ];
  chooseOption(String value) async {
    if (value == dropDownItems[0]) {
    } else if (value == dropDownItems[1]) {
      if (await canLaunchUrl(Uri.parse(widget.selectedUrl))) {
        await launchUrl(Uri.parse(widget.selectedUrl));
      } else {
        return;
      }
    } else if (value == dropDownItems[2]) {
      await Clipboard.setData(ClipboardData(text: widget.selectedUrl));
      // ignore: use_build_context_synchronously
      showSnackbar(context, "Sao chép thành công");
    } else if (value == dropDownItems[3]) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackIconAppbar(),
                AppBarTitle(
                  title: widget.title,
                ),
                PopupMenuButton<String>(
                  offset: const Offset(0, 40),
                  child: InkWell(
                      hoverColor: Colors.transparent,
                      child: Icon(
                        FontAwesomeIcons.ellipsis,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      )),
                  onSelected: (String value) {
                    chooseOption(value);
                  },
                  itemBuilder: (context) {
                    return dropDownItems.map((option) {
                      return PopupMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList();
                  },
                ),
                // DropdownButton<String>(
                //   value: _selectedOption,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       _selectedOption = newValue;
                //     });
                //   },
                //   items: dropDownItems.map((option) {
                //     return DropdownMenuItem<String>(
                //       value: option,
                //       child: Text(option),
                //     );
                //   }).toList(),
              ],
            )),
        body: WebView(
          initialUrl: widget.selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ));
  }
}



// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:social_network_app_mobile/theme/colors.dart';
// import 'package:webview_flutter/webview_flutter.dart';
 

// class MyWebView extends StatelessWidget {
//   final String title;
//   final String selectedUrl;

//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();

//   MyWebView({
//     super.key,
//     required this.title,
//     required this.selectedUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             elevation: 0,
//             automaticallyImplyLeading: false,
//             title: Text(
//               title,
//               style: const TextStyle(color: primaryColor),
//             ),
//             centerTitle: true,
//             leading: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               hoverColor: Colors.transparent,
//               child: const Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Icon(
//                   FontAwesomeIcons.chevronLeft,
//                   color: primaryColor,
//                 ),
//               ),
//             )),
//         body: WebView(
//           initialUrl: selectedUrl,
//           javascriptMode: JavascriptMode.unrestricted,
//           onWebViewCreated: (WebViewController webViewController) {
//             _controller.complete(webViewController);
//           },
//         ));
//   }
// }

