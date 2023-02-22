import 'package:flutter/cupertino.dart';

class RouteProvider with ChangeNotifier {
  List<bool> routeList = [
    true,
    false,
    false,
    false,
    false,
    false,
  ];
  setRouteProvider( int index) {
    List<bool> primaryList = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];
    primaryList[index] = true;
    routeList = primaryList;
    notifyListeners();
    print(routeList);
  }

  List<bool> get getRouteList => routeList;
}
