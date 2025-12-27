import 'dart:math';

class LunarUtils {
  /// Compute the (integral) Julian day number of day dd/mm/yyyy, i.e., the number
  /// of days between 1/1/4713 BC (Julian calendar) and dd/mm/yyyy. Formula from
  /// http://www.tondering.dk/claus/calendar.html
  static int jdnFromDate(int dd, int mm, int yy) {
    int a = (14 - mm) ~/ 12;
    int y = yy + 4800 - a;
    int m = mm + 12 * a - 3;
    int jdn =
        dd +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
    if (jdn < 2299161) {
      jdn = dd + (153 * m + 2) ~/ 5 + 365 * y + y ~/ 4 - 32083;
    }
    return jdn;
  }

  /// http://www.tondering.dk/claus/calendar.html Section: Is there a formula for
  /// calculating the Julian day number?
  ///
  /// [jdn] - the number of days since 1 January 4713 BC (Julian calendar)
  static List<int> jdnToDate(int jdn) {
    int a, b, c;
    if (jdn > 2299160) {
      // After 5/10/1582, Gregorian calendar
      a = jdn + 32044;
      b = (4 * a + 3) ~/ 146097;
      c = a - (b * 146097) ~/ 4;
    } else {
      b = 0;
      c = jdn + 32082;
    }
    int d = (4 * c + 3) ~/ 1461;
    int e = c - (1461 * d) ~/ 4;
    int m = (5 * e + 2) ~/ 153;
    int day = e - (153 * m + 2) ~/ 5 + 1;
    int month = m + 3 - 12 * (m ~/ 10);
    int year = b * 100 + d - 4800 + m ~/ 10;
    return [day, month, year];
  }

  /// Solar longitude in degrees Algorithm from: Astronomical Algorithms, by Jean
  /// Meeus, 1998
  ///
  /// [jdn] - number of days since noon UTC on 1 January 4713 BC
  static double sunLongitude(double jdn) {
    return sunLongitudeAA98(jdn);
  }

  static double sunLongitude2(double jdn) {
    double t =
        (jdn - 2451545.0) /
        36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
    double t2 = t * t;
    double dr = pi / 180; // degree to radian
    double m =
        357.52910 +
        35999.05030 * t -
        0.0001559 * t2 -
        0.00000048 * t * t2; // mean anomaly, degree
    double l0 =
        280.46645 + 36000.76983 * t + 0.0003032 * t2; // mean longitude, degree
    double dl = (1.914600 - 0.004817 * t - 0.000014 * t2) * sin(dr * m);
    dl =
        dl +
        (0.019993 - 0.000101 * t) * sin(dr * 2 * m) +
        0.000290 * sin(dr * 3 * m);
    double l = l0 + dl; // true longitude, degree
    l = l * dr;
    l = l - pi * 2 * (intPart(l / (pi * 2))); // Normalize to (0, 2*PI)
    return l;
  }

  /// SunLongitudeAA98
  static double sunLongitudeAA98(double jdn) {
    double t =
        (jdn - 2451545.0) /
        36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
    double t2 = t * t;
    double dr = pi / 180; // degree to radian
    double m =
        357.52910 +
        35999.05030 * t -
        0.0001559 * t2 -
        0.00000048 * t * t2; // mean anomaly, degree
    double l0 =
        280.46645 + 36000.76983 * t + 0.0003032 * t2; // mean longitude, degree
    double dl = (1.914600 - 0.004817 * t - 0.000014 * t2) * sin(dr * m);
    dl =
        dl +
        (0.019993 - 0.000101 * t) * sin(dr * 2 * m) +
        0.000290 * sin(dr * 3 * m);
    double l = l0 + dl; // true longitude, degree
    l = l - 360 * (intPart(l / 360)); // Normalize to (0, 360)
    return l;
  }

  /// NewMoon
  static double newMoon(int k) {
    return newMoonAA98(k);
  }

