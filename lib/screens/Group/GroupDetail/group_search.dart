import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/apis/search_api.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/group_detail.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

import '../../Search/search_result_page_detail.dart';

class SearchGroup extends StatefulWidget {
  final dynamic groupDetail;
  final String query;
  const SearchGroup(
      {super.key, required this.groupDetail, required this.query});

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  List accounts = [];
  List statuses = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  getDataSearch(String? querryString) async {
    final response = await SearchApi().searchInGroup(
        id: widget.groupDetail?['id'], query: querryString ?? widget.query);
    setState(() {
      accounts = response["accounts"];
      statuses = response["statuses"];
      isLoading = false;
    });
  }

  @override
  void initState() {
    getDataSearch(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).textTheme.displayLarge!.color,
            )),
        title: Row(
          children: [
            Expanded(
                child: TextFormField(
              controller: searchController,
              onFieldSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  getDataSearch(value.trim());
                }
              },
              decoration: InputDecoration(
                hintText:
                    '${widget.query} trong ${widget.groupDetail["title"]}', // Set your hintText
                prefixIcon: const Icon(Icons.search,
                    color: Colors.grey), // Add a search icon
                filled: true,
                hintStyle: const TextStyle(fontSize: 16.0),
                fillColor: Colors.grey[300],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal:
                        8), // Adjust padding here // Set the background color
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Set border radius
                  borderSide: BorderSide.none, // Remove border
                ),
              ),
            )),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: buildCircularProgressIndicator(),
            )
          : (accounts.isEmpty && statuses.isEmpty)
              ? Center(
                  child: buildTextContent("Không tìm thấy dữ liệu", true,
                      isCenterLeft: false),
                )
              : SizedBox.expand(
                  child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (accounts.isNotEmpty)
                          buildTextContent("Mọi người", true),
                        AccountWidget(searchAccountDetail: accounts),
                        if (statuses.isNotEmpty)
                          buildTextContent("Bài viết", true),
                        StatusWidget(
                          searchStatusDetail: statuses,
                        )
                      ],
                    ),
                  ),
                )),
    );
  }
}
