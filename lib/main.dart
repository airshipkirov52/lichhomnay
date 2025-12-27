import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lich_hom_nay/calendar.dart';

void main() {
  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lịch Hôm Nay",
      theme: ThemeData(
        textTheme: GoogleFonts.beVietnamProTextTheme(),
      ),
      home: const Calendar(),
    );
  }
}

