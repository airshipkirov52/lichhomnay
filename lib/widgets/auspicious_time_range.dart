import 'package:flutter/material.dart';
import 'package:lich_hom_nay/constants.dart';

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
