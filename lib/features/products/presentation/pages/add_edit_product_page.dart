import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/widgets/barcode_scanner_widget.dart';
import 'package:raag_billing/features/products/presentation/providers/product_providers.dart';
import 'package:raag_billing/features/inventory/presentation/pages/stock_movements_page.dart';

import '../../../settings/presentation/providers/settings_providers.dart';

import 'package:raag_billing/core/services/notification_service.dart';

class AddEditProductPage extends ConsumerStatefulWidget {
  final Product? product;

  const AddEditProductPage({super.key, this.product});

  @override
  ConsumerState<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends ConsumerState<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _barcodeController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _taxPercentageController;
  late TextEditingController _stockController;
  late TextEditingController _minStockController;
  late TextEditingController _unitController;
  late TextEditingController _descriptionController;
  late TextEditingController _rackController;
  late TextEditingController _batchController;
  late TextEditingController _hsnController;
  late TextEditingController _purityController;
  int? _selectedCategoryId;
  DateTime? _expiryDate;
  DateTime? _mfgDate;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name);
    _skuController = TextEditingController(text: p?.sku);
    _barcodeController = TextEditingController(text: p?.barcode);
    _purchasePriceController = TextEditingController(text: p?.purchasePrice.toString() ?? '0.0');
    _sellingPriceController = TextEditingController(text: p?.sellingPrice.toString() ?? '0.0');
    _taxPercentageController = TextEditingController(text: p?.taxPercentage.toString() ?? '0.0');
    _stockController = TextEditingController(text: p?.currentStock.toString() ?? '0.0');
    _minStockController = TextEditingController(text: p?.minimumStock.toString() ?? '0.0');
    _unitController = TextEditingController(text: p?.unit ?? 'pcs');
    _descriptionController = TextEditingController(text: p?.description);
    _rackController = TextEditingController(text: p?.rackNumber);
    _batchController = TextEditingController(text: p?.batchNumber);
    _hsnController = TextEditingController(text: p?.hsnCode);
    _purityController = TextEditingController(text: p?.purity);
    _selectedCategoryId = p?.categoryId;
    _expiryDate = p?.expiryDate;
    _mfgDate = p?.manufacturingDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _taxPercentageController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    _rackController.dispose();
    _batchController.dispose();
    _hsnController.dispose();
    _purityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final businessAsync = ref.watch(businessProfileProvider);
    final shopCategory = businessAsync.maybeWhen(
      data: (d) => d.shopCategory,
      orElse: () => 'General',
    );
    final isJewellery = shopCategory == 'Jewellery';
    final isPharmacy = shopCategory == 'Pharmacy';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        actions: [
          if (widget.product != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteProduct,
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
              decoration: const InputDecoration(labelText: 'Product Name*'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _skuController,
                    decoration: const InputDecoration(labelText: 'SKU'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _barcodeController,
                    decoration: InputDecoration(
                      labelText: 'Barcode',
                      suffixIcon: Consumer(
                        builder: (context, ref, child) {
                          final scanEnabled = ref.watch(appSettingsProvider).maybeWhen(
                            data: (s) => s.barcodeScanEnabled,
                            orElse: () => true,
                          );
                          if (!scanEnabled) return const SizedBox();
                          return IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            onPressed: () => _scanBarcode(context),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isJewellery) ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _hsnController,
                      decoration: const InputDecoration(labelText: 'HSN Code'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _purityController,
                      decoration: const InputDecoration(labelText: 'Purity (e.g. 22K)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            categoriesAsync.when(
              data: (categories) => DropdownButtonFormField<int?>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Category'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('No Category')),
                  ...categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
                ],
                onChanged: (val) => setState(() => _selectedCategoryId = val),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading categories'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _purchasePriceController,
                    decoration: const InputDecoration(labelText: 'Purchase Price'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _sellingPriceController,
                    decoration: const InputDecoration(labelText: 'Selling Price*'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _taxPercentageController,
                    decoration: const InputDecoration(labelText: 'Tax %'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _unitController,
                    decoration: const InputDecoration(labelText: 'Unit (e.g. pcs, kg)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(labelText: 'Current Stock'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _minStockController,
                    decoration: const InputDecoration(labelText: 'Min Stock Alert'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _rackController,
                    decoration: const InputDecoration(labelText: 'Rack No. (Optional)'),
                  ),
                ),
                if (isPharmacy) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _batchController,
                      decoration: const InputDecoration(labelText: 'Batch No.*'),
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ],
            ),
            if (!isJewellery) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _mfgDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => _mfgDate = picked);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: isPharmacy ? 'MFG Date*' : 'MFG Date',
                        ),
                        child: Text(_mfgDate == null ? 'Select' : DateFormat('dd/MM/yyyy').format(_mfgDate!)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _expiryDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _expiryDate = picked);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: isPharmacy ? 'Expiry Date*' : 'Expiry Date',
                        ),
                        child: Text(_expiryDate == null ? 'Select' : DateFormat('dd/MM/yyyy').format(_expiryDate!)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            if (widget.product != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockMovementsPage(product: widget.product!)),
                ),
                icon: const Icon(Icons.history),
                label: const Text('View Stock History & Adjust'),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProduct,
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProduct() async {
    final businessAsync = ref.read(businessProfileProvider).value;
    final isPharmacy = businessAsync?.shopCategory == 'Pharmacy';

    if (!_formKey.currentState!.validate()) return;

    if (isPharmacy) {
      if (_mfgDate == null || _expiryDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('MFG and Expiry dates are mandatory for Pharmacy')),
        );
        return;
      }
    }

    final repository = ref.read(productRepositoryProvider);
    
    final companion = ProductsCompanion(
      name: drift.Value(_nameController.text),
      sku: drift.Value(_skuController.text.isEmpty ? null : _skuController.text),
      barcode: drift.Value(_barcodeController.text.isEmpty ? null : _barcodeController.text),
      categoryId: drift.Value(_selectedCategoryId),
      purchasePrice: drift.Value(double.tryParse(_purchasePriceController.text) ?? 0.0),
      sellingPrice: drift.Value(double.tryParse(_sellingPriceController.text) ?? 0.0),
      taxPercentage: drift.Value(double.tryParse(_taxPercentageController.text) ?? 0.0),
      currentStock: drift.Value(double.tryParse(_stockController.text) ?? 0.0),
      minimumStock: drift.Value(double.tryParse(_minStockController.text) ?? 0.0),
      unit: drift.Value(_unitController.text),
      description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
      rackNumber: drift.Value(_rackController.text.isEmpty ? null : _rackController.text),
      batchNumber: drift.Value(_batchController.text.isEmpty ? null : _batchController.text),
      hsnCode: drift.Value(_hsnController.text.isEmpty ? null : _hsnController.text),
      purity: drift.Value(_purityController.text.isEmpty ? null : _purityController.text),
      expiryDate: drift.Value(_expiryDate),
      manufacturingDate: drift.Value(_mfgDate),
      updatedAt: drift.Value(DateTime.now()),
    );

    if (widget.product == null) {
      await repository.addProduct(companion);
      NotificationService.showNotification(
        id: DateTime.now().millisecond,
        title: 'Product Added',
        body: '${_nameController.text} has been added to inventory',
      );
    } else {
      await repository.updateProduct(widget.product!.copyWith(
        name: _nameController.text,
        sku: drift.Value(_skuController.text.isEmpty ? null : _skuController.text),
        barcode: drift.Value(_barcodeController.text.isEmpty ? null : _barcodeController.text),
        categoryId: drift.Value(_selectedCategoryId),
        purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0.0,
        sellingPrice: double.tryParse(_sellingPriceController.text) ?? 0.0,
        taxPercentage: double.tryParse(_taxPercentageController.text) ?? 0.0,
        currentStock: double.tryParse(_stockController.text) ?? 0.0,
        minimumStock: double.tryParse(_minStockController.text) ?? 0.0,
        unit: _unitController.text,
        description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
        rackNumber: drift.Value(_rackController.text.isEmpty ? null : _rackController.text),
        batchNumber: drift.Value(_batchController.text.isEmpty ? null : _batchController.text),
        hsnCode: drift.Value(_hsnController.text.isEmpty ? null : _hsnController.text),
        purity: drift.Value(_purityController.text.isEmpty ? null : _purityController.text),
        expiryDate: drift.Value(_expiryDate),
        manufacturingDate: drift.Value(_mfgDate),
        updatedAt: DateTime.now(),
      ));
    }

    if (mounted) Navigator.pop(context);
  }

  void _scanBarcode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeScannerWidget(
          onDetect: (barcode) {
            setState(() {
              _barcodeController.text = barcode;
            });
          },
        ),
      ),
    );
  }

  void _deleteProduct() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
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
      await ref.read(productRepositoryProvider).deleteProduct(widget.product!.id);
      if (mounted) Navigator.pop(context);
    }
  }
}
