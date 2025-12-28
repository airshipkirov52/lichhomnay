import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lich_hom_nay/calendar.dart';
import 'package:lich_hom_nay/fetch.dart';
import 'package:lich_hom_nay/json_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await fetchAndCache(
    "https://airshipkirov52.github.io/lichhomnay-events/api/solardate-events.json",
    JsonCacheService.solarEventsKey,
    JsonCacheService.solarEventsCacheUpdatedAt,
  );
  await fetchAndCache(
    "https://airshipkirov52.github.io/lichhomnay-events/api/lunardate-events.json",
    JsonCacheService.lunarEventsKey,
    JsonCacheService.lunarEventsCacheUpdatedAt,
  );
  await fetchAndCache(
    "https://airshipkirov52.github.io/lichhomnay-events/api/quotations.json",
    JsonCacheService.quotationKey,
    JsonCacheService.quotationsCacheUpdatedAt,
  );
  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lịch Hôm Nay",
      theme: ThemeData(textTheme: GoogleFonts.beVietnamProTextTheme()),
      home: const Calendar(),
    );
  }
}
