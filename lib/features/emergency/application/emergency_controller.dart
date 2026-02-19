import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mechiebro/features/auth/application/auth_controller.dart';
import 'package:mechiebro/features/emergency/data/emergency_repository.dart';
import 'package:mechiebro/features/emergency/domain/emergency_request.dart';
import 'package:uuid/uuid.dart';

class EmergencyController {
  EmergencyController(this._read);
  final Ref _read;

  Future<void> requestEmergency({required String issueType, required double lat, required double lng, String? note}) async {
    final user = _read.read(authStateProvider).valueOrNull;
    if (user == null) throw Exception('Please login first.');
    final request = EmergencyRequest(
      id: const Uuid().v4(),
      customerId: user.uid,
      issueType: issueType,
      status: 'REQUESTED',
      lat: lat,
      lng: lng,
      note: note,
      createdAt: DateTime.now(),
    );
    await _read.read(emergencyRepositoryProvider).createEmergency(request);
  }
}

final emergencyControllerProvider = Provider<EmergencyController>((ref) => EmergencyController(ref));
final mechanicJobFeedProvider = StreamProvider((ref) => ref.watch(emergencyRepositoryProvider).watchOpenRequests());
