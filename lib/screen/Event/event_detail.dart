import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class EventDetail extends StatefulWidget {
  final dynamic eventDetail;
  const EventDetail({Key? key, this.eventDetail}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

const textEvent =
    'Bốn khóa học về giới không thể bỏ lỡ của VGEM đã trở lại! TRIẾT HỌC VỀ GIỚI: giúp bạn nhìn giới và thế giới sâu, rộng và gần thực tế hơn. Các khung lý thuyết giúp bạn làm sáng rõ những khoảng mờ và mở ra nhiều cách tiếp cận về giới thú vị.CÁC LÀN SÓNG NỮ QUYỀN: giúp bạn hiểu về lịch sử thúc đẩy bình đẳng giới trên thế giới và ở Việt Nam để hiểu các vấn đề bất bình đẳng giới đương đại sâu sắc, phù hợp với văn hóa Việt Nam và đồng nhịp với phong trào bình đẳng giới toàn cầu. THIẾT KẾ VÀ LẬP KẾ HOẠCH DỰ ÁN VỀ GIỚI: giúp bạn phân tích vấn đề toàn diện để chọn chiến lược và can thiệp hiệu quả và bền vững nhất. TOT VỀ GIỚI: bạn sẽ được học qua trải nghiệm và cách áp dụng chu trình học qua trải nghiệm (Experiential Learning Cycle) để thiết kế các bài học về giới. Ngoài những nội dung then chốt và các giảng viên quen thuộc, chuỗi bốn khóa học về giới 2023 sẽ có những giảng viên mới, nội dung mới và đặc biệt cách học mới. Hãy giữ lịch ngay và chuẩn bị đăng ký tham gia các khóa học này của VGEM nhé. Các thông tin chi tiết về khóa học sẽ được cập nhật trên FB của VGEM sớm.';

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0.0, 2.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Hero(
                    tag: widget.eventDetail['banner']['url'],
                    child: ClipRRect(
                      child: ImageCacheRender(
                        path: widget.eventDetail['banner']['preview_url'],
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 60.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        margin: const EdgeInsets.fromLTRB(2, 0, 0, 10),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(width: 0.2, color: greyColor)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(FontAwesomeIcons.angleLeft,
                                color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      GetTimeAgo.parse(
                        DateTime.parse(widget.eventDetail['start_time']),
                      ),
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      widget.eventDetail['title'],
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      // eventDetail['location'],
                      'HÀ NỘI · Hà Nội',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: greyColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '${widget.eventDetail['users_interested_count'].toString()} người quan tâm · ${widget.eventDetail['users_going_count'].toString()} người tham gia ',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: greyColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(children: [
              SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 24,
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: const EdgeInsets.fromLTRB(10, 0, 6, 10),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(FontAwesomeIcons.solidStar,
                                  color: Colors.black, size: 14),
                              SizedBox(
                                width: 3.0,
                              ),
                              Text(
                                'Quan tâm',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )),
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 24,
                          width: MediaQuery.of(context).size.width * 0.3,
                          margin: const EdgeInsets.fromLTRB(2, 0, 6, 10),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(189, 202, 202, 202),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(FontAwesomeIcons.clipboardQuestion,
                                  color: Colors.black, size: 14),
                              SizedBox(
                                width: 3.0,
                              ),
                              Text(
                                'Sẽ tham gia',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )),
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 24,
                          width: MediaQuery.of(context).size.width * 0.1,
                          margin: const EdgeInsets.fromLTRB(2, 0, 0, 10),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(189, 202, 202, 202),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(FontAwesomeIcons.ellipsis,
                                  color: Colors.black, size: 14),
                            ],
                          ),
                        ))
                  ],
                ),
              )
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(FontAwesomeIcons.stopwatch,
                                color: Colors.black, size: 20),
                            SizedBox(
                              width: 9.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Text(
                                '43 Ngày',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(FontAwesomeIcons.solidUser,
                                  color: Colors.black, size: 20),
                              SizedBox(
                                width: 9.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Sự kiện của ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(FontAwesomeIcons.locationDot,
                                color: Colors.black, size: 20),
                            const SizedBox(
                              width: 9.0,
                            ),
                            Column(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 4),
                                  child: Text('Sự kiện của ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                Text('Sự kiện của ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: greyColor,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(FontAwesomeIcons.clipboardCheck,
                                  color: Colors.black, size: 20),
                              SizedBox(
                                width: 9.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Sự kiện của ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(FontAwesomeIcons.earthAmericas,
                                  color: Colors.black, size: 20),
                              SizedBox(
                                width: 9.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Công khai · Bất kỳ ai ở trên hoặc ngoài Facebook',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 24,
                              width: MediaQuery.of(context).size.width * 0.45,
                              margin: const EdgeInsets.fromLTRB(4, 0, 10, 10),
                              decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(width: 0.2, color: greyColor)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Giới thiệu',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                            )),
                        GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 24,
                              width: MediaQuery.of(context).size.width * 0.45,
                              margin: const EdgeInsets.fromLTRB(2, 0, 0, 10),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(189, 202, 202, 202),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(width: 0.2, color: greyColor)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Cuộc thảo luận',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  const CrossBar(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chi tiết sự kiện',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: const Text(
                          textEvent,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF212121),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            FontAwesomeIcons.facebook,
                            color: Colors.blue,
                          ),
                          title: const Text(
                            'Tính minh bạch của sự kiện',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            'Emso hiển thị thông tin để bạn hiểu rõ hơn mục đích của sự kiện này.',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CrossBar(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gặp gỡ người tổ chức',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Card(
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: ImageCacheRender(
                                    path: widget.eventDetail['banner']
                                        ['preview_url'],
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Gặp gỡ người tổ chức',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  '14 sự kiện đã qua · 4.5K lượt thích',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const CrossBar(),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Vietnam Gender Equality Movement (VGEM) là chuỗi hoạt động thúc đẩy quyền bình đẳng giới tại Việt Nam.',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black.withOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 24,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                189, 202, 202, 202),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                width: 0.2, color: greyColor)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(FontAwesomeIcons.solidThumbsUp,
                                                color: Colors.black, size: 14),
                                            SizedBox(
                                              width: 7.0,
                                            ),
                                            Text(
                                              'Thích',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
