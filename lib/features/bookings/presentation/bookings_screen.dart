import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mechiebro/features/bookings/application/bookings_controller.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(userBookingsProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings'),
          bottom: const TabBar(tabs: [Tab(text: 'Upcoming'), Tab(text: 'Ongoing'), Tab(text: 'Past')]),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openCreateDialog(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Schedule'),
        ),
        body: bookings.when(
          data: (items) {
            final upcoming = items.where((e) => ['BOOKED', 'MECHANIC_ASSIGNED', 'CONFIRMED'].contains(e.status)).toList();
            final ongoing = items.where((e) => ['EN_ROUTE', 'IN_SERVICE', 'ACCEPTED', 'ARRIVED'].contains(e.status)).toList();
            final past = items.where((e) => ['COMPLETED', 'PAID', 'RATED'].contains(e.status)).toList();
            return TabBarView(children: [_list(upcoming), _list(ongoing), _list(past)]);
          },
          error: (e, _) => Center(child: Text('Error: $e')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _list(List<dynamic> items) {
    if (items.isEmpty) return const Center(child: Text('No bookings yet.'));
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) {
        final b = items[i];
        return Card(
          child: ListTile(
            title: Text(b.serviceType),
            subtitle: Text('${b.status} • ₹${b.priceFinal.toStringAsFixed(0)}'),
            trailing: Text(DateFormat('dd MMM').format(b.createdAt)),
          ),
        );
      },
    );
  }

  Future<void> _openCreateDialog(BuildContext context, WidgetRef ref) async {
    final formKey = GlobalKey<FormState>();
    final address = TextEditingController();
    String service = 'oil change';
    String location = 'HOME';
    DateTime schedule = DateTime.now().add(const Duration(hours: 2));

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Schedule Service'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField(
                    value: service,
                    items: const ['oil change', 'chain & sprocket', 'brake service', 'general servicing', 'diagnostics', 'electrical work']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => service = v!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(controller: address, decoration: const InputDecoration(labelText: 'Address')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    value: location,
                    items: const [DropdownMenuItem(value: 'HOME', child: Text('Home')), DropdownMenuItem(value: 'SHOP', child: Text('Mechanic Shop'))],
                    onChanged: (v) => location = v!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                final now = DateTime.now();
                final min = now.add(const Duration(hours: 1));
                if (schedule.hour < 9 || schedule.hour >= 20 || schedule.isBefore(min)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pick 9AM–8PM and at least 1-hour lead time.')));
                  return;
                }
                await ref.read(bookingsControllerProvider).createSchedule(
                      serviceType: service,
                      schedule: schedule,
                      locationOption: location,
                      address: address.text,
                    );
                if (context.mounted) Navigator.pop(ctx);
              },
              child: const Text('Book'),
            ),
          ],
        );
      },
    );
  }
}
