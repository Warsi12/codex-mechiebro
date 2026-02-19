import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mechiebro/features/auth/application/auth_controller.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool notifications = true;
  bool mechanicMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            value: mechanicMode,
            onChanged: (v) => setState(() => mechanicMode = v),
            title: const Text('Role Toggle: Mechanic mode'),
            subtitle: const Text('Visible after onboarding as mechanic'),
          ),
          SwitchListTile(
            value: notifications,
            onChanged: (v) => setState(() => notifications = v),
            title: const Text('Push notifications'),
          ),
          ListTile(
            title: const Text('Admin mode'),
            subtitle: const Text('Requires custom admin claim'),
            onTap: () => context.push('/admin'),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async => ref.read(authControllerProvider).signOut(),
          ),
          const ListTile(
            title: Text('Delete account'),
            subtitle: Text('MVP stub. Add callable function + re-auth in production.'),
          ),
        ],
      ),
    );
  }
}
