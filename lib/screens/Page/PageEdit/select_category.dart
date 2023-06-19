import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

import '../../../providers/page/page_provider.dart';
import '../../../theme/colors.dart';
import '../../../theme/theme_manager.dart';
import '../../../widgets/button_primary.dart';

class SelectCategory extends ConsumerStatefulWidget {
  const SelectCategory({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends ConsumerState<SelectCategory> {
  dynamic selectedCategory;
  List categories = [];
  final TextEditingController searchController =
      TextEditingController(text: "");

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    categories = ref
        .watch(pageControllerProvider)
        .pageCategory
        .where((category) =>
            searchController.text.isEmpty ||
            category['text']
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Chọn hạng mục'),
      ),
      body: Column(
        children: [
          selectedCategory == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 35,
                        maxWidth: 400,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              searchController.text = value;
                            });
                          },
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: searchController.text,
                              selection: TextSelection.collapsed(
                                offset: searchController.text.length,
                              ),
                            ),
                          ),
                          autofocus: true,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            hintText: "Tìm kiếm bạn bè",
                            hintStyle: TextStyle(
                              color:
                                  theme.isDarkMode ? Colors.grey : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 20,
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                });
                              },
                              icon: Icon(
                                Icons.clear,
                                size: 20,
                                color: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 20,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(
                        'Được gợi ý',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 0.0,
                              ),
                              visualDensity: const VisualDensity(
                                horizontal: -4,
                                vertical: -3,
                              ),
                              dense: true,
                              title: Text(
                                categories[index]['text'],
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedCategory = categories[index];
                                });
                              },
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                )
              : Column(
                  children: [
                    ListTile(
                      title: Text(
                        selectedCategory['text'],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: Checkbox(
                        activeColor: secondaryColor,
                        checkColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            searchController.text = selectedCategory['text'];
                            selectedCategory = null;
                          });
                        },
                        value: true,
                      ),
                    ),
                  ],
                ),
          Visibility(
            visible: selectedCategory != null,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 16.0, right: 16.0, left: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Divider(
                      height: 20,
                      thickness: 1,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonPrimary(
                        label: 'Lưu',
                        handlePress: () {
                          Navigator.pop(context, selectedCategory);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
