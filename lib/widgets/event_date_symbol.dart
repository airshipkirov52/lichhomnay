import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lich_hom_nay/calendar_utils.dart';
import 'package:lich_hom_nay/constants.dart';

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

class EventDateSymbol extends StatelessWidget {
  final bool isOfMonth;
  final bool isLunarLeapMonth;
  final Future<DateEvent?> solarDateEvent;
  final Future<DateEvent?> lunarDateEvent;

  const EventDateSymbol({
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