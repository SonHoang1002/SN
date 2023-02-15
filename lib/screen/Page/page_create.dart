import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/page_constants.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreateModules/screen/name_page_page.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';



final TextStyle textStyle = TextStyle(color: Colors.white);
final whiteColor = Colors.white;
final List<String> questionPolicy = [
  "Bằng việc tạo Trang, bạn đồng ý với ",
  "Chính sách về Trang, Nhóm và Sự kiện"
];
final String page = "Trang";

late int inPage = 1;
final String begin = "Bắt đầu";
late double width = 0;
late double height = 0;
var content = RichText(
  textAlign: TextAlign.justify,
  text: TextSpan(
    children: <TextSpan>[
      TextSpan(text: questionPolicy[0]),
      TextSpan(text: questionPolicy[1], style: TextStyle(color: Colors.blue)),
    ],
  ),
);

class PageCreate extends StatefulWidget {
  const PageCreate({Key? key}) : super(key: key);

  @override
  State<PageCreate> createState() => _PageCreateState();
}

class _PageCreateState extends State<PageCreate> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        // color: Colors.red,
        child: Stack(
          children: [
            PageView.builder(
                itemCount: 3,
                onPageChanged: (indexPage) {
                  setState(() {
                    inPage = indexPage + 1;
                  });
                },
                itemBuilder: ((context, index) {
                  return Container(
                      height: double.infinity,
                      child: Image.asset(
                          fit: BoxFit.cover,
                          PageConstants.PATH_IMG + "back_${index + 1}.jpg"));
                })),
            _buildBottomWidget(context)
          ],
        ),
      ),
    );
  }
}

Widget _buildBottomWidget(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        height: 150,
        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
        child: Column(children: [
          Center(
            child: Container(
              height: 10,
              margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: ((context, index) {
                    if (index == inPage - 1) {
                      return Container(
                        height: 10,
                        width: 10,
                        margin: EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                      );
                    }
                    return Container(
                      height: 10,
                      width: 10,
                      margin: EdgeInsets.symmetric(horizontal: 2.5),
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5)),
                    );
                  })),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(0.9 * width, 40),
              ),
              // style: ButtonStyle(),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => NamePagePage()));
              },
              child: Center(
                child: Text(
                  begin,
                  style: TextStyle(color: whiteColor, fontSize: 20),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(width: width * 0.8, child: content),
          )
        ]),
      )
    ],
  );
}
