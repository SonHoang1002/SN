import 'package:flutter/material.dart';

import 'package:social_network_app_mobile/constant/page_constants.dart';

class SearchCategoryProvider with ChangeNotifier {
  List<String> searchList = CategoryPageConstants.listSelection;
  setSearchCategoryProvider(String searchString) {
    List<String> searchValueList = [];
    List<String> primaryList = CategoryPageConstants.listSelection;
    for (int i = 0; i < primaryList.length; i++) {
      if (primaryList[i].contains(searchString.toLowerCase()) ||
          primaryList[i].contains(searchString.toLowerCase())) {
        searchValueList.add(primaryList[i]);
      }
    }
    searchList = searchValueList;
  }

  get getSearchCategoryProvider => searchList;
}
