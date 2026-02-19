import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(title: Text('Personal details'), subtitle: Text('Name, phone, primary address')),
          const ListTile(title: Text('Vehicles'), subtitle: Text('Add bike model and registration')),
          const ListTile(title: Text('Addresses'), subtitle: Text('Home / work / saved pins')),
          const ListTile(title: Text('Payment methods'), subtitle: Text('Cash + UPI manual reference IDs')),
          ListTile(
            title: const Text('Mechanic documents (KYC)'),
            subtitle: const Text('Upload Aadhaar front/back + selfie (optional)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/mechanic-onboarding'),
          ),
        ],
      ),
    );
  }
}
