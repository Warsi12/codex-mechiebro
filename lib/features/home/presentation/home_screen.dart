import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mechiebro/shared/widgets/gradient_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const GradientHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _Shortcut(icon: Icons.person_outline, label: 'Profile', route: '/profile'),
                    _Shortcut(icon: Icons.receipt_long, label: 'Bookings', route: '/bookings'),
                    _Shortcut(icon: Icons.support_agent, label: 'Support', route: '/support'),
                    _Shortcut(icon: Icons.settings, label: 'Settings', route: '/settings'),
                  ],
                ),
                const SizedBox(height: 20),
                _ActionCard(
                  title: 'Emergency Help',
                  subtitle: 'Get immediate assistance',
                  icon: Icons.warning_amber_rounded,
                  onTap: () => context.push('/emergency'),
                ),
                _ActionCard(
                  title: 'Schedule a Service',
                  subtitle: 'Book routine maintenance',
                  icon: Icons.calendar_month,
                  onTap: () => context.push('/bookings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({required this.icon, required this.label, required this.route});
  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(route),
      child: Column(
        children: [
          CircleAvatar(child: Icon(icon)),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.title, required this.subtitle, required this.icon, required this.onTap});
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 32),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
