import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class PageActivity extends StatefulWidget {
  final dynamic data;
  const PageActivity({super.key, this.data});

  @override
  State<PageActivity> createState() => _PageActivityState();
}

class _PageActivityState extends State<PageActivity> {
  List data = [];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var res = await PageApi()
        .getManagementHistory({"sort_direction": 'desc'}, widget.data['id']);
    if (res != null) {
      setState(() {
        data = res;
      });
    }
  }

  Widget extractDescription(dynamic object) {
    String description = object["description"].toString();
    description = description.replaceAll(RegExp(r'\s{2,}'), ' ');

    if (object["includes"] != null && object["includes"].isNotEmpty) {
      for (var include in object["includes"]) {
        if (include["id"] != null && include["title"] != null) {
          final id = include["id"].toString();
          final title = include["title"].toString();

          if (description.contains('[$id]')) {
            description = description.replaceAll('[$id]', '[$title]');
          }
        }
      }
    }

    List<TextSpan> textSpans = [];
    List<String> words = description.split(' ');

    for (var word in words) {
      if (word.startsWith('[') && word.endsWith(']')) {
        String title = word.substring(1, word.length - 1);
        textSpans.add(
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: word,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      }
      textSpans.add(const TextSpan(text: ' '));
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }

  String extractImage(dynamic object) {
    String description = object["description"].toString();
    if (object["includes"] != null && object["includes"].isNotEmpty) {
      for (var include in object["includes"]) {
        if (include["id"] != null && include["title"] != null) {
          final id = include["id"].toString();
          if (description.contains('[$id]')) {
            return description = include["avatar"].toString();
          }
        }
      }
    }
    return description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Nhật ký hoạt động'),
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                visualDensity: const VisualDensity(horizontal: -4, vertical: 0),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                      child: ExtendedImage.network(extractImage(data[index]))),
                ),
                title: extractDescription(data[index]),
                subtitle: Text(GetTimeAgo.parse(
                    DateTime.parse(data[index]['created_at']))),
                onTap: () {});
          }),
    );
  }
}
