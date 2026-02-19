import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mechiebro/features/auth/application/auth_controller.dart';
import 'package:mechiebro/features/bookings/data/bookings_repository.dart';
import 'package:mechiebro/features/bookings/domain/booking.dart';
import 'package:uuid/uuid.dart';

final userBookingsProvider = StreamProvider<List<Booking>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(bookingsRepositoryProvider).watchUserBookings(user.uid);
});

final cachedPastBookingsProvider = FutureProvider<List<Booking>>((ref) {
  return ref.watch(bookingsRepositoryProvider).loadCachedPastBookings();
});

class BookingsController {
  BookingsController(this._read);
  final Ref _read;

  Future<void> createSchedule({
    required String serviceType,
    required DateTime schedule,
    required String locationOption,
    required String address,
  }) async {
    final user = _read.read(authStateProvider).valueOrNull;
    if (user == null) throw Exception('Please login first.');
    final booking = Booking(
      id: const Uuid().v4(),
      type: 'SCHEDULED',
      customerId: user.uid,
      serviceType: serviceType,
      scheduledAt: schedule,
      locationOption: locationOption,
      address: address,
      status: 'BOOKED',
      priceBase: 399,
      createdAt: DateTime.now(),
    );
    await _read.read(bookingsRepositoryProvider).createScheduledBooking(booking);
  }
}

final bookingsControllerProvider = Provider<BookingsController>((ref) => BookingsController(ref));
