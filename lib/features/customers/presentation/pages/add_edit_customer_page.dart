import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:raag_billing/core/database/app_database.dart';
import '../providers/customer_providers.dart';

class AddEditCustomerPage extends ConsumerStatefulWidget {
  final Customer? customer;

  const AddEditCustomerPage({super.key, this.customer});

  @override
  ConsumerState<AddEditCustomerPage> createState() => _AddEditCustomerPageState();
}

class _AddEditCustomerPageState extends ConsumerState<AddEditCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameController = TextEditingController(text: c?.name);
    _phoneController = TextEditingController(text: c?.phone);
    _emailController = TextEditingController(text: c?.email);
    _addressController = TextEditingController(text: c?.address);
    _notesController = TextEditingController(text: c?.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
        actions: [
          if (widget.customer != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteCustomer,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Customer Name*'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCustomer,
              child: const Text('Save Customer'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    final repository = ref.read(customerRepositoryProvider);

    final companion = CustomersCompanion(
      name: drift.Value(_nameController.text),
      phone: drift.Value(_phoneController.text.isEmpty ? null : _phoneController.text),
      email: drift.Value(_emailController.text.isEmpty ? null : _emailController.text),
      address: drift.Value(_addressController.text.isEmpty ? null : _addressController.text),
      notes: drift.Value(_notesController.text.isEmpty ? null : _notesController.text),
      updatedAt: drift.Value(DateTime.now()),
    );

    if (widget.customer == null) {
      await repository.addCustomer(companion);
    } else {
      await repository.updateCustomer(widget.customer!.copyWith(
        name: _nameController.text,
        phone: drift.Value(_phoneController.text.isEmpty ? null : _phoneController.text),
        email: drift.Value(_emailController.text.isEmpty ? null : _emailController.text),
        address: drift.Value(_addressController.text.isEmpty ? null : _addressController.text),
        notes: drift.Value(_notesController.text.isEmpty ? null : _notesController.text),
        updatedAt: DateTime.now(),
      ));
    }

    if (mounted) Navigator.pop(context);
  }

  void _deleteCustomer() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: const Text('Are you sure you want to delete this customer?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(customerRepositoryProvider).deleteCustomer(widget.customer!.id);
      if (mounted) Navigator.pop(context);
    }
  }
}
