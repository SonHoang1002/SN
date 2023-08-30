import 'package:isar/isar.dart';

part 'post_model.g.dart';

@collection
@Name("PostSchema")
class PostModel {
  Id id = Isar.autoIncrement;

  String? objectPost;

  String? postId;
}