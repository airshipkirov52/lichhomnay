import 'dart:convert';
import 'package:http/http.dart' as http;

class Event {
  final String name;
  final String description;
  Event({required this.name, required this.description});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(name: json["name"], description: json["description"]);
  }
}

class DateEvent {
  final int date;
  final int month;
  final List<Event> events;
  final bool asterisk;
  DateEvent({
    required this.date,
    required this.month,
    required this.events,
    required this.asterisk,
  });
  factory DateEvent.fromJson(Map<String, dynamic> json) {
    return DateEvent(
      date: json["date"],
      month: json["month"],
      events: (json['events'] as List).map((e) => Event.fromJson(e)).toList(),
      asterisk: json["asterisk"],
    );
  }
}

class Quotation {
  final String content;
  final String author;
  Quotation({required this.content, required this.author});

  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(content: json["content"], author: json["author"]);
  }
}

Future<List<DateEvent>> fetchEvents(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => DateEvent.fromJson(e)).toList();
  }
  throw Exception("Fail to load data!");
}

Future<List<Quotation>> fetchQuotations(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => Quotation.fromJson(e)).toList();
  }
  throw Exception("Fail to load data!");
}
