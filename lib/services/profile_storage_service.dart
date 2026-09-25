import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle local storage of user profile images and details
class ProfileStorageService {
  static const String _keyProfileImageBase64 = '11jobs_profile_image_base64';
  static const String _keyProfileAvatarPreset = '11jobs_profile_avatar_preset';

  /// ValueNotifier holding the current base64 string or preset key
  static final ValueNotifier<String?> profileImageNotifier = ValueNotifier<String?>(null);
  static final ValueNotifier<String?> avatarPresetNotifier = ValueNotifier<String?>(null);

  static final ImagePicker _picker = ImagePicker();

  /// Initialize and load saved avatar from SharedPreferences
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final base64Image = prefs.getString(_keyProfileImageBase64);
      final preset = prefs.getString(_keyProfileAvatarPreset);

      if (base64Image != null && base64Image.isNotEmpty) {
        profileImageNotifier.value = base64Image;
      } else if (preset != null && preset.isNotEmpty) {
        avatarPresetNotifier.value = preset;
      }
    } catch (_) {
      // Graceful fallback for test environments or web
    }
  }

  /// Save custom image from bytes / base64
  static Future<void> saveCustomImageBase64(String base64String) async {
    profileImageNotifier.value = base64String;
    avatarPresetNotifier.value = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyProfileImageBase64, base64String);
      await prefs.remove(_keyProfileAvatarPreset);
    } catch (_) {}
  }

  /// Save curated avatar preset
  static Future<void> saveAvatarPreset(String presetKey) async {
    avatarPresetNotifier.value = presetKey;
    profileImageNotifier.value = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyProfileAvatarPreset, presetKey);
      await prefs.remove(_keyProfileImageBase64);
    } catch (_) {}
  }

  /// Clear profile image and reset to default initials
  static Future<void> clearProfileImage() async {
    profileImageNotifier.value = null;
    avatarPresetNotifier.value = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyProfileImageBase64);
      await prefs.remove(_keyProfileAvatarPreset);
    } catch (_) {}
  }

  /// Pick image from Gallery
  static Future<bool> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );
      if (image != null) {
        final Uint8List bytes = await image.readAsBytes();
        final String base64String = base64Encode(bytes);
        await saveCustomImageBase64(base64String);
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Pick image from Camera
  static Future<bool> pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );
      if (image != null) {
        final Uint8List bytes = await image.readAsBytes();
        final String base64String = base64Encode(bytes);
        await saveCustomImageBase64(base64String);
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Build avatar image widget or fallback initials
  static Widget buildAvatarWidget({
    required String candidateName,
    double radius = 24,
    Color? borderColor,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([profileImageNotifier, avatarPresetNotifier]),
      builder: (context, _) {
        final base64Image = profileImageNotifier.value;
        final preset = avatarPresetNotifier.value;

        ImageProvider? imageProvider;

        if (base64Image != null && base64Image.isNotEmpty) {
          try {
            final bytes = base64Decode(base64Image);
            imageProvider = MemoryImage(bytes);
          } catch (_) {}
        } else if (preset != null && preset.isNotEmpty) {
          // Curated preset mapping
          imageProvider = null; // rendered as styled preset icon
        }

        if (imageProvider != null) {
          return Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor ?? const Color(0xFF005BFF),
                width: 2.2,
              ),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          );
        }

        // Preset icon or Initials fallback
        if (preset != null) {
          final presetData = getPresetData(preset);
          return Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: presetData.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: borderColor ?? const Color(0xFF005BFF),
                width: 2.2,
              ),
            ),
            child: Center(
              child: Icon(
                presetData.icon,
                color: Colors.white,
                size: radius * 1.1,
              ),
            ),
          );
        }

        // Default Initials Avatar
        final initials = candidateName.trim().isNotEmpty
            ? (candidateName.trim().split(' ').length > 1
                ? "${candidateName.trim().split(' ')[0][0]}${candidateName.trim().split(' ')[1][0]}"
                : candidateName.trim().substring(0, candidateName.trim().length >= 2 ? 2 : 1))
            : "VB";

        return Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF005BFF), Color(0xFF003CB8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: borderColor ?? const Color(0xFF38BDF8),
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF005BFF).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              initials.toUpperCase(),
              style: TextStyle(
                fontSize: radius * 0.72,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Curated preset models
  static List<AvatarPresetData> get presets => const [
        AvatarPresetData(
          id: "flutter_dev",
          title: "Flutter Architect",
          icon: Icons.flutter_dash,
          gradientColors: [Color(0xFF0284C7), Color(0xFF0369A1)],
        ),
        AvatarPresetData(
          id: "systems_lead",
          title: "Systems Lead",
          icon: Icons.memory_rounded,
          gradientColors: [Color(0xFF6366F1), Color(0xFF4338CA)],
        ),
        AvatarPresetData(
          id: "ai_engineer",
          title: "AI Engineer",
          icon: Icons.auto_awesome_rounded,
          gradientColors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
        ),
        AvatarPresetData(
          id: "cloud_expert",
          title: "Cloud Architect",
          icon: Icons.cloud_done_rounded,
          gradientColors: [Color(0xFF0D9488), Color(0xFF0F766E)],
        ),
        AvatarPresetData(
          id: "cyber_sec",
          title: "Security Engineer",
          icon: Icons.security_rounded,
          gradientColors: [Color(0xFF059669), Color(0xFF047857)],
        ),
        AvatarPresetData(
          id: "tech_founder",
          title: "Tech Founder",
          icon: Icons.rocket_launch_rounded,
          gradientColors: [Color(0xFFEA580C), Color(0xFFC2410C)],
        ),
      ];

  static AvatarPresetData getPresetData(String id) {
    return presets.firstWhere(
      (p) => p.id == id,
      orElse: () => presets.first,
    );
  }
}

class AvatarPresetData {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradientColors;

  const AvatarPresetData({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradientColors,
  });
}
