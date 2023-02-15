import 'package:flutter/cupertino.dart';

import '../constant/page_constants.dart';

class SelectProvinceProvider with ChangeNotifier {
  List<String> selectList = InformationPageConstants.PROVINCE_LIST;
  setSelectProvinceProvider(String selectString) {
    List<String> selectValueList = [];
    List<String> primaryList = InformationPageConstants.PROVINCE_LIST;
    for (int i = 0; i < primaryList.length; i++) {
      if (primaryList[i].contains(selectString.toLowerCase()) ||
          primaryList[i].contains(selectString.toUpperCase())) {
        selectValueList.add(primaryList[i]);
      }
    }
    selectList = selectValueList;

    notifyListeners();
  }
}
