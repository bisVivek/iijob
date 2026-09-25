import 'package:flutter/material.dart';
import '../services/profile_storage_service.dart';

/// Modal bottom sheet to pick or upload a profile image.
/// StatefulWidget so the inline preview refreshes immediately after a pick.
class AvatarPickerModal extends StatefulWidget {
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
  State<AvatarPickerModal> createState() => _AvatarPickerModalState();
}

class _AvatarPickerModalState extends State<AvatarPickerModal> {
  bool _isLoading = false;

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);
    bool success = false;
    String? errorMsg;
    try {
      success = await ProfileStorageService.pickFromGallery();
    } catch (e) {
      errorMsg = 'Could not access gallery. Check permissions in Settings.';
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (errorMsg != null) {
      _showSnackBar(errorMsg, const Color(0xFFEF4444));
    } else if (success) {
      _showSnackBar('Profile photo updated from gallery!', const Color(0xFF10B981));
      Navigator.pop(context);
    } else {
      _showSnackBar('No image selected. Try again.', const Color(0xFF64748B));
    }
  }

  Future<void> _pickFromCamera() async {
    setState(() => _isLoading = true);
    bool success = false;
    String? errorMsg;
    try {
      success = await ProfileStorageService.pickFromCamera();
    } catch (e) {
      errorMsg = 'Could not access camera. Check permissions in Settings.';
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (errorMsg != null) {
      _showSnackBar(errorMsg, const Color(0xFFEF4444));
    } else if (success) {
      _showSnackBar('Profile photo captured and saved!', const Color(0xFF10B981));
      Navigator.pop(context);
    } else {
      _showSnackBar('Photo not taken. Try again.', const Color(0xFF64748B));
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
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
      child: Stack(
        children: [
          Padding(
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
                          'Profile Photo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: txtPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Personalize your recruiter-facing identity',
                          style: TextStyle(fontSize: 12, color: txtSecondary),
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

                // Live Avatar Preview — rebuilds via ValueNotifier after pick
                Center(
                  child: Column(
                    children: [
                      ProfileStorageService.buildAvatarWidget(
                        candidateName: widget.candidateName,
                        radius: 40,
                        borderColor: const Color(0xFF005BFF),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.candidateName,
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
                        label: 'Choose Gallery',
                        color: const Color(0xFF005BFF),
                        isDark: isDark,
                        onTap: _isLoading ? null : _pickFromGallery,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.camera_alt_rounded,
                        label: 'Take Photo',
                        color: const Color(0xFF6366F1),
                        isDark: isDark,
                        onTap: _isLoading ? null : _pickFromCamera,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Curated Preset Avatars Section
                Text(
                  'Or Choose Tech Avatar Preset',
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
                      onTap: _isLoading
                          ? null
                          : () async {
                              final nav = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);
                              await ProfileStorageService.saveAvatarPreset(preset.id);
                              if (!mounted) return;
                              nav.pop();
                              messenger.showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFF005BFF),
                                  content: Text('Avatar set to ${preset.title}!'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
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
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final nav = Navigator.of(context);
                            final messenger = ScaffoldMessenger.of(context);
                            await ProfileStorageService.clearProfileImage();
                            if (!mounted) return;
                            nav.pop();
                            messenger.showSnackBar(
                              const SnackBar(
                                backgroundColor: Color(0xFF64748B),
                                content: Text('Profile photo reset to default initials.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                    icon: const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFFEF4444)),
                    label: const Text(
                      'Reset to Default Initials',
                      style: TextStyle(
                          color: Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay while image is being picked/saved
          if (_isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.55),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF005BFF),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDisabled ? 0.04 : (isDark ? 0.15 : 0.08)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: isDisabled ? 0.15 : 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color.withValues(alpha: isDisabled ? 0.4 : 1.0), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color.withValues(alpha: isDisabled ? 0.4 : 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
