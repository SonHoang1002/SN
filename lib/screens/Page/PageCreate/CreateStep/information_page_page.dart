import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/providers/page/select_province_page_provider.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_button_chip.dart';
import 'package:social_network_app_mobile/widgets/create_update_render.dart';

import 'avatar_page_page.dart';

class InformationPagePage extends StatefulWidget {
  final dynamic dataCreate;
  const InformationPagePage({super.key, this.dataCreate});

  @override
  State<InformationPagePage> createState() => _InformationPagePageState();
}

class _InformationPagePageState extends State<InformationPagePage> {
  late double width = 0;
  late double height = 0;
  List<int> radioGroupWorkTime = [0, 1, 2];
  final _informationKey = GlobalKey<FormState>();

  int currentValue = 0;
  @override
  Widget build(BuildContext context) {
    List infoField = [
      {
        'type': 'title',
        'title': 'Hoàn tất thiết lập Trang của bạn',
        'description':
            'Thành công rồi! Bạn đã tạo trang thành công. Hãy bổ sung thông tin chi tiết để mọi người dễ dàng kết nối với bạn nhé.'
      },
      {
        'title': 'Chung',
        'iconTitle': Icons.info,
        'description': 'Mô tả về Trang của bạn',
        'placeholder': 'Tiểu sử'
      },
      {
        'title': 'Thông tin liên hệ',
        'iconTitle': Icons.card_giftcard,
        'description': null,
        'placeholder': 'Trang web'
      },
      {
        'title': null,
        'iconTitle': null,
        'description': null,
        'placeholder': 'Email'
      },
      {
        'title': null,
        'iconTitle': null,
        'description': null,
        'placeholder': 'Số điện thoại',
        'type': 'number'
      },
      {
        'title': 'Vị trí',
        'iconTitle': Icons.location_history,
        'description': null,
        'placeholder': 'Địa chỉ'
      },
      {
        'type': 'autocomplete',
        'listSelect': Provider.of<SelectProvinceProvider>(context).selectList,
        'title': 'Tỉnh/Thành phố/Thị xã/Thị trấn',
      },
      {
        'title': null,
        'iconTitle': null,
        'description': null,
        'placeholder': 'Mã ZIP',
        'type': 'number'
      },
      {
        'type': 'radio',
        'title': 'Giờ làm việc',
        'iconTitle': Icons.watch,
        'description': 'Thông báo về giờ làm việc tại vị trí của bạn.',
        'options': [
          {
            'title': 'Không có giờ làm việc',
            'description': 'Không hiển thị giờ làm việc.',
            'value': 0
          },
          {
            'title': 'Luôn mở cửa',
            'description': 'Bạn đang mở cửa 24 giờ mỗi ngày.',
            'value': 1
          },
          {
            'title': 'Giờ làm việc tiêu chuẩn',
            'description': 'Nhập khung giờ cụ thể',
            'value': 2
          },
        ],
        'radioGroup': [0, 1, 2],
        'action': (value) {
          if (mounted) {
            setState(() {
              currentValue = value;
            });
          }
        },
        'valueRadio': currentValue
      },
      {'type': 'blank'}
    ];
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pop()
                ..pop();
            },
            child: Icon(
              FontAwesomeIcons.chevronLeft,
              color: Theme.of(context).textTheme.displayLarge!.color,
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GestureDetector(
          onTap: (() {
            FocusManager.instance.primaryFocus!.unfocus();
          }),
          child: Stack(alignment: Alignment.bottomCenter, children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                child: CreateUpdateRender(infoField: infoField)),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.only(bottom: 20),
              child: buildBottomNavigatorWithButtonAndChipWidget(
                  context: context,
                  width: width,
                  newScreen: AvatarPage(dataCreate: widget.dataCreate),
                  isPassCondition: _informationKey.currentState == null
                      ? true
                      : _informationKey.currentState!.validate(),
                  title: "Tiếp",
                  currentPage: 3),
            )
          ]),
        ));
  }
}
