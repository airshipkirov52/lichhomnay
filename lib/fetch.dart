import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lich_hom_nay/calendar_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Duration ttl = Duration(days: 1);

Future<void> fetchAndCache(String url, String dataKey, String ttlKey) async {
  final prefs = await SharedPreferences.getInstance();
  final cachedJson = prefs.getString(dataKey);
  final cachedTime = prefs.getInt(ttlKey);
  final now = DateTime.now();

  if (cachedJson != null && cachedTime != null) {
    final cachedDate = DateTime.fromMillisecondsSinceEpoch(cachedTime);

    if (now.difference(cachedDate) < ttl) {
      return;
    }
  }

  final uri = Uri.parse(url);
  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception("Failed to fetch solar events");
  }

  await prefs.setString(dataKey, response.body);
  await prefs.setInt(ttlKey, DateTime.now().millisecondsSinceEpoch);
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
