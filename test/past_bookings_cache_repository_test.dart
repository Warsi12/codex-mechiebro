import 'package:flutter_test/flutter_test.dart';
import 'package:mechiebro/features/bookings/data/past_bookings_cache_repository.dart';
import 'package:mechiebro/features/bookings/domain/booking.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('PastBookingsCacheRepository saves and loads bookings', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = PastBookingsCacheRepository();
    final bookings = [
      Booking(
        id: 'p1',
        type: 'EMERGENCY',
        customerId: 'u1',
        serviceType: 'flat tyre',
        locationOption: 'HOME',
        address: 'Delhi',
        status: 'PAID',
        priceBase: 299,
        createdAt: DateTime.parse('2026-01-01T08:00:00Z'),
      ),
    ];

    await repo.save(bookings);
    final loaded = await repo.load();

    expect(loaded.length, 1);
    expect(loaded.first.id, 'p1');
    expect(loaded.first.status, 'PAID');
  });
}
