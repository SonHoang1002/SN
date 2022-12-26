import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class WatchChipMenu extends StatefulWidget {
  final String menuSelected;
  final Function handleUpdate;
  const WatchChipMenu(
      {Key? key, required this.menuSelected, required this.handleUpdate})
      : super(key: key);

  @override
  State<WatchChipMenu> createState() => _WatchChipMenuState();
}

class _WatchChipMenuState extends State<WatchChipMenu> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
            watchMenu.length,
            (index) => GestureDetector(
                  onTap: () {
                    widget.handleUpdate(watchMenu[index]['key']);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: widget.menuSelected == watchMenu[index]['key']
                            ? primaryColor
                            : Theme.of(context).colorScheme.background),
                    child: Text(
                      watchMenu[index]['label'],
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: widget.menuSelected == watchMenu[index]['key']
                              ? Colors.white
                              : null),
                    ),
                  ),
                )),
      ),
    );
  }
}
