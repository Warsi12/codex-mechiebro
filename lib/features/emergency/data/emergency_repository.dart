import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mechiebro/features/emergency/domain/emergency_request.dart';

abstract class EmergencyRepository {
  Future<void> createEmergency(EmergencyRequest request);
  Stream<List<EmergencyRequest>> watchOpenRequests();
}

class FirestoreEmergencyRepository implements EmergencyRepository {
  FirestoreEmergencyRepository(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<void> createEmergency(EmergencyRequest request) async {
    await _firestore.collection('emergencyRequests').doc(request.id).set({
      ...request.toJson(),
      'createdAt': Timestamp.fromDate(request.createdAt),
      'geohash': 'TODO_GENERATE_GEOHASH',
    });
  }

  @override
  Stream<List<EmergencyRequest>> watchOpenRequests() {
    return _firestore.collection('emergencyRequests').where('status', isEqualTo: 'REQUESTED').snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return EmergencyRequest.fromJson({
          ...data,
          'id': doc.id,
          'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
        });
      }).toList();
    });
  }
}

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  return FirestoreEmergencyRepository(ref.watch(firestoreProvider));
});
