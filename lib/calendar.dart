import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lich_hom_nay/calendar_notification.dart';
import 'package:lich_hom_nay/calendar_widget.dart';
import 'package:lich_hom_nay/calendar_utils.dart';
import 'package:lich_hom_nay/task_form.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CalendarState();
  }
}

class _CalendarState extends State<Calendar> {
  static const int initialPage = 1000;
  static const List<String> heading = [
    "T2",
    "T3",
    "T4",
    "T5",
    "T6",
    "T7",
    "CN",
  ];
  int _currentPage = initialPage;
  late List<SolarLunarDate> calendar;
  late SolarLunarDate selectedDate;

  late int month;
  late int year;
  late final PageController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    month = now.month;
    year = now.year;
    selectedDate = getSolarLunarDate(now);
    calendar = getCalendar(month, year);
    _controller = PageController(initialPage: initialPage);
    CalendarNotification.scheduleNotification(
      title: "Thông Báo",
      body: "Hello World",
      scheduledDate: DateTime.now().add(Duration(minutes: 60)),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void onMoveNowDate() {
    setState(() {
      final now = DateTime.now();
      month = now.month;
      year = now.year;
      calendar = getCalendar(month, year);
      selectedDate = getSolarLunarDate(now);
    });
  }

  void onPrevMonth() {
    setState(() {
      month--;
      if (month < 1) {
        month = 12;
        year--;
      }
      calendar = getCalendar(month, year);
    });
  }

  void onPrevYear() {
    setState(() {
      year--;
      year = max(1900, year);
      calendar = getCalendar(month, year);
    });
  }

  void onNextMonth() {
    setState(() {
      month++;
      if (month > 12) {
        month = 1;
        year++;
      }
      calendar = getCalendar(month, year);
    });
  }

  void onNextYear() {
    setState(() {
      year++;
      calendar = getCalendar(month, year);
    });
  }

  void onSwipMonth(int page) {
    if (page > _currentPage) {
      onNextMonth();
    } else if (page < _currentPage) {
      onPrevMonth();
    }
    _currentPage = page;
  }

  void onSelectDate(SolarLunarDate solarLunarDate) {
    setState(() {
      selectedDate = solarLunarDate;
    });
  }

  void onCreateEvent(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const TaskForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<List<SolarLunarDate>> rows = List.generate(6, (_) => []);
    for (var i = 0; i < 6; i++) {
      rows[i] = (calendar.sublist(i * 7, (i + 1) * 7));
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: backgoundColor,
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: foregroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: onPrevYear,
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      icon: Icon(Icons.keyboard_double_arrow_left),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: onMoveNowDate,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                        child: Text(
                          "Tháng $month - $year",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onNextYear,
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      icon: Icon(Icons.keyboard_double_arrow_right),
                    ),
                    IconButton(
                      onPressed: () => onCreateEvent(context),
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      icon: Icon(Icons.assignment_add),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  for (final item in heading)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(2),
                        child: Text(
                          item,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 330,
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: onSwipMonth,
                  itemBuilder: (context, index) => Column(
                    children: [
                      ...rows.map(
                        (row) => Row(
                          children: [
                            for (final item in row)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => onSelectDate(item),
                                  child: CalendarDateCell(
                                    currentMonth: month,
                                    selectedDate: selectedDate,
                                    solarLunarDate: item,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SolarLunarDateDetail(solarLunarDate: selectedDate),
              AuspiciousTimeRange(
                auspiciousTimes: selectedDate.lunarDate.auspiciousTimes,
              ),
              Container(
                margin: EdgeInsets.only(top: 6, right: 3, bottom: 6, left: 3),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: foregroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
