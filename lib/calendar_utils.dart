import 'package:lich_hom_nay/constants.dart';
import 'package:lich_hom_nay/lunar_utils.dart';
import 'package:lich_hom_nay/request_events.dart';

class LunarDate {
  final int ldd;
  final int lmm;
  final int lyy;
  final int leap;
  final double timeZone;

  LunarDate(this.ldd, this.lmm, this.lyy, this.leap, this.timeZone);

  List<int> get convertedSolarDate =>
      LunarUtils.convertLunar2Solar(ldd, lmm, lyy, leap, timeZone);

  int get jdn => LunarUtils.jdnFromDate(
    convertedSolarDate[0],
    convertedSolarDate[1],
    convertedSolarDate[2],
  );

  bool get isAuspicious {
    int index = (jdn + 5) % 12;
    return auspiciousDateMatrix[lmm - 1].contains(index);
  }

  List<LunarTimes> get auspiciousTimes {
    int index = (jdn + 5) % 12;
    List<LunarTimes> auspiciousTimes = [];
    for (var i in auspiciousTimeMatrix[index]) {
      auspiciousTimes.add(LunarTimes.values[i]);
    }
    return auspiciousTimes;
  }

  HeavenlyStem get tyHourStem {
    final int dayStemIndex = dayHeavenlyStem.index;
    final int index = (dayStemIndex * 2) % 10;
    return HeavenlyStem.values[index];
  }

  HeavenlyStem get dayHeavenlyStem {
    int value = (jdn + 9) % 10;
    return HeavenlyStem.values[value];
  }

  EarthlyBranch get dayEarthlyBranch {
    int value = (jdn + 1) % 12;
    return EarthlyBranch.values[value];
  }

  HeavenlyStem get monthHeavenlyStem {
    final int yearStemIndex = (lyy + 6) % 10;
    final int value = (yearStemIndex * 2 + lmm + 1) % 10;
    return HeavenlyStem.values[value];
  }

  EarthlyBranch get monthEarthlyBranch {
    final int value = (lmm + 1) % 12;
    return EarthlyBranch.values[value];
  }

  HeavenlyStem get yearHeavenlyStem {
    final int index = (lyy + 6) % 10;
    return HeavenlyStem.values[index];
  }

  EarthlyBranch get yearEarthlyBranch {
    final int index = (lyy + 8) % 12;
    return EarthlyBranch.values[index];
  }

  LunarMonthLocalize get lunarMonthLocalize {
    final int index = lmm - 1;
    return LunarMonthLocalize.values[index];
  }
}

class SolarLunarDate {
  final DateTime solarDate;
  final LunarDate lunarDate;

  SolarLunarDate(this.solarDate, this.lunarDate);

  int get jdn =>
      LunarUtils.jdnFromDate(solarDate.day, solarDate.month, solarDate.year);

  DayOfWeekLocalize get dayOfWeekLocalize {
    final index = solarDate.weekday - 1;
    return DayOfWeekLocalize.values[index];
  }

  MonthLocalize get monthLocalize {
    final index = solarDate.month - 1;
    return MonthLocalize.values[index];
  }

  Future<DateEvent?> get solarDateEvent async {
    final response = await fetchEvents(
      "https://airshipkirov52.github.io/lichhomnay-events/api/solardate-events.json",
    );
    if (response.isEmpty) {
      throw Exception("No event data");
    }
    DateEvent? event;
    for (final e in response) {
      if (e.date == solarDate.day && e.month == solarDate.month) {
        event = e;
        break;
      }
    }
    return event;
  }

  Future<DateEvent?> get lunarDateEvent async {
    final response = await fetchEvents(
      "https://airshipkirov52.github.io/lichhomnay-events/api/lunardate-events.json",
    );
    if (response.isEmpty) {
      throw Exception("No quotation data");
    }
    
    DateEvent? event;
    for (final e in response) {
      if (e.date == lunarDate.ldd && e.month == lunarDate.lmm) {
        event = e;
        break;
      }
    }
    return event;
  }

  Future<Quotation> get quotation async {
    final response = await fetchQuotations(
      "https://airshipkirov52.github.io/lichhomnay-events/api/quotations.json",
    );
    if (response.isEmpty) {
      throw Exception("No quotation data");
    }
    return response[jdn % response.length];
  }
}

SolarLunarDate getSolarLunarDate(DateTime dt) {
  final timeZone = dt.timeZoneOffset.inHours.toDouble();
  List<int> rawLunarDate = LunarUtils.convertSolar2Lunar(
    dt.day,
    dt.month,
    dt.year,
    timeZone,
  );
  LunarDate lunarDate = LunarDate(
    rawLunarDate[0],
    rawLunarDate[1],
    rawLunarDate[2],
    rawLunarDate[3],
    timeZone,
  );
  return SolarLunarDate(dt, lunarDate);
}

List<SolarLunarDate> getCalendar(int month, int year) {
  DateTime firstDate = DateTime(year, month, 1);
  int weekday = firstDate.weekday - 2;
  int i = -weekday;
  List<SolarLunarDate> calandar = [];
  while (i < 42 - weekday) {
    DateTime dt = DateTime(year, month, i);
    SolarLunarDate solarLunarDate = getSolarLunarDate(dt);
    calandar.add(solarLunarDate);
    i++;
  }
  return calandar;
}
