import 'package:flutter/material.dart';
import 'package:lich_hom_nay/calendar_utils.dart';
import 'package:lich_hom_nay/constants.dart';
import 'package:lich_hom_nay/widgets/auspicious_date_symbol.dart';

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
                        AuspiciousDateSymbol(
                          solarLunarDate: solarLunarDate,
                          width: 8,
                          height: 8,
                        ),
                        solarLunarDate.lunarDate.isAuspicious
                            ? Text(
                                "Ngày Hoàng Đạo",
                                style: TextStyle(
                                  color: AuspiciousDateSymbol.auspiciousColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              )
                            : Text(
                                "Ngày Hắc Đạo",
                                style: TextStyle(
                                  color: AuspiciousDateSymbol.nonAuspiciousColor,
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
