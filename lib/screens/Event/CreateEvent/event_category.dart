import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/Event/CreateEvent/map_event_2.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class GetEventCategory extends StatefulWidget {
  final dynamic categorySelected;
  final Function(List<dynamic>) onCategorySelectedChanged;
  const GetEventCategory({
    super.key,
    this.categorySelected,
    required this.onCategorySelectedChanged,
  });

  @override
  GetEventCategoryState createState() => GetEventCategoryState();
}

class GetEventCategoryState extends State<GetEventCategory>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: secondaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Tìm kiếm hạng mục'),
                  // Tab(text: 'Trên mạng'),
                ],
                controller: _tabController,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MapEvent2(
                      categorySelected: widget.categorySelected,
                      onCategorySelectedChanged:
                          widget.onCategorySelectedChanged),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
