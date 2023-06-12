import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/search/search_provider.dart';
import 'package:social_network_app_mobile/screens/Search/search_item.dart';

class SearchResult extends ConsumerWidget {
  const SearchResult({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var searchResults = ref.watch(searchControllerProvider).search;

    List accounts = searchResults['accounts'] ?? [];
    List groups = searchResults['groups'] ?? [];
    List pages = searchResults['pages'] ?? [];

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
