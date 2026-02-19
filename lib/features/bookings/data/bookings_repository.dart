import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mechiebro/features/bookings/data/past_bookings_cache_repository.dart';
import 'package:mechiebro/features/bookings/domain/booking.dart';

abstract class BookingsRepository {
  Stream<List<Booking>> watchUserBookings(String userId);
  Future<void> createScheduledBooking(Booking booking);
  Future<List<Booking>> loadCachedPastBookings();
}

class FirestoreBookingsRepository implements BookingsRepository {
  FirestoreBookingsRepository(this._firestore, this._cache);

  final FirebaseFirestore _firestore;
  final PastBookingsCacheRepository _cache;

  @override
  Stream<List<Booking>> watchUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('customerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final bookings = snapshot.docs.map((doc) {
        final data = doc.data();
        return Booking.fromJson({
          ...data,
          'id': doc.id,
          'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
          'scheduledAt': (data['scheduledAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
      _cache.save(bookings.where((b) => b.status == 'COMPLETED' || b.status == 'PAID' || b.status == 'RATED').toList());
      return bookings;
    });
  }

  @override
  Future<void> createScheduledBooking(Booking booking) async {
    await _firestore.collection('bookings').doc(booking.id).set({
      ...booking.toJson(),
      'createdAt': Timestamp.fromDate(booking.createdAt),
      'scheduledAt': booking.scheduledAt == null ? null : Timestamp.fromDate(booking.scheduledAt!),
    });
  }

  @override
  Future<List<Booking>> loadCachedPastBookings() {
    return _cache.load();
  }
}

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  return FirestoreBookingsRepository(ref.watch(firestoreProvider), PastBookingsCacheRepository());
});
