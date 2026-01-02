import 'package:flutter/material.dart';
import 'package:lich_hom_nay/calendar_utils.dart';
import 'package:lich_hom_nay/constants.dart';
import 'package:lich_hom_nay/widgets/auspicious_date_symbol.dart';
import 'package:lich_hom_nay/widgets/event_date_symbol.dart';

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
            child: AuspiciousDateSymbol(
              solarLunarDate: solarLunarDate,
              width: 6,
              height: 6,
            ),
          ),
          Positioned(
            top: 3,
            right: 1,
            child: EventDateSymbol(
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
