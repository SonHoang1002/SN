import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/DatePickerCustom/lib/paged_vertical_calendar.dart';
import 'package:social_network_app_mobile/widget/DatePickerCustom/lib/utils/date_utils.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

class DatePickerCustom extends StatefulWidget {
  final DateTime selectedDateTime;
  final Function(DateTime, bool) onDateTimeChanged;
  const DatePickerCustom({
    Key? key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
  }) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _DatePickerCustomState createState() => _DatePickerCustomState();
}

class _DatePickerCustomState extends State<DatePickerCustom> {
  late DateFormat _dateFormat;
  late DateTime _selectedDateTime;
  final bool _isDateTimeChanged = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi_VN');
    _dateFormat = DateFormat("'THÁNG' M 'NĂM' y", 'vi_VN');
    _selectedDateTime = widget.selectedDateTime;
  }

  void _handleDateTimeChanged(DateTime newDateTime) {
    widget.onDateTimeChanged(newDateTime, false);
    setState(() {
      _selectedDateTime = newDateTime;
    });
  }

  void _handleCancel() {
    widget.onDateTimeChanged(_selectedDateTime, false);
    Navigator.pop(context);
  }

  void _handleOK() {
    widget.onDateTimeChanged(_selectedDateTime, true);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.isDarkMode ? Colors.black : Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: _handleCancel,
                  child: const Text(
                    'Hủy',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  )),
              const AppBarTitle(
                title: 'Ngày và giờ',
              ),
              GestureDetector(
                  onTap: _handleOK,
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  )),
            ],
          )),
      body: SizedBox(
        height: 800,
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Ngày',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      'Giờ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PagedVerticalCalendar(
                startWeekWithSunday: false,
                addAutomaticKeepAlives: true,
                invisibleMonthsThreshold: 5,
                initialDate: _selectedDateTime.removeTime(),
                onDayPressed: (day) {
                  _handleDateTimeChanged(DateTime(
                    day.year,
                    day.month,
                    day.day,
                    _selectedDateTime.hour,
                    _selectedDateTime.minute,
                  ));
                },
                dayBuilder: (context, date) {
                  final isSelected = date.isSameDay(_selectedDateTime);
                  return Column(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.blue : null,
                          border: isSelected
                              ? const Border.fromBorderSide(BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ))
                              : null,
                        ),
                        padding: isSelected ? const EdgeInsets.all(4.0) : null,
                        child: Center(
                          child: Text(
                            DateFormat('d').format(date),
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                          ),
                        ), // Thêm khoảng cách cho border
                      ),
                    ],
                  );
                },

                /// customize the month header look by adding a week indicator
                monthBuilder: (context, month, year) {
                  return Column(
                    children: [
                      /// create a customized header displaying the month and year
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        margin: const EdgeInsets.all(20),
                        // decoration: const BoxDecoration(
                        //   color: secondaryColor,
                        //   borderRadius: BorderRadius.all(Radius.circular(50)),
                        // ),
                        child: Text(
                          _dateFormat.format(DateTime(year, month)),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: theme.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            weekText('T2'),
                            weekText('T3'),
                            weekText('T4'),
                            weekText('T5'),
                            weekText('T6'),
                            weekText('T7'),
                            weekText('CN'),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 200, // fixed height
              child: CupertinoDatePicker(
                use24hFormat: true,
                minuteInterval: 5,
                initialDateTime: _selectedDateTime,
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (DateTime dateTime) {
                  _handleDateTimeChanged(DateTime(
                    _selectedDateTime.year,
                    _selectedDateTime.month,
                    _selectedDateTime.day,
                    dateTime.hour,
                    dateTime.minute,
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget weekText(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      ),
    );
  }
}
