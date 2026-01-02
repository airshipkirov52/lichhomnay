import 'package:flutter/material.dart';
import 'package:lich_hom_nay/calendar_utils.dart';

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

class AuspiciousDateSymbol extends StatelessWidget {
  final SolarLunarDate solarLunarDate;
  final double width;
  final double height;
  static Color auspiciousColor = Color.fromARGB(255, 20, 192, 60);
  static Color nonAuspiciousColor = Color.fromARGB(255, 120, 120, 120);

  const AuspiciousDateSymbol({
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