  /// Julian day number of the kth new moon after (or before) the New Moon of
  /// 1900-01-01 13:51 GMT. Accuracy: 2 minutes Algorithm from: Astronomical
  /// Algorithms, by Jean Meeus, 1998
  ///
  /// [k]
  /// Returns the Julian date number (number of days since noon UTC on 1 January
  /// 4713 BC) of the New Moon
  static double newMoonAA98(int k) {
    double t = k / 1236.85; // Time in Julian centuries from 1900 January 0.5
    double t2 = t * t;
    double t3 = t2 * t;
    double dr = pi / 180;
    double jd1 =
        2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3;
    jd1 =
        jd1 +
        0.00033 *
            sin((166.56 + 132.87 * t - 0.009173 * t2) * dr); // Mean new moon
    double m =
        359.2242 +
        29.10535608 * k -
        0.0000333 * t2 -
        0.00000347 * t3; // Sun's mean anomaly
    double mpr =
        306.0253 +
        385.81691806 * k +
        0.0107306 * t2 +
        0.00001236 * t3; // Moon's mean anomaly
    double f =
        21.2964 +
        390.67050646 * k -
        0.0016528 * t2 -
        0.00000239 * t3; // Moon's argument of latitude
    double c1 =
        (0.1734 - 0.000393 * t) * sin(m * dr) + 0.0021 * sin(2 * dr * m);
    c1 = c1 - 0.4068 * sin(mpr * dr) + 0.0161 * sin(dr * 2 * mpr);
    c1 = c1 - 0.0004 * sin(dr * 3 * mpr);
    c1 = c1 + 0.0104 * sin(dr * 2 * f) - 0.0051 * sin(dr * (m + mpr));
    c1 = c1 - 0.0074 * sin(dr * (m - mpr)) + 0.0004 * sin(dr * (2 * f + m));
    c1 = c1 - 0.0004 * sin(dr * (2 * f - m)) - 0.0006 * sin(dr * (2 * f + mpr));
    c1 =
        c1 +
        0.0010 * sin(dr * (2 * f - mpr)) +
        0.0005 * sin(dr * (2 * mpr + m));
    double deltat;
    if (t < -11) {
      deltat =
          0.001 +
          0.000839 * t +
          0.0002261 * t2 -
          0.00000845 * t3 -
          0.000000081 * t * t3;
    } else {
      deltat = -0.000278 + 0.000265 * t + 0.000262 * t2;
    }
    double jdNew = jd1 + c1 - deltat;
    return jdNew;
  }

  /// Discard the fractional part of a number, e.g., INT(3.2) = 3
  static int intPart(double d) {
    return d.floor();
  }

  /// Compute sun position at midnight of the day with the given Julian day number.
  /// The time zone if the time difference between local time and UTC: 7.0 for
  /// UTC+7:00. The function returns a number between 0 and 11. From the day after
  /// March equinox and the 1st major term after March equinox, 0 is returned.
  /// After that, return 1, 2, 3 ...
  static double getSunLongitude(int dayNumber, double timeZone) {
    return sunLongitude(dayNumber - 0.5 - timeZone / 24);
  }

  static double getSunLongitude2(int dayNumber, double timeZone) {
    return sunLongitude2(dayNumber - 0.5 - timeZone / 24) / pi * 12;
  }

  /// Compute the day of the k-th new moon in the given time zone. The time zone if
  /// the time difference between local time and UTC: 7.0 for UTC+7:00
  static int getNewMoonDay(int k, double timeZone) {
    double jd = newMoon(k);
    return intPart(jd + 0.5 + timeZone / 24);
  }

