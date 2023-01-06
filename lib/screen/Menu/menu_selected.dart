import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Page/page_general.dart';

class MenuSelected extends StatelessWidget {
  final dynamic menuSelected;
  final dynamic data;
  const MenuSelected({
    Key? key,
    this.menuSelected,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(menuSelected);
    return renderWidget(menuSelected, data);
  }

  renderWidget(menuSelected, data) {
    switch (menuSelected['key']) {
      case 'pageSocial':
        return PageGeneral(
          data: 'data',
        );
      default:
        return const SizedBox();
    }
  }
}
