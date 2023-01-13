import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/search.dart';
import 'package:social_network_app_mobile/screen/Search/search_item.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List accounts = searchResultKeyword['accounts'] ?? [];
    List groups = searchResultKeyword['groups'] ?? [];
    List pages = searchResultKeyword['pages'] ?? [];

    List newList = [...accounts, ...groups, ...pages];

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: List.generate(
            newList.length, (index) => SearchItem(item: newList[index])),
      ),
    );
  }
}
