import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DateTimeCustom extends StatefulWidget {
  final Function handleGetDate;
  const DateTimeCustom({Key? key, required this.handleGetDate})
      : super(key: key);

  @override
  State<DateTimeCustom> createState() => _DateTimeCustomState();
}

class _DateTimeCustomState extends State<DateTimeCustom> {
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    void _showDialog(Widget child) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Container(
                height: 216,
                padding: const EdgeInsets.only(top: 6.0),
                // The Bottom margin is provided to align the popup above the system
                // navigation bar.
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                // Provide a background color for the popup.
                color: CupertinoColors.systemBackground.resolveFrom(context),
                // Use a SafeArea widget to avoid system overlaps.
                child: SafeArea(
                  top: false,
                  child: child,
                ),
              ));
    }

    return InkWell(
      onTap: () => _showDialog(CupertinoDatePicker(
        initialDateTime: date,
        mode: CupertinoDatePickerMode.date,
        use24hFormat: true,
        // This is called when the user changes the date.
        onDateTimeChanged: (DateTime newDate) {
          setState(() => date = newDate);
          //date type: 2020-02-13 00:00:00.000
          widget.handleGetDate(date);
        },
      )),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.calendar,
              size: 18,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              '${date.day}, tháng ${date.month}, ${date.year}',
              style:
                  const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
