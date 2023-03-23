String urlRegExp = r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+';

String hashtagRegExp = r'(#+[a-zA-Z0-9(_)]{1,})';

String userTagRegExp = r'(?<![\w@])@([\w@]+(?:[.!][\w@]+)*)';

String emailRegExp =
    r"([a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+)";

getMatchedType(String text) {
  String type = '';
  if (RegExp(urlRegExp).hasMatch(text)) {
    type = 'url';
  } else if (RegExp(hashtagRegExp).hasMatch(text)) {
    type = 'hashtag';
  } else if (RegExp(emailRegExp).hasMatch(text)) {
    type = 'email';
  } else if (RegExp(userTagRegExp).hasMatch(text)) {
    type = 'userTag';
  }
  return type;
}
