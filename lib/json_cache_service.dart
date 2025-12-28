import 'dart:convert';

import 'package:lich_hom_nay/calendar_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JsonCacheService {
  static String solarEventsKey = "solar_events";
  static String solarEventsCacheUpdatedAt = "solar_events_cache_updated_at";

  static String lunarEventsKey = "lunar_events";
  static String lunarEventsCacheUpdatedAt = "lunar_events_cache_updated_at";

  static String quotationKey = "quotations";
  static String quotationsCacheUpdatedAt = "quotations_cache_updated_at";

  static Future<List<DateEvent>> fetchEvents(String cacheKey) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(cacheKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => DateEvent.fromJson(e)).toList();
  }

  static Future<List<Quotation>> fetchQuotations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(quotationKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Quotation.fromJson(e)).toList();
  }
}
