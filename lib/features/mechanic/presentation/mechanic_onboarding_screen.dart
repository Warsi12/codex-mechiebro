import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mechiebro/features/auth/application/auth_controller.dart';
import 'package:mechiebro/features/mechanic/data/mechanic_repository.dart';

class MechanicOnboardingScreen extends ConsumerStatefulWidget {
  const MechanicOnboardingScreen({super.key});

  @override
  ConsumerState<MechanicOnboardingScreen> createState() => _MechanicOnboardingScreenState();
}

class _MechanicOnboardingScreenState extends ConsumerState<MechanicOnboardingScreen> {
  final aadhaarLast4 = TextEditingController();
  final skills = TextEditingController(text: 'general servicing, diagnostics');
  final tools = TextEditingController(text: 'spanner set, portable inflator');
  double radius = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mechanic Onboarding + KYC')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Upload Aadhaar docs and selfie using Firebase Storage (UI stub for MVP).'),
          const SizedBox(height: 12),
          TextField(controller: aadhaarLast4, maxLength: 4, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Aadhaar last 4 digits')),
          TextField(controller: skills, decoration: const InputDecoration(labelText: 'Skills (comma separated)')),
          TextField(controller: tools, decoration: const InputDecoration(labelText: 'Tools (comma separated)')),
          const SizedBox(height: 12),
          Text('Service radius: ${radius.round()} km'),
          Slider(value: radius, min: 3, max: 10, divisions: 7, onChanged: (v) => setState(() => radius = v)),
          FilledButton(
            onPressed: () async {
              final uid = ref.read(authStateProvider).valueOrNull?.uid;
              if (uid == null) return;
              await ref.read(mechanicRepositoryProvider).submitOnboarding(
                    uid: uid,
                    aadhaarLast4: aadhaarLast4.text,
                    skills: skills.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                    tools: tools.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                    radiusKm: radius.round(),
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Onboarding submitted. KYC status: PENDING')));
              }
            },
            child: const Text('Submit for verification'),
          ),
        ],
      ),
    );
  }
}
