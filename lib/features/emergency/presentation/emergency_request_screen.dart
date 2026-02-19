import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mechiebro/features/emergency/application/emergency_controller.dart';

class EmergencyRequestScreen extends ConsumerStatefulWidget {
  const EmergencyRequestScreen({super.key});

  @override
  ConsumerState<EmergencyRequestScreen> createState() => _EmergencyRequestScreenState();
}

class _EmergencyRequestScreenState extends ConsumerState<EmergencyRequestScreen> {
  String issueType = 'breakdown';
  final noteController = TextEditingController();
  LatLng pin = const LatLng(28.6139, 77.2090);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Emergency')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Select issue type'),
          DropdownButtonFormField(
            value: issueType,
            items: const ['breakdown', 'flat tyre', 'battery issue', 'engine not starting']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => issueType = v!),
          ),
          const SizedBox(height: 12),
          TextField(controller: noteController, decoration: const InputDecoration(labelText: 'Optional note')),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: pin, zoom: 14),
              markers: {Marker(markerId: const MarkerId('pickup'), position: pin)},
              onTap: (point) => setState(() => pin = point),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              await ref.read(emergencyControllerProvider).requestEmergency(
                    issueType: issueType,
                    lat: pin.latitude,
                    lng: pin.longitude,
                    note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emergency broadcast sent to nearby mechanics.')));
              }
            },
            child: const Text('Submit Emergency'),
          ),
          const SizedBox(height: 8),
          const Text('After acceptance you will see live tracking + chat. Call masking is a TODO stub for MVP.'),
        ],
      ),
    );
  }
}
