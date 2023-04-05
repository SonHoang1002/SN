import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/DatePickerCustom/lib/paged_vertical_calendar.dart';
import 'package:social_network_app_mobile/widget/DatePickerCustom/lib/utils/date_utils.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

class DatePickerCustom extends StatefulWidget {
  final DateTime selectedDateTime;
  final DateTime? selectedEndDate;
  final bool? isEndDate;
  final Function(DateTime, DateTime?, bool) onDateTimeChanged;
  const DatePickerCustom({
    Key? key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
    this.selectedEndDate,
    this.isEndDate,
  }) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _DatePickerCustomState createState() => _DatePickerCustomState();
}

class _DatePickerCustomState extends State<DatePickerCustom> {
  late DateFormat _dateFormat;
  late DateTime _selectedDateTime;
  late DateTime _selectedEndDate;
  bool isEndDate = false;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi_VN');
    _dateFormat = DateFormat("'THÁNG' M 'NĂM' y", 'vi_VN');
    _selectedDateTime = widget.selectedDateTime;
    _selectedEndDate = widget.selectedEndDate!;
    isEndDate = widget.isEndDate!;
  }

  void _handleDateTimeChanged(DateTime startDate, DateTime? endDate) {
    if (isEndDate && endDate != null) {
      widget.onDateTimeChanged(_selectedDateTime, endDate, false);
      setState(() {
        _selectedEndDate = endDate;
      });
    } else {
      widget.onDateTimeChanged(startDate, null, false);
      setState(() {
        _selectedDateTime = startDate;
      });
    }
    // if (isEndDate && endDate!.removeTime().isSameDay(startDate.removeTime())) {
    //   setState(() {
    //     _selectedEndDate = DateTime(
    //       endDate.year,
    //       endDate.month,
    //       endDate.day,
    //       _selectedDateTime.hour + 3,
    //       0,
    //     );
    //   });
    // }
    // if (isEndDate &&
    //     endDate!.removeTime().isSameDay(startDate.removeTime()) &&
    //     DateFormat('HH').format(_selectedDateTime) == '23') {
    //   setState(() {
    //     _selectedEndDate = DateTime(
    //       endDate.year,
    //       endDate.month,
    //       endDate.day,
    //       _selectedDateTime.hour,
    //       _selectedDateTime.minute + 55,
    //     );
    //   });
    // }
  }

  void _handleCancel() {
    if (isEndDate) {
      widget.onDateTimeChanged(_selectedDateTime, _selectedEndDate, false);
    } else {
      widget.onDateTimeChanged(_selectedDateTime, null, false);
    }
    Navigator.pop(context);
  }

  void _handleOK() {
    if (isEndDate) {
      widget.onDateTimeChanged(_selectedDateTime, _selectedEndDate, true);
    } else {
      widget.onDateTimeChanged(_selectedDateTime, null, true);
    }
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
            SizedBox(
              height: 70,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDateTime.removeTime() ==
                                    DateTime.now().removeTime()
                                ? 'Hôm nay lúc ${DateFormat('HH : mm', 'vi_VN').format(_selectedDateTime)}'
                                : '${DateFormat('EEEE', 'vi_VN').format(_selectedDateTime)} lúc ${DateFormat('HH : mm', 'vi_VN').format(_selectedDateTime)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: !isEndDate ? Colors.blue : Colors.grey,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          !isEndDate
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isEndDate = true;
                                    });
                                  },
                                  child: Row(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 2.0),
                                        child: Icon(
                                          FontAwesomeIcons.plus,
                                          size: 12,
                                          color: greyColor,
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        'Thời gian kết thúc',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  isEndDate
                      ? Padding(
                          padding:
                              const EdgeInsets.only(right: 16.0, left: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedEndDate.removeTime() ==
                                        DateTime.now().removeTime()
                                    ? 'Kết thúc hôm nay lúc ${DateFormat('HH : mm', 'vi_VN').format(_selectedEndDate)}'
                                    : 'Kết thúc ${DateFormat('EEEE', 'vi_VN').format(_selectedEndDate)} lúc ${DateFormat('HH : mm', 'vi_VN').format(_selectedEndDate)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedEndDate = DateTime(
                                        _selectedDateTime.year,
                                        _selectedDateTime.month,
                                        _selectedDateTime.day,
                                        _selectedDateTime.hour + 3,
                                        0);
                                    isEndDate = false;
                                  });
                                },
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 2.0),
                                      child: Icon(
                                        FontAwesomeIcons.xmark,
                                        size: 20,
                                        color: greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: PagedVerticalCalendar(
                startWeekWithSunday: false,
                minDate: DateTime.now().subtract(const Duration(days: 365)),
                maxDate: DateTime.now().add(const Duration(days: 365)),
                addAutomaticKeepAlives: true,
                invisibleMonthsThreshold: 5,
                initialDate: _selectedDateTime.removeTime(),
                onDayPressed: (day) {
                  if (!isEndDate) {
                    if (day
                        .removeTime()
                        .isBefore(DateTime.now().removeTime())) {
                      return;
                    }
                  }
                  if (isEndDate) {
                    if (day
                        .removeTime()
                        .isBefore(_selectedDateTime.removeTime())) {
                      return;
                    }
                  }
                  if (!isEndDate) {
                    _handleDateTimeChanged(
                        DateTime(
                          day.year,
                          day.month,
                          day.day,
                          _selectedDateTime.hour,
                          _selectedDateTime.minute,
                        ),
                        null);
                  } else {
                    _handleDateTimeChanged(
                      _selectedDateTime,
                      DateTime(
                        day.year,
                        day.month,
                        day.day,
                        _selectedEndDate.hour,
                        _selectedEndDate.minute,
                      ),
                    );
                  }
                },
                dayBuilder: (context, date) {
                  final isSelected = date.isSameDay(_selectedDateTime);

                  final isSelectedEndDate =
                      isEndDate && date.isSameDay(_selectedEndDate);

                  bool isInRange(DateTime date) {
                    if (_selectedDateTime == null) return false;
                    if (isEndDate) {
                      if (_selectedEndDate == null) {
                        return date == _selectedDateTime;
                      }
                    }
                    return ((date == _selectedDateTime ||
                            date.isSameDayOrAfter(_selectedDateTime)) &&
                        (date == _selectedEndDate ||
                            date.isSameDayOrBefore(_selectedEndDate)));
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 3, bottom: 3),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 2,
                                        bottom: 2,
                                        left: isSelected ? 4 : 0,
                                        right: isEndDate && isSelectedEndDate
                                            ? 4
                                            : 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (isEndDate)
                                            ? isInRange(date)
                                                ? secondaryColor
                                                    .withOpacity(0.4)
                                                : Colors.transparent
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: isSelected
                                              ? const Radius.circular(24.0)
                                              : const Radius.circular(0.0),
                                          topLeft: isSelected
                                              ? const Radius.circular(24.0)
                                              : const Radius.circular(0.0),
                                          topRight:
                                              isEndDate && isSelectedEndDate
                                                  ? const Radius.circular(24.0)
                                                  : const Radius.circular(0.0),
                                          bottomRight:
                                              isEndDate && isSelectedEndDate
                                                  ? const Radius.circular(24.0)
                                                  : const Radius.circular(0.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 9,
                                right: 0,
                                left: 0,
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color: isSelected ||
                                              isEndDate && isSelectedEndDate
                                          ? secondaryColor
                                          : Colors.transparent,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      DateFormat('d').format(date),
                                      style: TextStyle(
                                          fontWeight: isSelected ||
                                                  isEndDate && isSelectedEndDate
                                              ? FontWeight.bold
                                              : null,
                                          color: isSelected ||
                                                  isEndDate && isSelectedEndDate
                                              ? Colors.white
                                              : date.removeTime().isBefore(
                                                      DateTime.now()
                                                          .removeTime())
                                                  ? Colors.grey
                                                  : null),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                monthBuilder: (context, month, year) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        margin: const EdgeInsets.only(bottom: 20),
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
              child: CustomCupertinoDatePicker(
                key: ValueKey(!isEndDate ? 'start' : 'end'),
                initialDateTime:
                    !isEndDate ? _selectedDateTime : _selectedEndDate,
                use24hFormat: true,
                minuteInterval: 5,
                minimumDate: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  DateTime.now().hour + 1,
                  0,
                ),
                isEndDate: isEndDate,
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (DateTime dateTime) {
                  EasyDebounce.debounce(
                      'my-debouncer', const Duration(milliseconds: 500), () {
                    if (!isEndDate) {
                      _handleDateTimeChanged(
                          DateTime(
                            _selectedDateTime.year,
                            _selectedDateTime.month,
                            _selectedDateTime.day,
                            dateTime.hour,
                            dateTime.minute,
                          ),
                          null);
                    } else {
                      _handleDateTimeChanged(
                        _selectedDateTime,
                        DateTime(
                          _selectedEndDate.year,
                          _selectedEndDate.month,
                          _selectedEndDate.day,
                          dateTime.hour,
                          dateTime.minute,
                        ),
                      );
                    }
                  });
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
      padding: const EdgeInsets.all(2.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}

class CustomCupertinoDatePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final DateTime minimumDate;
  final bool use24hFormat;
  final int minuteInterval;
  final bool isEndDate;
  final CupertinoDatePickerMode mode;
  final ValueChanged<DateTime> onDateTimeChanged;

  const CustomCupertinoDatePicker({
    super.key,
    required this.initialDateTime,
    required this.use24hFormat,
    required this.minimumDate,
    required this.minuteInterval,
    required this.mode,
    required this.isEndDate,
    required this.onDateTimeChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomCupertinoDatePickerState createState() =>
      _CustomCupertinoDatePickerState();
}

class _CustomCupertinoDatePickerState extends State<CustomCupertinoDatePicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // fixed height
      child: CupertinoDatePicker(
        key: UniqueKey(),
        use24hFormat: widget.use24hFormat,
        minuteInterval: widget.minuteInterval,
        initialDateTime: widget.initialDateTime,
        minimumDate: widget.minimumDate,
        mode: widget.mode,
        onDateTimeChanged: (DateTime dateTime) {
          widget.onDateTimeChanged(dateTime);
        },
      ),
    );
  }
}
