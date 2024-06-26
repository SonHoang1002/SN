import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  CategoryModel model = CategoryModel([]);
  setAddCategoryProvider(String value) {
    model.listCate.add(value);
    notifyListeners();
  }

  setDeleteCategoryProvider(String value) {
    model.listCate.remove(value);
    notifyListeners();
  }

  get getCategoryProvider => model;
}

class CategoryModel {
  final List<String> listCate;
  CategoryModel(this.listCate);
}
