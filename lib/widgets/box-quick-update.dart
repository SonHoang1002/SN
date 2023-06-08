import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/theme/theme_manager.dart';

class BoxQuickUpdate extends StatelessWidget {
  final String? title;
  final String? description;
  final int? totalProgress;
  final double? valueLinearProgress;
  final Color? startColorGradiend;
  final Color? endColorGradiend;
  final List listActions;

  const BoxQuickUpdate(
      {super.key,
      this.title,
      this.description,
      this.totalProgress,
      this.valueLinearProgress,
      this.startColorGradiend,
      this.endColorGradiend,
      required this.listActions});

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: theme.isDarkMode ? Theme.of(context).cardColor : Colors.white),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 3),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    title!,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              if (description != null)
                Text(
                  description!,
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodySmall?.color),
                ),
            ],
          ),
          if (valueLinearProgress != null)
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.transparent),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: valueLinearProgress,
                ),
              ),
            ),
          if (listActions.isNotEmpty)
            Column(
              children: List.generate(
                  listActions.length,
                  (index) => ButtonOptions(
                      title: listActions[index]['title'],
                      action: listActions[index]['action'],
                      children: listActions[index]['children'],
                      borderBottom: index != listActions.length - 1)

                  // InkWell(
                  //       onTap: () {
                  //         if (listActions[index]['action'] != null) {
                  //           listActions[index]['action']();
                  //         }
                  //       },
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 0, vertical: 16),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(listActions[index]['title']),
                  //             const Icon(
                  //               FontAwesomeIcons.angleDown,
                  //               size: 18,
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     )
                  ),
            )
        ],
      ),
    );
  }
}

class ButtonOptions extends StatefulWidget {
  final Function? action;
  final String title;
  final List? children;
  final bool borderBottom;
  const ButtonOptions(
      {super.key,
      this.action,
      required this.title,
      this.children,
      required this.borderBottom});

  @override
  State<ButtonOptions> createState() => _ButtonOptionsState();
}

class _ButtonOptionsState extends State<ButtonOptions> {
  bool openOptions = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (widget.children!.isNotEmpty) {
              setState(() {
                openOptions = !openOptions;
              });
            } else if (widget.action != null) {
              widget.action!();
            }
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: widget.borderBottom == true
                        ? BorderSide(
                            width: 1, color: Theme.of(context).dividerColor)
                        : BorderSide.none)),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Icon(
                  FontAwesomeIcons.angleDown,
                  size: 18,
                )
              ],
            ),
          ),
        ),
        if (openOptions == true)
          Column(
            children: List.generate(
                widget.children!.length,
                (index) => InkWell(
                      onTap: () {
                        if (widget.children![index]['action'] != null &&
                            widget.children![index]['checked'] != true) {
                          widget.children![index]['action']();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).dividerColor))),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.children![index]['title']),
                            widget.children![index]['checked'] == true
                                ? const Icon(
                                    FontAwesomeIcons.circleCheck,
                                    color: Colors.green,
                                  )
                                : const SizedBox(
                                    height: 22,
                                  )
                          ],
                        ),
                      ),
                    )),
          )
      ],
    );
  }
}
