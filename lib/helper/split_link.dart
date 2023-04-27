import 'package:social_network_app_mobile/apis/create_post_apis/preview_url_post_api.dart';

Future<dynamic> getPreviewUrl(dynamic value) async {
  dynamic result;
  dynamic firstUrl = "";
  RegExp regExp = RegExp(r"(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+");
  final matches = regExp.allMatches(value).toList();
  for (Match match in matches) {
    firstUrl = match.group(0);
  }
  if (firstUrl != "") {
    final response = await PreviewUrlPostApi().getPreviewUrlPost(firstUrl);
    if (response != null && response.isNotEmpty) {
      result = response;
    }
  }
  return result;
}

bool checkPreviewUrl(dynamic value) {
  dynamic firstUrl = "";
  RegExp regExp = RegExp(r"(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+");
  final matches = regExp.allMatches(value).toList();
  for (Match match in matches) {
    firstUrl = match.group(0);
  }
  return firstUrl != "";
}
