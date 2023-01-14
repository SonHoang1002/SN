import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screen/Search/searchHistory.dart';
import 'package:social_network_app_mobile/screen/Search/search_result.dart';
import 'package:social_network_app_mobile/screen/Search/search_result_page_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String keyword = '';
  bool isShowPageDetail = false;

  @override
  Widget build(BuildContext context) {
    handleSearch(value) {
      setState(() {
        keyword = value;
      });
    }

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
              handleSearch: handleSearch,
            ))
          ],
        ),
      ),
      body: isShowPageDetail
          ? SearchResultPageDetail(keyword: keyword)
          : Column(
              children: [
                keyword != ''
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isShowPageDetail = true;
                            });
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Text.rich(
                                    TextSpan(
                                        text: 'Tìm kiếm ',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: secondaryColor),
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
                keyword != '' ? const SearchResult() : const SearchHistory(),
              ],
            ),
    );
  }
}
