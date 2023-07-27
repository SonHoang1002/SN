import 'package:isar/isar.dart';

part 'user_model.g.dart';

@collection
@Name("UserSchema")
class UserModel {
  Id id = Isar.autoIncrement;

  String? userData;
  String? userAbout;
  String? lifeEvent;
  String? postUser;
  String? pinPost;
  String? friend;
  String? featureContent;
  String? userType;
  // "me": current user on device,
  // "friend": current user on device's friend
  // "stranger": not a friend of current user on device == backend 's CAN_REQUEST
  // "requested": OUTGOING_REQUEST,

  String? userId;
}
