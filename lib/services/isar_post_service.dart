import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:social_network_app_mobile/model/post_model.dart';
import 'package:social_network_app_mobile/services/isar_service.dart';

class IsarPostService {
  Future<List> getPostsWithNumber(int number, dynamic lastPost) async {
    List postsOnIsar = await getAllPostsFromIsar();
    int indexOnIsar = postsOnIsar.indexWhere((e) => e['id'] == lastPost['id']);
    if (indexOnIsar >= 0) { 
      // kiem tra xem trong isar co du so luong bai can khong
      if (indexOnIsar + number < (await getCountPostIsar())) {
        return [...postsOnIsar.sublist(indexOnIsar + 1, indexOnIsar + number)];
      } else {
        return [...postsOnIsar];
      }
    }
    return [];
  }

  Future<int> getCountPostIsar() async {
    final instance = await IsarService.instance;
    final count = await instance.postModels.count();
    return count;
  }

  Future<List> getAllPostsFromIsar() async {
    final instance = await IsarService.instance;
    final postsModelIsar = await instance.postModels.where().findAll();
    return postsModelIsar.map((e) => jsonDecode(e.objectPost!)).toList();
  }

  addPostIsar(List listPost) async {
    final instance = await IsarService.instance;
    await instance.writeTxn(() async {
      for (var newPost in listPost) {
        await instance.postModels.put(PostModel()
          ..objectPost = jsonEncode(newPost)
          ..postId = (newPost['id']));
      }
    });
  }

  resetPostIsar() async {
    final instance = await IsarService.instance;
    if (instance.isOpen == true) {
      instance.writeTxn(() async {
        await instance.postModels.where().deleteAll();
      });
    }
  }
}
