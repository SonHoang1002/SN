// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/widget/box-quick-update.dart';

import '../../../theme/theme_manager.dart';

class BoxQuickUpdatePage extends StatefulWidget {
  const BoxQuickUpdatePage({super.key});

  @override
  State<BoxQuickUpdatePage> createState() => _BoxQuickUpdatePageState();
}

class _BoxQuickUpdatePageState extends State<BoxQuickUpdatePage> {
  List listActionsQuickUpdate = [
    {
      'title': 'Thiết lập danh tính Trang',
      'action': null,
      'children': [
        {'title': 'Thêm ảnh đại diện', 'checked': false},
        {'title': 'Thêm mô tả', 'checked': true},
        {'title': 'Tạo tên Trang', 'checked': true},
        {'title': 'Chọn hạng mục', 'checked': true},
        {'title': 'Thêm ảnh bìa', 'checked': true},
      ]
    },
    {
      'title': 'Cung cấp thông tin tùy chọn',
      'action': null,
      'children': [
        {'title': 'Trang web của bạn', 'checked': true},
        {'title': 'Số điện thoại', 'checked': false}
      ]
    },
    {
      'title': 'Giới thiệu Trang',
      'action': null,
      'children': [
        {'title': 'Mời 10 người bạn trở lên', 'checked': true}
      ]
    }
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: BoxQuickUpdate(
        title: 'Thiết lập trang nhanh',
        description:
            'Hãy hoàn tất bước thiết lập Trang để mọi người trên EMSO biết doanh nghiệp của bạn đáng tin cậy.',
        valueLinearProgress: 0.7,
        listActions: listActionsQuickUpdate,
      ),
    );
  }
}
