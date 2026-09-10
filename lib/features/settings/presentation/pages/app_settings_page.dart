import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raag_billing/core/database/app_database.dart';
import '../providers/settings_providers.dart';

class AppSettingsPage extends ConsumerWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('App Settings')),
      body: settingsAsync.when(
        data: (settings) => ListView(
          children: [
            _buildSectionHeader('General Settings'),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: Text(settings.language == 'en' ? 'English' : 'Hindi'),
              onTap: () => _showLanguageDialog(context, ref, settings),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.notifications_active),
              title: const Text('Reminders'),
              subtitle: const Text('Enable/Disable app alerts'),
              value: settings.remindersEnabled,
              onChanged: (val) => _updateSettings(ref, settings.copyWith(remindersEnabled: val)),
            ),
            
            _buildSectionHeader('Barcode Settings'),
            SwitchListTile(
              secondary: const Icon(Icons.volume_up),
              title: const Text('Barcode Beep Sound'),
              subtitle: const Text('Play sound on successful scan'),
              value: settings.barcodeBeepEnabled,
              onChanged: (val) => _updateSettings(ref, settings.copyWith(barcodeBeepEnabled: val)),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.qr_code_scanner),
              title: const Text('Enable Barcode Scanning'),
              value: settings.barcodeScanEnabled,
              onChanged: (val) => _updateSettings(ref, settings.copyWith(barcodeScanEnabled: val)),
            ),

            _buildSectionHeader('Appearance'),
            ListTile(
              leading: const Icon(Icons.brightness_medium),
              title: const Text('Theme Mode'),
              subtitle: Text(settings.themeMode.toUpperCase()),
              onTap: () => _showFormatDialog(
                context, 
                ref, 
                'Select Theme Mode', 
                ['light', 'dark', 'system'], 
                (val) => _updateSettings(ref, settings.copyWith(themeMode: val))
              ),
            ),

            _buildSectionHeader('Billing & PDF Settings'),
            SwitchListTile(
              secondary: const Icon(Icons.visibility_off),
              title: const Text('Hide GSTIN on Bill'),
              value: settings.hideGstin,
              onChanged: (val) => _updateSettings(ref, settings.copyWith(hideGstin: val)),
            ),
            ListTile(
              leading: const Icon(Icons.note_alt),
              title: const Text('Thank You Note'),
              subtitle: Text(settings.thankYouNote),
              onTap: () => _showTextDialog(
                context, 
                ref, 
                'Edit Thank You Note', 
                settings.thankYouNote, 
                (val) => _updateSettings(ref, settings.copyWith(thankYouNote: val))
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final profileAsync = ref.watch(businessProfileProvider);
                return profileAsync.maybeWhen(
                  data: (profile) => ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Invoice Footer Details'),
                    subtitle: Text(profile.termsAndConditions ?? 'Terms & Conditions', maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () => _showTextDialog(
                      context, 
                      ref, 
                      'Edit Footer Details', 
                      profile.termsAndConditions ?? '', 
                      (val) {
                        final updated = profile.copyWith(termsAndConditions: drift.Value(val));
                        ref.read(businessRepositoryProvider).updateProfile(updated);
                      },
                      maxLines: 5,
                    ),
                  ),
                  orElse: () => const SizedBox(),
                );
              },
            ),

            _buildSectionHeader('Date & Time Format'),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date Format'),
              subtitle: Text(settings.dateFormat),
              onTap: () => _showFormatDialog(
                context, 
                ref, 
                'Select Date Format', 
                ['dd/MM/yyyy', 'MM/dd/yyyy', 'yyyy-MM-dd', 'dd MMM yyyy'], 
                (val) => _updateSettings(ref, settings.copyWith(dateFormat: val))
              ),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Time Format'),
              subtitle: Text(settings.timeFormat),
              onTap: () => _showFormatDialog(
                context, 
                ref, 
                'Select Time Format', 
                ['hh:mm a', 'HH:mm'], 
                (val) => _updateSettings(ref, settings.copyWith(timeFormat: val))
              ),
            ),

            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Raag Billing v1.0.0',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  void _updateSettings(WidgetRef ref, AppSettingsData settings) {
    ref.read(settingsRepositoryProvider).updateSettings(settings);
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, AppSettingsData settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                _updateSettings(ref, settings.copyWith(language: 'en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Hindi (हिंदी)'),
              onTap: () {
                _updateSettings(ref, settings.copyWith(language: 'hi'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFormatDialog(BuildContext context, WidgetRef ref, String title, List<String> formats, Function(String) onSelect) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: formats.map((f) => ListTile(
            title: Text(f),
            onTap: () {
              onSelect(f);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showTextDialog(BuildContext context, WidgetRef ref, String title, String initialValue, Function(String) onSave, {int maxLines = 1}) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: const InputDecoration(hintText: 'Enter text here'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
