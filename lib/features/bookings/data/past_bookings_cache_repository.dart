import 'dart:convert';

import 'package:mechiebro/features/bookings/domain/booking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PastBookingsCacheRepository {
  static const cacheKey = 'past_bookings_cache';

  Future<void> save(List<Booking> bookings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cacheKey, jsonEncode(bookings.map((e) => e.toJson()).toList()));
  }

  Future<List<Booking>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(cacheKey);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    return list.map(Booking.fromJson).toList();
  }
}