  /// Find the day that starts the luner month 11 of the given year for the given
  /// time zone
  static int getLunarMonth11(int yy, double timeZone) {
    double off = jdnFromDate(31, 12, yy) - 2415021.076998695;
    int k = intPart(off / 29.530588853);
    int nm = getNewMoonDay(k, timeZone);
    int sunLong = intPart(getSunLongitude(nm, timeZone) / 30);
    if (sunLong >= 9) {
      nm = getNewMoonDay(k - 1, timeZone);
    }
    return nm;
  }

  /// Find the index of the leap month after the month starting on the day a11.
  static int getLeapMonthOffset(int a11, double timeZone) {
    int k = intPart(0.5 + (a11 - 2415021.076998695) / 29.530588853);
    int
    last; // Month 11 contains point of sun longutide 3*PI/2 (December solstice)
    int i = 1; // We start with the month following lunar month 11
    int arc = intPart(
      getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone) / 30,
    );
    do {
      last = arc;
      i++;
      arc = intPart(
        getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone) / 30,
      );
    } while (arc != last && i < 14);
    return i - 1;
  }

  /// Convert solar date dd/mm/yyyy to the corresponding lunar date
  ///
  /// Returns array of [lunarDay, lunarMonth, lunarYear, leapOrNot]
  static List<int> convertSolar2Lunar(int dd, int mm, int yy, double timeZone) {
    int lunarDay, lunarMonth, lunarYear, lunarLeap;
    int dayNumber = jdnFromDate(dd, mm, yy);
    int k = intPart((dayNumber - 2415021.076998695) / 29.530588853);
    int monthStart = getNewMoonDay(k + 1, timeZone);
    if (monthStart > dayNumber) {
      monthStart = getNewMoonDay(k, timeZone);
    }
    int a11 = getLunarMonth11(yy, timeZone);
    int b11 = a11;
    if (a11 >= monthStart) {
      lunarYear = yy;
      a11 = getLunarMonth11(yy - 1, timeZone);
    } else {
      lunarYear = yy + 1;
      b11 = getLunarMonth11(yy + 1, timeZone);
    }
    lunarDay = dayNumber - monthStart + 1;
    int diff = intPart((monthStart - a11) / 29);
    lunarLeap = 0;
    lunarMonth = diff + 11;
    if (b11 - a11 > 365) {
      int leapMonthDiff = getLeapMonthOffset(a11, timeZone);
      if (diff >= leapMonthDiff) {
        lunarMonth = diff + 10;
        if (diff == leapMonthDiff) {
          lunarLeap = 1;
        }
      }
    }
    if (lunarMonth > 12) {
      lunarMonth = lunarMonth - 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
      lunarYear -= 1;
    }
    return [lunarDay, lunarMonth, lunarYear, lunarLeap];
  }

  /// Find the index of the leap month after the month starting on the day a11.
  static List<int> convertLunar2Solar(
    int lunarDay,
    int lunarMonth,
    int lunarYear,
    int lunarLeap,
    double timeZone,
  ) {
    int a11, b11;
    if (lunarMonth < 11) {
      a11 = getLunarMonth11(lunarYear - 1, timeZone);
      b11 = getLunarMonth11(lunarYear, timeZone);
    } else {
      a11 = getLunarMonth11(lunarYear, timeZone);
      b11 = getLunarMonth11(lunarYear + 1, timeZone);
    }
    int k = intPart(0.5 + (a11 - 2415021.076998695) / 29.530588853);
    int off = lunarMonth - 11;
    if (off < 0) {
      off += 12;
    }
    if (b11 - a11 > 365) {
      int leapOff = getLeapMonthOffset(a11, timeZone);
      int leapMonth = leapOff - 2;
      if (leapMonth < 0) {
        leapMonth += 12;
      }
      if (lunarLeap != 0 && lunarMonth != leapMonth) {
        return [0, 0, 0];
      } else if (lunarLeap != 0 || off >= leapOff) {
        off += 1;
      }
    }
    int monthStart = getNewMoonDay(k + off, timeZone);
    return jdnToDate(monthStart + lunarDay - 1);
  }

}
