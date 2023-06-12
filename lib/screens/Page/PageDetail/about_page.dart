import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/expandable_text.dart';

class AboutPage extends StatefulWidget {
  final dynamic aboutPage;
  final bool? isQuickShow;
  final Function? changeMenuSelected;
  const AboutPage(
      {super.key, this.aboutPage, this.isQuickShow, this.changeMenuSelected});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List listAboutPage = [];
  bool? quickShow = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        quickShow = widget.isQuickShow;
        listAboutPage = [
          {
            'key': 'description',
            'title': 'Mô tả',
            'subtitle': widget.aboutPage['description'],
            'icon': Icons.info
          },
          {
            'key': 'like',
            'title': 'Lượt thích',
            'subtitle': widget.aboutPage['like_count'].toString(),
            'icon': FontAwesomeIcons.thumbsUp
          },
          {
            'key': 'follow',
            'title': 'Lượt theo dõi',
            'subtitle': widget.aboutPage['follow_count'].toString(),
            'icon': FontAwesomeIcons.boxArchive
          },
          {
            'key': 'email',
            'title': 'Email',
            'subtitle': widget.aboutPage['email'],
            'icon': Icons.email
          },
          {
            'key': 'website',
            'title': 'Website',
            'subtitle': widget.aboutPage['website'],
            'icon': Icons.link
          },
          {
            'key': 'phone',
            'title': 'Số điện thoại',
            'subtitle': '09234090423',
            'icon': Icons.phone
          },
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 12, 12, quickShow == true ? 0 : 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            quickShow == true ? 'Chi tiết' : 'Tiểu sử',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
          ),
          const SizedBox(height: 8),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: listAboutPage.length,
              itemBuilder: (context, index) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -3),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      listAboutPage[index]['icon'],
                      size: 20,
                    ),
                  ),
                  minLeadingWidth: 30,
                  // contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  horizontalTitleGap: 12,
                  title: Text(
                    listAboutPage[index]['title'],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  subtitle: ExpandableTextContent(
                      content: listAboutPage[index]['subtitle'] == '' ||
                              listAboutPage[index]['subtitle'] == null
                          ? 'Chưa có ${listAboutPage[index]['title']}.'
                          : listAboutPage[index]['subtitle'],
                      maxLines: 5,
                      linkColor:
                          Theme.of(context).textTheme.bodyLarge!.color ?? white,
                      styleContent: const TextStyle(fontSize: 14),
                      hashtagStyle: const TextStyle(
                        color: secondaryColor,
                      )))),
          if (quickShow == true)
            ButtonPrimary(
              label: 'Xem tất cả',
              colorButton: secondaryColor,
              handlePress: () {
                if (widget.changeMenuSelected != null) {
                  widget.changeMenuSelected!();
                }
              },
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Divider(
              thickness: 1,
              height: 5,
            ),
          ),
          if (quickShow != true)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tính minh bạch của Trang',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                        'Emso hiển thị thông tin để bạn hiểu rõ mục đích Trang này.',
                        style: TextStyle(fontSize: 13)),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.flag,
                            size: 20,
                          ),
                        ),
                        Text(
                          'Trang được tạo vào ${convertTimeIsoToTimeShow(widget.aboutPage['created_at'], 'dMy', true)}.',
                        )
                      ],
                    )
                  ]),
            ),
        ],
      ),
    );
  }
}
