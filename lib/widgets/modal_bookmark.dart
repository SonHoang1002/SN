import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/bookmark_api.dart';
import 'package:social_network_app_mobile/model/bookmark.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:provider/provider.dart' as pv;

class ModalBookmark extends StatefulWidget {
  const ModalBookmark({super.key});

  @override
  ModalBookmarkState createState() => ModalBookmarkState();
}

class ModalBookmarkState extends State<ModalBookmark> {
  List<dynamic> collections = [];
  String _bookmarkCollectionId = "";
  var _controller = TextEditingController();

  void getBookmarkCollection() async {
    var result = await BookmarkApi().fetchBookmarkCollection();
    setState(() {
      collections = result;
      _bookmarkCollectionId = result[0]['id'];
    });
  }

  @override
  void initState() {
    getBookmarkCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    final titleStyle = TextStyle(
      fontSize: 17.5,
      color: theme.isDarkMode ? Colors.white : Colors.black,
      fontWeight: FontWeight.bold,
    );
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.55,
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Tạo bộ sưu tập', style: titleStyle),
                      content: TextFormField(
                        style: const TextStyle(fontSize: 18.0),
                        cursorColor: Colors.blue,
                        controller: _controller,
                        autofocus: true,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: Text('Hủy', style: titleStyle),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: const Text('Tạo',
                              style: TextStyle(
                                fontSize: 17.5,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.grey[350],
                      child: const Icon(
                        FontAwesomeIcons.plus,
                        size: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text("Bộ sưu tập mới", style: titleStyle),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.5),
            ListView.builder(
              itemCount: collections.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final collection = collections[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.lightBlue[200],
                          child: Icon(
                            FontAwesomeIcons.bookmark,
                            size: 20.0,
                            color:
                                theme.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(collection['name'], style: titleStyle),
                      ),
                      Expanded(
                        flex: 1,
                        child: Radio<String>(
                          value: collection['id'],
                          groupValue: _bookmarkCollectionId,
                          onChanged: (String? value) {
                            setState(() {
                              _bookmarkCollectionId = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
