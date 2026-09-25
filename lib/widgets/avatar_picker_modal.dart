import 'package:flutter/material.dart';
import '../services/profile_storage_service.dart';

/// Modal bottom sheet to pick or upload a profile image
class AvatarPickerModal extends StatelessWidget {
  final String candidateName;

  const AvatarPickerModal({
    super.key,
    required this.candidateName,
  });

  static void show(BuildContext context, {required String candidateName}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => AvatarPickerModal(candidateName: candidateName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txtPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final txtSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 42,
                height: 4.5,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profile Photo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: txtPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Personalize your recruiter-facing identity",
                      style: TextStyle(
                        fontSize: 12,
                        color: txtSecondary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: txtSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Active Avatar Preview Centerpiece
            Center(
              child: Column(
                children: [
                  ProfileStorageService.buildAvatarWidget(
                    candidateName: candidateName,
                    radius: 40,
                    borderColor: const Color(0xFF005BFF),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    candidateName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: txtPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Upload Options Row
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.photo_library_rounded,
                    label: "Choose Gallery",
                    color: const Color(0xFF005BFF),
                    isDark: isDark,
                    onTap: () async {
                      Navigator.pop(context);
                      final success = await ProfileStorageService.pickFromGallery();
                      if (context.mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xFF10B981),
                            content: Text("Profile photo updated successfully!"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.camera_alt_rounded,
                    label: "Take Photo",
                    color: const Color(0xFF6366F1),
                    isDark: isDark,
                    onTap: () async {
                      Navigator.pop(context);
                      final success = await ProfileStorageService.pickFromCamera();
                      if (context.mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xFF10B981),
                            content: Text("Profile photo captured and saved!"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Curated Preset Avatars Section
            Text(
              "Or Choose Tech Avatar Preset",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: txtPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ProfileStorageService.presets.map((preset) {
                return InkWell(
                  onTap: () async {
                    await ProfileStorageService.saveAvatarPreset(preset.id);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF005BFF),
                          content: Text("Avatar set to ${preset.title}!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: preset.gradientColors),
                          ),
                          child: Icon(preset.icon, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          preset.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: txtPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Reset Button
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  await ProfileStorageService.clearProfileImage();
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Color(0xFF64748B),
                        content: Text("Profile photo reset to default initials."),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFFEF4444)),
                label: const Text(
                  "Reset to Default Initials",
                  style: TextStyle(color: Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
