import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mechiebro/features/mechanic/data/mechanic_repository.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uidController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Mode (Claim Protected)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Approve mechanic KYC / resolve disputes (MVP minimal admin panel).'),
            const SizedBox(height: 16),
            TextField(controller: uidController, decoration: const InputDecoration(labelText: 'Mechanic UID')),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () async {
                await ref.read(mechanicRepositoryProvider).approveKyc(uid: uidController.text.trim());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('KYC set to VERIFIED')));
                }
              },
              child: const Text('Approve KYC'),
            ),
          ],
        ),
      ),
    );
  }
}
