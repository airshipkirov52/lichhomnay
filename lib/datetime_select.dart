import 'package:flutter/cupertino.dart';
import 'package:lich_hom_nay/calendar_utils.dart';

class DatetimeSelect extends StatefulWidget {
  const DatetimeSelect({super.key});

  @override
  State<DatetimeSelect> createState() => _DatetimeSelectState();
}

class _DatetimeSelectState extends State<DatetimeSelect> {
  static const int _middleIndex = 3;

  late DateTime currentDate = DateTime.now();

  int selectedHour = DateTime.now().hour;
  int selectedMinute = DateTime.now().minute;
  int _lastIndex = _middleIndex;

  void onSelectedItemChanged(int index) {
    if (index > _lastIndex) {
      setState(() {
        currentDate = currentDate.add(Duration(days: 1));
      });
    } else if (index < _lastIndex) {
      currentDate = currentDate.add(Duration(days: -1));
    }
    _lastIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    final dates = List.generate(7, (i) {
      final dt = currentDate.add(Duration(days: i));
      return getSolarLunarDate(dt);
    });
    final hours = List.generate(24, (i) => i);
    final minutes = List.generate(60, (i) => i);

    return Row(
      children: [
        Flexible(
          flex: 6,
          child: SizedBox(
            height: 250,
            child: CupertinoPicker(
              itemExtent: 40,
              useMagnifier: false,
              magnification: 1.0,
              squeeze: 1.0,
              looping: true,
              onSelectedItemChanged: onSelectedItemChanged,
              children: dates
                  .map(
                    (d) => Center(
                      child: Text(
                        "${d.dayOfWeekLocalize.vi}, ${d.solarDate.day} Th ${d.solarDate.month} ${d.solarDate.year}",
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: SizedBox(
            height: 250,
            child: CupertinoPicker(
              itemExtent: 40,
              useMagnifier: false,
              magnification: 1.0,
              squeeze: 1.0,
              looping: true,
              onSelectedItemChanged: (i) {
                print(i);
              },
              children: hours
                  .map((h) => Center(child: Text(h.toString().padLeft(2, "0"))))
                  .toList(),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: SizedBox(
            height: 250,
            child: CupertinoPicker(
              itemExtent: 40,
              useMagnifier: false,
              magnification: 1.0,
              squeeze: 1.0,
              looping: true,
              onSelectedItemChanged: (i) {
                // final dt = DateTime.now();
                // dt.add(Duration(days: (i - 7) % 7));
              },
              children: minutes
                  .map((m) => Center(child: Text(m.toString().padLeft(2, "0"))))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
