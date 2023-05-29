import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market_place/helpers/common.dart';
import 'package:market_place/screens/Auth/storage.dart';
import 'package:market_place/apis/user.dart';

class MeProvider with ChangeNotifier {
  var meData;
  var myPages;
  List<dynamic> listAccount = [];

  getMeData() async {
    var token = await SecureStorage().getKeyStorage("token");
    meData = await ApiUser().getDataUserApi(token);
    myPages = await ApiUser().getListPagesApi(token);
    var newList = await SecureStorage().getKeyStorage('dataLogin');

    if (newList != null && newList != 'noData') {
      listAccount = jsonDecode(newList) ?? [];
    }

    if (meData != null) {
      await SecureStorage()
          .saveKeyStorage(jsonEncode(meData), 'currentAccount');

      var newAccount = {
        "id": meData['id'],
        "name": meData['display_name'],
        "show_url": meData['avatar_media']['show_url'],
        "token": token,
        "username": meData['username']
      };

      await SecureStorage().saveKeyStorage(
          jsonEncode(checkObjectUniqueInList([
            newAccount,
            ...listAccount,
          ], 'id')),
          'dataLogin');

      await SecureStorage().saveKeyStorage(meData['id'], 'userId');

      if (myPages != null) {
        await SecureStorage().saveKeyStorage(jsonEncode(myPages), 'myPages');
      }
      notifyListeners();
    } else {
      await SecureStorage().saveKeyStorage(
          jsonEncode(listAccount
              .map((element) => element['token'] == token
                  ? {...element, 'token': null}
                  : element)
              .toList()),
          'dataLogin');
      SecureStorage().deleteKeyStorage('token');
      SecureStorage().deleteKeyStorage('userId');
    }
  }

  resetMeData() async {
    if (meData != null) {
      meData = null;
      myPages = null;
      notifyListeners();
    }
  }
}
