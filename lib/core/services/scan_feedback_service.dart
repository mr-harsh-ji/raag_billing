import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

/// A service to provide audio and haptic feedback on successful barcode scans.
class ScanFeedbackService {
  static final ScanFeedbackService _instance = ScanFeedbackService._internal();

  factory ScanFeedbackService() => _instance;

  late final AudioPlayer _audioPlayer;
  DateTime? _lastFeedbackTime;
  String? _lastScannedBarcode;
  
  // Configuration
  static const int _debounceMs = 250;
  static const int _duplicateBarcodeIgnoreMs = 2000;

  ScanFeedbackService._internal() {
    _audioPlayer = AudioPlayer();
    // Preload audio asset for immediate playback
    _preloadAudio();
  }

  Future<void> _preloadAudio() async {
    try {
      await _audioPlayer.setSource(AssetSource('audio/beep.mp3'));
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
    } catch (e) {
      // Audio preloading failed (might be missing file)
      print('ScanFeedbackService: Failed to preload audio: $e');
    }
  }

  /// Triggers a beep and vibration.
  /// 
  /// [barcode] is used to prevent duplicate feedback for the same item 
  /// within a short window.
  Future<void> playSuccessFeedback({String? barcode}) async {
    final now = DateTime.now();

    // 1. Debounce: prevent repeated triggers within 150-300ms
    if (_lastFeedbackTime != null && 
        now.difference(_lastFeedbackTime!).inMilliseconds < _debounceMs) {
      return;
    }

    // 2. Duplicate Detection: avoid multiple beeps for the same barcode 
    // if scanned repeatedly in short succession
    if (barcode != null && 
        barcode == _lastScannedBarcode && 
        _lastFeedbackTime != null && 
        now.difference(_lastFeedbackTime!).inMilliseconds < _duplicateBarcodeIgnoreMs) {
      return;
    }

    _lastFeedbackTime = now;
    _lastScannedBarcode = barcode;

    // Play Beep
    _playBeep();

    // Trigger Vibration
    _triggerVibration();
  }

  Future<void> _playBeep() async {
    try {
      // Reset player to start if it was already playing
      await _audioPlayer.stop();
      await _audioPlayer.resume();
    } catch (e) {
      print('ScanFeedbackService: Error playing beep: $e');
    }
  }

  Future<void> _triggerVibration() async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        // Light vibration
        Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      print('ScanFeedbackService: Error triggering vibration: $e');
    }
  }

  /// Reset the last scanned barcode state. 
  /// Useful when starting a new scanning session.
  void resetSession() {
    _lastScannedBarcode = null;
    _lastFeedbackTime = null;
  }

  /// Clean up resources.
  void dispose() {
    _audioPlayer.dispose();
  }
}
