import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
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
    final _instance = await IsarService.instance;
    final count = await _instance.postModels.count();
    return count;
  }

  Future<List> getAllPostsFromIsar() async {
    final _instance = await IsarService.instance;
    final postsModelIsar = await _instance.postModels.where().findAll();
    return postsModelIsar.map((e) => jsonDecode(e.objectPost!)).toList();
  }

  addPostIsar(List listPost) async {
    final _instance = await IsarService.instance;
    await _instance.writeTxn(() async {
      for (var newPost in listPost) {
        await _instance.postModels.put(PostModel()
          ..objectPost = jsonEncode(newPost)
          ..postId = (newPost['id']));
      }
    });
  }

  resetPostIsar() async {
    final _instance = await IsarService.instance;
    if (_instance.isOpen == true) {
      _instance.writeTxn(() async {
        await _instance.postModels.where().deleteAll();
      });
    }
  }
}
