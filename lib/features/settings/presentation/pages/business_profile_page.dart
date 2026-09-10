import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart' as drift;
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/features/settings/presentation/providers/settings_providers.dart';

const List<Map<String, String>> _countries = [
  {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
  {'code': '+1', 'name': 'USA', 'flag': '🇺🇸'},
  {'code': '+44', 'name': 'UK', 'flag': '🇬🇧'},
  {'code': '+971', 'name': 'UAE', 'flag': '🇦🇪'},
  {'code': '+61', 'name': 'Australia', 'flag': '🇦🇺'},
  {'code': '+1', 'name': 'Canada', 'flag': '🇨🇦'},
  {'code': '+86', 'name': 'China', 'flag': '🇨🇳'},
  {'code': '+33', 'name': 'France', 'flag': '🇫🇷'},
  {'code': '+49', 'name': 'Germany', 'flag': '🇩🇪'},
  {'code': '+81', 'name': 'Japan', 'flag': '🇯🇵'},
  {'code': '+92', 'name': 'Pakistan', 'flag': '🇵🇰'},
  {'code': '+94', 'name': 'Sri Lanka', 'flag': '🇱🇰'},
  {'code': '+880', 'name': 'Bangladesh', 'flag': '🇧🇩'},
  {'code': '+977', 'name': 'Nepal', 'flag': '🇳🇵'},
  {'code': '+65', 'name': 'Singapore', 'flag': '🇸🇬'},
  {'code': '+60', 'name': 'Malaysia', 'flag': '🇲🇾'},
  {'code': '+966', 'name': 'Saudi Arabia', 'flag': '🇸🇦'},
  {'code': '+90', 'name': 'Turkey', 'flag': '🇹🇷'},
];

class BusinessProfilePage extends ConsumerStatefulWidget {
  const BusinessProfilePage({super.key});

  @override
  ConsumerState<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends ConsumerState<BusinessProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ownerController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _gstinController;
  late TextEditingController _upiController;
  late TextEditingController _prefixController;
  late TextEditingController _currencyController;
  late TextEditingController _taxController;
  late TextEditingController _bankNameController;
  late TextEditingController _accountNumberController;
  late TextEditingController _ifscCodeController;
  late TextEditingController _termsController;
  String? _logoPath;
  String _selectedCountryCode = '+91';
  String _selectedShopCategory = 'General';
  bool _isSaving = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ownerController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _gstinController = TextEditingController();
    _upiController = TextEditingController();
    _prefixController = TextEditingController();
    _currencyController = TextEditingController();
    _taxController = TextEditingController();
    _bankNameController = TextEditingController();
    _accountNumberController = TextEditingController();
    _ifscCodeController = TextEditingController();
    _termsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _gstinController.dispose();
    _upiController.dispose();
    _prefixController.dispose();
    _currencyController.dispose();
    _taxController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  void _fillData(BusinessProfileData data) {
    setState(() {
      _nameController.text = data.name;
      _ownerController.text = data.ownerName ?? '';
      
      String phoneText = data.phone ?? '';
      if (phoneText.startsWith('+')) {
        if (phoneText.startsWith('+91')) {
          _selectedCountryCode = '+91';
          phoneText = phoneText.substring(3);
        }
      }
      _phoneController.text = phoneText;
      
      _emailController.text = data.email ?? '';
      _addressController.text = data.address ?? '';
      _gstinController.text = data.gstin ?? '';
      _upiController.text = data.upiId ?? '';
      _prefixController.text = data.invoicePrefix;
      _currencyController.text = data.currencySymbol;
      _taxController.text = data.defaultTaxPercentage.toString();
      _logoPath = data.logoPath;
      _selectedShopCategory = data.shopCategory;
      _bankNameController.text = data.bankName ?? '';
      _accountNumberController.text = data.accountNumber ?? '';
      _ifscCodeController.text = data.ifscCode ?? '';
      _termsController.text = data.termsAndConditions ?? '• Goods once sold will not be taken back.\n• All disputes subject to local jurisdiction.';
    });
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
      setState(() => _logoPath = savedImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(businessProfileProvider);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
            onPressed: () {
              HapticFeedback.lightImpact();
              setState(() => _isEditing = !_isEditing);
            },
            tooltip: _isEditing ? 'Cancel' : 'Edit Profile',
          ),
        ],
      ),
      body: profileAsync.when(
        data: (data) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_nameController.text.isEmpty && mounted) {
               _fillData(data);
            }
          });

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: screenSize.width * 0.12,
                        backgroundImage: _logoPath != null ? FileImage(File(_logoPath!)) : const AssetImage('assets/images/Raag Billing.png') as ImageProvider,
                        backgroundColor: Colors.transparent,
                        child: _logoPath == null ? null : null, // removed fallback icon since we use asset
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                            onPressed: _isEditing ? () {
                              HapticFeedback.lightImpact();
                              _pickLogo();
                            } : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Business Name*'),
                  readOnly: !_isEditing,
                  validator: (val) => val?.isEmpty ?? true ? 'Business name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ownerController,
                  readOnly: !_isEditing,
                  decoration: const InputDecoration(labelText: 'Owner Name'),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.28,
                      child: DropdownButtonFormField<String>(
                        value: _selectedCountryCode,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Code',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        ),
                        items: _countries
                            .map((c) => DropdownMenuItem(
                                  value: c['code'],
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text('${c['flag']} ${c['code']}', style: TextStyle(fontSize: isSmallScreen ? 11 : 13)),
                                  ),
                                ))
                            .toList(),
                        onChanged: _isEditing ? (val) => setState(() => _selectedCountryCode = val!) : null,
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.02),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        readOnly: !_isEditing,
                        decoration: const InputDecoration(labelText: 'Phone Number*'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  readOnly: !_isEditing,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  readOnly: !_isEditing,
                  decoration: const InputDecoration(labelText: 'Address*'),
                  maxLines: 2,
                  validator: (val) => val?.isEmpty ?? true ? 'Address is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _gstinController,
                  readOnly: !_isEditing,
                  decoration: const InputDecoration(labelText: 'GSTIN'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _upiController,
                  readOnly: !_isEditing,
                  decoration: const InputDecoration(labelText: 'UPI ID for Payments (Optional)', hintText: 'example@upi'),
                ),
                const Divider(height: 40),
                const Text('Shop Configuration', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedShopCategory,
                  decoration: const InputDecoration(labelText: 'Shop Category', helperText: 'Changes billing mode and PDF style'),
                  items: ['General', 'Jewellery', 'Pharmacy']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: _isEditing ? (val) => setState(() => _selectedShopCategory = val!) : null,
                ),
                const SizedBox(height: 24),
                const Text('Bank Details (For Invoice)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bankNameController,
                  readOnly: !_isEditing,
                  decoration: const InputDecoration(labelText: 'Bank Name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _accountNumberController,
                  readOnly: !_isEditing,
                  decoration: const InputDecoration(labelText: 'Account Number'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ifscCodeController,
                  readOnly: !_isEditing,
                  decoration: const InputDecoration(labelText: 'IFSC Code'),
                ),
                const Divider(height: 40),
                const Text('Defaults & Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _prefixController,
                        readOnly: !_isEditing,
                        decoration: const InputDecoration(labelText: 'Invoice Prefix (e.g. INV)'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _currencyController,
                        readOnly: !_isEditing,
                        decoration: const InputDecoration(labelText: 'Currency Symbol'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _taxController,
                  readOnly: !_isEditing,
                  decoration: const InputDecoration(labelText: 'Default Tax %'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 32),
                if (_isEditing)
                  Consumer(
                    builder: (context, ref, child) {
                      return ElevatedButton(
                        onPressed: _isSaving ? null : () async {
                          HapticFeedback.mediumImpact();
                          if (!_formKey.currentState!.validate()) return;
                          
                          setState(() => _isSaving = true);
                          
                          try {
                            final fullPhone = '$_selectedCountryCode${_phoneController.text}';
                            
                            final updated = data.copyWith(
                              name: _nameController.text,
                              ownerName: drift.Value(_ownerController.text.isEmpty ? null : _ownerController.text),
                              phone: drift.Value(fullPhone),
                              email: drift.Value(_emailController.text.isEmpty ? null : _emailController.text),
                              address: drift.Value(_addressController.text),
                              gstin: drift.Value(_gstinController.text.isEmpty ? null : _gstinController.text),
                              upiId: drift.Value(_upiController.text.isEmpty ? null : _upiController.text),
                              logoPath: drift.Value(_logoPath),
                              invoicePrefix: _prefixController.text,
                              currencySymbol: _currencyController.text,
                              defaultTaxPercentage: double.tryParse(_taxController.text) ?? 0.0,
                              shopCategory: _selectedShopCategory,
                              bankName: drift.Value(_bankNameController.text.isEmpty ? null : _bankNameController.text),
                              accountNumber: drift.Value(_accountNumberController.text.isEmpty ? null : _accountNumberController.text),
                              ifscCode: drift.Value(_ifscCodeController.text.isEmpty ? null : _ifscCodeController.text),
                            );

                            await ref.read(businessRepositoryProvider).updateProfile(updated);
                            
                            if (mounted) {
                              setState(() => _isEditing = false);
                              FocusScope.of(context).unfocus();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Profile updated successfully!')),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _isSaving = false);
                          }
                        },
                        child: _isSaving 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                          : const Text('Save Changes'),
                      );
                    },
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
