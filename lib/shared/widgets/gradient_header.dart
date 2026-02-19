import 'package:flutter/material.dart';

class GradientHeader extends StatelessWidget {
  const GradientHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFFF5252)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MechieBro', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('Available 24/7', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 4),
          Text('Using your current location', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 16),
          Text('How can we help you today?', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
