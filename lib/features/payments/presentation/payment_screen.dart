import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String method = 'CASH';
  final utr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const base = 399.0;
    const adjustment = 100.0;
    final total = base + adjustment;
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Receipt Preview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Base: ₹399'),
            const Text('Mechanic adjustment: ₹100'),
            Text('Final: ₹${total.toStringAsFixed(0)}'),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: method,
              items: const [DropdownMenuItem(value: 'CASH', child: Text('Cash')), DropdownMenuItem(value: 'UPI', child: Text('UPI (manual)'))],
              onChanged: (v) => setState(() => method = v!),
            ),
            if (method == 'UPI') ...[
              const SizedBox(height: 8),
              TextField(controller: utr, decoration: const InputDecoration(labelText: 'UPI UTR / reference ID')),
            ],
            const SizedBox(height: 12),
            FilledButton(onPressed: () {}, child: const Text('Mark as Paid')),
          ],
        ),
      ),
    );
  }
}
