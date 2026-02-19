import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mechiebro/features/bookings/data/bookings_repository.dart';

class MechanicRepository {
  MechanicRepository(this._db);
  final FirebaseFirestore _db;

  Future<void> submitOnboarding({
    required String uid,
    required String aadhaarLast4,
    required List<String> skills,
    required List<String> tools,
    required int radiusKm,
  }) async {
    await _db.collection('mechanics').doc(uid).set({
      'kycStatus': 'PENDING',
      'aadhaarLast4': aadhaarLast4,
      'skills': skills,
      'tools': tools,
      'radiusKm': radiusKm,
      'isOnline': false,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _db.collection('users').doc(uid).set({
      'roleFlags': {'isMechanic': true},
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> setAvailability({required String uid, required bool isOnline}) {
    return _db.collection('mechanics').doc(uid).set({'isOnline': isOnline}, SetOptions(merge: true));
  }

  Future<void> approveKyc({required String uid}) {
    return _db.collection('mechanics').doc(uid).set({'kycStatus': 'VERIFIED'}, SetOptions(merge: true));
  }
}

final mechanicRepositoryProvider = Provider((ref) => MechanicRepository(ref.watch(firestoreProvider)));
