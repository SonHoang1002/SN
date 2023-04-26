import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class TabSocial extends StatefulWidget {
  final List? tabHeader;
  final List<Widget> childTab;
  final Widget? searchWidget;
  final Function? handleTabChange;
  final List<Widget>? tabCustom;

  const TabSocial(
      {Key? key,
      this.tabHeader,
      required this.childTab,
      this.searchWidget,
      this.handleTabChange,
      this.tabCustom})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TabSocialState createState() => _TabSocialState();
}

class _TabSocialState extends State<TabSocial> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    if (!mounted) return;

    super.initState();
    _tabController = TabController(
        length: (widget.tabHeader ?? widget.tabCustom)!.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.2, color: greyColor))),
        child: TabBar(
          isScrollable: true,
          controller: _tabController,
          onTap: (index) {
            widget.handleTabChange!(index);
          },
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.displayLarge!.color,
          tabs: widget.tabCustom ??
              List.generate(
                  widget.tabHeader!.length,
                  (index) => Tab(
                        icon: widget.tabHeader![index]['icon'] ??
                            const Icon(Icons.abc),
                        text: widget.tabHeader![index],
                      )),
        ),
      ),
      widget.searchWidget ?? const SizedBox(),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: widget.childTab,
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}
