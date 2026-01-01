import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lich_hom_nay/calendar_utils.dart';
import 'package:lich_hom_nay/constants.dart';

const backgoundColor = Color.fromARGB(255, 255, 255, 255);
const foregroundColor = Color.fromARGB(255, 230, 240, 230);
const selectedDateColor = Color.fromARGB(255, 250, 238, 0);
const nonOfMonthColor = Color.fromARGB(255, 179, 179, 179);
const yinColor = Color.fromARGB(255, 20, 20, 230);
const yangColor = Color.fromARGB(255, 230, 0, 0);

class AsteriskSymbol extends StatelessWidget {
  final Color color;
  const AsteriskSymbol({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.rotate(
          angle: 0,
          child: Container(
            width: 7,
            height: 1,
            decoration: BoxDecoration(color: color),
          ),
        ),
        Transform.rotate(
          angle: pi / 4,
          child: Container(
            width: 7,
            height: 1,
            decoration: BoxDecoration(color: color),
          ),
        ),
        Transform.rotate(
          angle: pi / 2,
          child: Container(
            width: 7,
            height: 1,
            decoration: BoxDecoration(color: color),
          ),
        ),
        Transform.rotate(
          angle: -pi / 4,
          child: Container(
            width: 7,
            height: 1,
            decoration: BoxDecoration(color: color),
          ),
        ),
      ],
    );
  }
}

