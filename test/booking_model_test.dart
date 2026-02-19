import 'package:flutter_test/flutter_test.dart';
import 'package:mechiebro/features/bookings/domain/booking.dart';

void main() {
  test('Booking serializes and deserializes', () {
    final booking = Booking(
      id: 'b1',
      type: 'SCHEDULED',
      customerId: 'u1',
      mechanicId: 'm1',
      serviceType: 'oil change',
      scheduledAt: DateTime.parse('2026-01-01T10:00:00Z'),
      locationOption: 'HOME',
      address: 'Delhi',
      status: 'BOOKED',
      priceBase: 399,
      priceAdjustment: 100,
      createdAt: DateTime.parse('2026-01-01T08:00:00Z'),
    );

    final decoded = Booking.fromJson(booking.toJson());
    expect(decoded.id, 'b1');
    expect(decoded.priceFinal, 499);
    expect(decoded.mechanicId, 'm1');
  });
}
