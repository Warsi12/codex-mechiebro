import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double stars = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Service')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Slider(value: stars, min: 1, max: 5, divisions: 4, label: stars.toStringAsFixed(0), onChanged: (v) => setState(() => stars = v)),
            const Text('Both customer and mechanic can rate after payment.'),
            const SizedBox(height: 12),
            FilledButton(onPressed: () {}, child: const Text('Submit Rating')),
          ],
        ),
      ),
    );
  }
}
