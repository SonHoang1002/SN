import 'package:isar/isar.dart';

part 'post_users.g.dart';

@collection
@Name("PostUsersSchema")
class PostDataUsers {
  Id id = Isar.autoIncrement;
  
  @ignore
  List<UserAndPost?>? listUser;
}

class UserAndPost {
  List<String?>? listObjectPost;
  /// user data include [token] and many attributes of user
  String? userData;
}
