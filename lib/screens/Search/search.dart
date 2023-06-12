import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/search_api.dart';
import 'package:social_network_app_mobile/providers/search/search_provider.dart';
import 'package:social_network_app_mobile/screens/Search/searchHistory.dart';
import 'package:social_network_app_mobile/screens/Search/search_result.dart';
import 'package:social_network_app_mobile/screens/Search/search_result_page_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/search_input.dart';

class Search extends ConsumerStatefulWidget {
  final String? keyword;
  const Search({Key? key, this.keyword}) : super(key: key);

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  String keyword = '';
  var searchResults = {};
  bool isShowPageDetail = false;
  List paramsType = ['accounts', 'pages', 'groups'];
  fetchSearch(params) async {
    ref.read(searchControllerProvider.notifier).getSearch(params);
  }

  handleSearch(value) {
    if (value.isEmpty) {
      fetchSearch({
        "type[]": paramsType.map((e) => e).toList(),
        "q": '',
        "limit": 3,
      });
      setState(() {
        keyword = '';
      });
      return;
    }
    EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
        () {
      fetchSearch({
        "type[]": paramsType.map((e) => e).toList(),
        "q": value,
        "limit": 3,
      });
    });
    setState(() {
      keyword = value;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await ref
          .read(searchControllerProvider.notifier)
          .getSearchHistory({"limit": 6, "page": 1, "global": true});
    });
    if (widget.keyword != null) {
      setState(() {
        keyword = widget.keyword!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List searchHistory = ref.watch(searchControllerProvider).searchHistory;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const BackIconAppbar(),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
                child: SearchInput(
              initValue: widget.keyword ?? '',
              handleSearch: handleSearch,
            ))
          ],
        ),
      ),
      body: Column(
        children: [
          keyword != ''
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    SearchResultPageDetail(keyword: keyword)));
                        ref
                            .read(searchControllerProvider.notifier)
                            .getSearchDetail(
                                {"q": keyword, 'offset': 1, "limit": 5});
                      });
                      SearchApi().postSearchHistoriesApi({"keyword": keyword});
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(0.3)),
                            child: const Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              color: secondaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text.rich(
                              key: ValueKey(keyword),
                              TextSpan(
                                  text: 'Tìm kiếm ',
                                  style: const TextStyle(
                                      fontSize: 13, color: secondaryColor),
                                  children: [
                                    TextSpan(
                                        text: keyword,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600))
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          keyword != ''
              ? const SearchResult()
              : SearchHistory(searchHistory: searchHistory),
        ],
      ),
    );
  }
}
