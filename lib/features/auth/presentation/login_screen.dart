import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mechiebro/features/auth/application/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController(text: '+91');
  final otpController = TextEditingController();
  bool otpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone OTP Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
            const SizedBox(height: 12),
            if (otpSent) ...[
              TextField(controller: otpController, decoration: const InputDecoration(labelText: 'Enter OTP')),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(authControllerProvider).verifyOtp(otpController.text.trim());
                  if (mounted) context.go('/');
                },
                child: const Text('Verify OTP'),
              ),
            ] else
              ElevatedButton(
                onPressed: () async {
                  await ref.read(authControllerProvider).sendOtp(
                        phoneNumber: phoneController.text.trim(),
                        onCodeSent: (_) => setState(() => otpSent = true),
                      );
                },
                child: const Text('Send OTP'),
              ),
          ],
        ),
      ),
    );
  }
}
