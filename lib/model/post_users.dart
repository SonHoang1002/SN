import 'package:isar/isar.dart';

part 'post_users.g.dart';

@collection
@Name("PostUsersSchema")
class PostDataUsers {
  Id id = Isar.autoIncrement;
  // save list user that is parsed from listData
  String? listUser;
}



// data truyền vào listUser có dạng như sau:
//  {
//  "userData":{...},
//  "objectPosts":[
//     {...},
//     {...}
//  ]
//  }
