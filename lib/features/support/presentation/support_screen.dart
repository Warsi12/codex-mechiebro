import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('FAQ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const ListTile(title: Text('How quickly will emergency help arrive?'), subtitle: Text('Usually 15-30 minutes depending on mechanic availability.')),
          const ListTile(title: Text('When do I pay?'), subtitle: Text('After service completion via Cash or manual UPI entry.')),
          FilledButton.tonal(
            onPressed: () => launchUrl(Uri.parse('https://wa.me/919999999999')),
            child: const Text('Open WhatsApp Support'),
          ),
          const SizedBox(height: 12),
          const Card(child: ListTile(title: Text('In-app support chat'), subtitle: Text('MVP stub: Firestore chat collection hooks available.'))),
        ],
      ),
    );
  }
}
