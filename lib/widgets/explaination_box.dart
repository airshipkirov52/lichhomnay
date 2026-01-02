import 'package:flutter/material.dart';
import 'package:lich_hom_nay/constants.dart';
import 'package:lich_hom_nay/widgets/auspicious_date_symbol.dart';
import 'package:lich_hom_nay/widgets/event_date_symbol.dart';

class ExplainationBox extends StatelessWidget {
  const ExplainationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6, right: 3, bottom: 6, left: 3),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: foregroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleSymbol(
                color: AuspiciousDateSymbol.auspiciousColor,
                width: 5,
                height: 5,
              ),
              Text("Ngày Hoàng Đạo", style: TextStyle(fontSize: 10)),
            ],
          ),
          Row(
            children: [
              CircleSymbol(
                color: AuspiciousDateSymbol.nonAuspiciousColor,
                width: 5,
                height: 5,
              ),
              Text("Ngày Hắc Đạo", style: TextStyle(fontSize: 10)),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 6),
                child: AsteriskSymbol(color: yangColor),
              ),
              Text("Ngày có sự kiện", style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
