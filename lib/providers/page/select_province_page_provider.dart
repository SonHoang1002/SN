import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/constant/page_constants.dart';

class SelectProvinceProvider with ChangeNotifier {
  List<dynamic> selectList = []; // Initialize as an empty list

  // Add a method to update selectList with data from the API
  updateSelectList(List<dynamic> apiData) {
    selectList = apiData;
    notifyListeners();
  }

  // Existing setSelectProvinceProvider method
  void setSelectProvinceProvider(String selectString) {
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