class CircleSymbol extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  const CircleSymbol({
    required this.width,
    required this.height,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class EventDateIcon extends StatelessWidget {
  final bool isOfMonth;
  final bool isLunarLeapMonth;
  final Future<DateEvent?> solarDateEvent;
  final Future<DateEvent?> lunarDateEvent;

  const EventDateIcon({
    required this.isOfMonth,
    required this.isLunarLeapMonth,
    required this.solarDateEvent,
    required this.lunarDateEvent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DateEvent?>>(
      future: Future.wait([solarDateEvent, lunarDateEvent]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final hasEvent = snapshot.data!.any((e) => e != null && e.asterisk);
        if (!hasEvent || isLunarLeapMonth) {
          return const SizedBox.shrink();
        }

        return AsteriskSymbol(color: isOfMonth ? yangColor : nonOfMonthColor);
      },
    );
  }
}

class AuspiciousDayIcon extends StatelessWidget {
  final SolarLunarDate solarLunarDate;
  final double width;
  final double height;
  static Color auspiciousColor = Color.fromARGB(255, 20, 192, 60);
  static Color nonAuspiciousColor = Color.fromARGB(255, 120, 120, 120);

  const AuspiciousDayIcon({
    required this.solarLunarDate,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleSymbol(
      width: width,
      height: height,
      color: solarLunarDate.lunarDate.isAuspicious
          ? auspiciousColor
          : nonAuspiciousColor,
    );
  }
}

class SolarDateText extends StatelessWidget {
  final DateTime dateTime;
  final TextStyle? style;
  const SolarDateText({required this.dateTime, this.style, super.key});

  @override
  Widget build(BuildContext context) =>
      Text(dateTime.day.toString(), style: style);
}

class LunarDateText extends StatelessWidget {
  final LunarDate lunarDate;
  final TextStyle? style;
  const LunarDateText({required this.lunarDate, this.style, super.key});

  @override
  Widget build(BuildContext context) {
    final isFirstDay = lunarDate.ldd == 1;
    final text = StringBuffer()
      ..write(lunarDate.ldd)
      ..write(isFirstDay ? "/${lunarDate.lmm.toString()}" : "")
      ..write(isFirstDay && lunarDate.leap == 1 ? "N" : "");
    return Text(text.toString(), style: style);
  }
}

class CalendarDateCell extends StatelessWidget {
  final int currentMonth;
  final SolarLunarDate solarLunarDate;
  final SolarLunarDate selectedDate;

  const CalendarDateCell({
    required this.currentMonth,
    required this.solarLunarDate,
    required this.selectedDate,
    super.key,
  });

  Color buildCellColor() {
    if (selectedDate.solarDate.day == solarLunarDate.solarDate.day &&
        selectedDate.solarDate.month == solarLunarDate.solarDate.month &&
        selectedDate.solarDate.year == solarLunarDate.solarDate.year) {
      return selectedDateColor;
    }
    return foregroundColor;
  }

  TextStyle buildTextStyle() {
    Color color = Colors.black;
    if (solarLunarDate.solarDate.weekday == 6) {
      color = yinColor;
    }
    if (solarLunarDate.solarDate.weekday == 7) {
      color = yangColor;
    }
    if (solarLunarDate.solarDate.month != currentMonth) {
      color = nonOfMonthColor;
    }
    return TextStyle(color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: buildCellColor(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Column(
            children: [
              SolarDateText(
                dateTime: solarLunarDate.solarDate,
                style: buildTextStyle().copyWith(fontSize: 16),
              ),
              LunarDateText(
                lunarDate: solarLunarDate.lunarDate,
                style: buildTextStyle().copyWith(fontSize: 12),
              ),
            ],
          ),
          Positioned(
            top: 3,
            left: 3,
            child: AuspiciousDayIcon(
              solarLunarDate: solarLunarDate,
              width: 6,
              height: 6,
            ),
          ),
          Positioned(
            top: 3,
            right: 1,
            child: EventDateIcon(
              solarDateEvent: solarLunarDate.solarDateEvent,
              lunarDateEvent: solarLunarDate.lunarDateEvent,
              isOfMonth: solarLunarDate.solarDate.month == currentMonth,
              isLunarLeapMonth: solarLunarDate.lunarDate.leap == 1,
            ),
          ),
        ],
      ),
    );
  }
}

class EventText extends StatelessWidget {
  final bool? isLunarLeapMonth;
  final Future<DateEvent?> dateEvent;

  const EventText({this.isLunarLeapMonth, required this.dateEvent, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DateEvent?>(
      future: dateEvent,
      builder: (context, snapshot) {
        if (!snapshot.hasData || (isLunarLeapMonth != null && isLunarLeapMonth == true)) {
          return const SizedBox(height: 0);
        }
        return Container(
          margin: EdgeInsets.only(top: 3),
          child: Text(
            snapshot.data!.events[0].name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              color: Color.fromARGB(255, 230, 0, 0),
            ),
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
          margin: EdgeInsets.only(top: 3),
          child: Column(
            children: [
              Text(
                snapshot.data!.content,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
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

class SolarLunarDateDetail extends StatelessWidget {
  final SolarLunarDate solarLunarDate;

  const SolarLunarDateDetail({required this.solarLunarDate, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6, right: 2, bottom: 6, left: 3),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: foregroundColor,
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
                          "${solarLunarDate.dayOfWeekLocalize.vi}, ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 230, 0, 0),
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${solarLunarDate.solarDate.day.toString()} Th ${solarLunarDate.solarDate.month}, ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 230, 0, 0),
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          solarLunarDate.solarDate.year.toString(),
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
                          "${solarLunarDate.lunarDate.ldd} ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 230),
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Th ${solarLunarDate.lunarDate.lmm}, ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 230),
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Năm ${solarLunarDate.lunarDate.yearHeavenlyStem.vi} ${solarLunarDate.lunarDate.yearEarthlyBranch.vi}",
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
                        AuspiciousDayIcon(
                          solarLunarDate: solarLunarDate,
                          width: 8,
                          height: 8,
                        ),
                        solarLunarDate.lunarDate.isAuspicious
                            ? Text(
                                "Ngày Hoàng Đạo",
                                style: TextStyle(
                                  color: AuspiciousDayIcon.auspiciousColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              )
                            : Text(
                                "Ngày Hắc Đạo",
                                style: TextStyle(
                                  color: AuspiciousDayIcon.nonAuspiciousColor,
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
                        "Giờ ${solarLunarDate.lunarDate.tyHourStem.vi} Tý",
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
                        "Ngày ${solarLunarDate.lunarDate.dayHeavenlyStem.vi} ${solarLunarDate.lunarDate.dayEarthlyBranch.vi} ",
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
                        "Tháng ${solarLunarDate.lunarDate.monthHeavenlyStem.vi} ${solarLunarDate.lunarDate.monthEarthlyBranch.vi}",
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
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Column(
              children: [
                EventText(dateEvent: solarLunarDate.solarDateEvent),
                EventText(
                  dateEvent: solarLunarDate.lunarDateEvent,
                  isLunarLeapMonth: solarLunarDate.lunarDate.leap == 1,
                ),
                QuotationText(quotation: solarLunarDate.quotation),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuspiciousTimeRange extends StatelessWidget {
  final List<LunarTimes> auspiciousTimes;

  const AuspiciousTimeRange({required this.auspiciousTimes, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6, right: 2, bottom: 6, left: 3),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: foregroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            "Giờ hoàng đạo",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final item in auspiciousTimes)
                Container(
                  padding: EdgeInsets.all(3),
                  child: Column(
                    children: [
                      Image.asset(
                        item.earthlyBranch.img,
                        width: 32,
                        height: 32,
                      ),
                      Text(
                        item.earthlyBranch.vi,
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
    );
  }
}
