import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lich_hom_nay/calendar_utils.dart';
import 'package:lich_hom_nay/request_events.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CalendarState();
  }
}

class EventText extends StatelessWidget {
  final Future<DateEvent?> dateEvent;

  const EventText({required this.dateEvent, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DateEvent?>(
      future: dateEvent,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 0);
        }
        return Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              Text(
                snapshot.data!.events[0].name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: Color.fromARGB(255, 230, 0, 0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class QuotationText extends StatelessWidget {
  final Future<Quotation> quotation;

  const QuotationText({required this.quotation, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quotation>(
      future: quotation,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 16);
        }
        return Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Text(
                snapshot.data!.content,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10,),
              ),
              Text(
                snapshot.data!.author,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CalendarState extends State<Calendar> {
  final List<String> heading = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];
  late SolarLunarDate selectedDate;
  late List<SolarLunarDate> calendar;
  late int month;
  late int year;
  final backgound = Color.fromARGB(255, 255, 255, 255);
  final foreground = Color.fromARGB(255, 230, 230, 230);
  final auspiciousColor = Color.fromARGB(255, 20, 192, 60);
  final nonAuspiciousColor = Color.fromARGB(255, 120, 120, 120);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    month = now.month;
    year = now.year;
    selectedDate = getSolarLunarDate(now);
    calendar = getCalendar(month, year);
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

  void onSelectDate(SolarLunarDate solarLunarDate) {
    setState(() {
      selectedDate = solarLunarDate;
    });
  }

  Color buildBackgroundCell(SolarLunarDate cell) {
    if (selectedDate.solarDate.day == cell.solarDate.day &&
        selectedDate.solarDate.month == cell.solarDate.month &&
        selectedDate.solarDate.year == cell.solarDate.year) {
      return const Color.fromARGB(255, 250, 238, 0);
    }
    return foreground;
  }

  TextStyle buildForegroundCell(SolarLunarDate cell) {
    Color color = Colors.black;
    if (cell.solarDate.weekday == 6) {
      color = const Color.fromARGB(255, 20, 20, 230);
    }
    if (cell.solarDate.weekday == 7) {
      color = const Color.fromARGB(255, 230, 0, 0);
    }
    if (cell.solarDate.month != month) {
      color = const Color.fromARGB(255, 179, 179, 179);
    }
    return TextStyle(fontWeight: FontWeight.bold, color: color);
  }

  Widget buildAuspiciousDay(SolarLunarDate cell) {
    if (cell.solarDate.month != month) {
      return const SizedBox.shrink();
    }
    return Positioned(
      top: 3,
      left: 2,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: cell.lunarDate.isAuspicious
              ? auspiciousColor
              : nonAuspiciousColor,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Text buildTextSolarDate(SolarLunarDate solarLunarDate) {
    TextStyle style = buildForegroundCell(
      solarLunarDate,
    ).copyWith(fontSize: 16);
    return Text(solarLunarDate.solarDate.day.toString(), style: style);
  }

  Text buildTextLunarDate(SolarLunarDate solarLunarDate) {
    TextStyle style = buildForegroundCell(
      solarLunarDate,
    ).copyWith(fontSize: 12);
    LunarDate lunarDate = solarLunarDate.lunarDate;
    String ldd = lunarDate.ldd.toString();
    String lmm = lunarDate.ldd == 1 ? "/${lunarDate.lmm.toString()}" : "";
    String leap = lunarDate.ldd == 1 && lunarDate.leap == 1 ? "(N)" : "";
    return Text("$ldd$lmm$leap", style: style);
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
          color: backgound,
          margin: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: foreground,
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
                    IconButton(
                      onPressed: onPrevMonth,
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      icon: Icon(Icons.keyboard_arrow_left),
                    ),
                    TextButton(
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
                    IconButton(
                      onPressed: onNextMonth,
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      icon: Icon(Icons.keyboard_arrow_right),
                    ),
                    IconButton(
                      onPressed: onNextYear,
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      icon: Icon(Icons.keyboard_double_arrow_right),
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
              ...rows.map(
                (row) => Row(
                  children: [
                    for (final item in row)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onSelectDate(item),
                          child: Container(
                            margin: EdgeInsets.all(3),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: buildBackgroundCell(item),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: SizedBox(
                              child: Stack(
                                alignment: AlignmentGeometry.center,
                                children: [
                                  Column(
                                    children: [
                                      buildTextSolarDate(item),
                                      buildTextLunarDate(item),
                                    ],
                                  ),
                                  buildAuspiciousDay(item),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6, right: 2, bottom: 6, left: 3),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: foreground,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 6,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${selectedDate.dayOfWeekLocalize.vi}, ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 230, 0, 0),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "${selectedDate.solarDate.day.toString()} Th ${selectedDate.solarDate.month}, ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 230, 0, 0),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    selectedDate.solarDate.year.toString(),
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 230, 0, 0),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${selectedDate.lunarDate.ldd} ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 230),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "Th ${selectedDate.lunarDate.lmm}, ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 230),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "Năm ${selectedDate.lunarDate.yearHeavenlyStem.vi} ${selectedDate.lunarDate.yearEarthlyBranch.vi}",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 230),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: selectedDate.lunarDate.isAuspicious
                                          ? auspiciousColor
                                          : nonAuspiciousColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  selectedDate.lunarDate.isAuspicious
                                      ? Text(
                                          "Ngày Hoàng Đạo",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              230,
                                              0,
                                              0,
                                            ),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                          ),
                                        )
                                      : Text(
                                          "Ngày Hắc Đạo",
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: AlignmentGeometry.topLeft,
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  "Giờ ${selectedDate.lunarDate.tyHourStem.vi} Tý",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: AlignmentGeometry.topLeft,
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  "Ngày ${selectedDate.lunarDate.dayHeavenlyStem.vi} ${selectedDate.lunarDate.dayEarthlyBranch.vi} ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: AlignmentGeometry.topLeft,
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  "Tháng ${selectedDate.lunarDate.monthHeavenlyStem.vi} ${selectedDate.lunarDate.monthEarthlyBranch.vi}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        EventText(dateEvent: selectedDate.solarDateEvent),
                        EventText(dateEvent: selectedDate.lunarDateEvent),
                        QuotationText(quotation: selectedDate.quotation),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6, right: 2, bottom: 6, left: 3),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: foreground,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Text(
                      "Giờ hoàng đạo",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final item
                            in selectedDate.lunarDate.auspiciousTimes)
                          Container(
                            margin: EdgeInsets.all(3),
                            child: Column(
                              children: [
                                Text(
                                  item.earthlyBranch,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  item.timeRange,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
