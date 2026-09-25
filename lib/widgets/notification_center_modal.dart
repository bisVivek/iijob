import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../theme/app_theme.dart';
import 'fade_slide_transition.dart';

/// Interactive Enhanced Notification Center Modal Sheet
class NotificationCenterModal extends StatefulWidget {
  final String candidateName;
  final List<NotificationItem>? initialNotifications;
  final VoidCallback? onNotificationsUpdated;

  const NotificationCenterModal({
    super.key,
    required this.candidateName,
    this.initialNotifications,
    this.onNotificationsUpdated,
  });

  static void show(
    BuildContext context, {
    required String candidateName,
    List<NotificationItem>? notifications,
    VoidCallback? onUpdated,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF070C1E) : const Color(0xFFF8FAFC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.88,
        child: NotificationCenterModal(
          candidateName: candidateName,
          initialNotifications: notifications,
          onNotificationsUpdated: onUpdated,
        ),
      ),
    );
  }

  @override
  State<NotificationCenterModal> createState() => _NotificationCenterModalState();
}

class _NotificationCenterModalState extends State<NotificationCenterModal> {
  late List<NotificationItem> _notifications;
  int _selectedFilterIndex = 0;

  final List<String> _filters = [
    "All",
    "Interviews",
    "Recruiters",
    "Offers",
    "System",
  ];

  @override
  void initState() {
    super.initState();
    _notifications = widget.initialNotifications ??
        NotificationItem.getInitialMockNotifications(widget.candidateName);
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<NotificationItem> get _filteredList {
    if (_selectedFilterIndex == 0) return _notifications;
    final filterName = _filters[_selectedFilterIndex];
    if (filterName == "Interviews") {
      return _notifications
          .where((n) => n.category == NotificationCategory.interview)
          .toList();
    } else if (filterName == "Recruiters") {
      return _notifications
          .where((n) => n.category == NotificationCategory.recruiter)
          .toList();
    } else if (filterName == "Offers") {
      return _notifications
          .where((n) => n.category == NotificationCategory.offer)
          .toList();
    } else if (filterName == "System") {
      return _notifications
          .where((n) =>
              n.category == NotificationCategory.assessment ||
              n.category == NotificationCategory.system)
          .toList();
    }
    return _notifications;
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
    widget.onNotificationsUpdated?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF005BFF),
        content: Text("All notifications marked as read!"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearAll() {
    final backup = List<NotificationItem>.from(_notifications);
    setState(() {
      _notifications.clear();
    });
    widget.onNotificationsUpdated?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E293B),
        content: const Text("Notifications cleared."),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: "UNDO",
          textColor: const Color(0xFF38BDF8),
          onPressed: () {
            setState(() {
              _notifications = backup;
            });
            widget.onNotificationsUpdated?.call();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txtPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final txtSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF0D1527) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Column(
      children: [
        // Modal Handle
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Header (Overflow-proof using Expanded & Flexible)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFF005BFF).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Color(0xFF005BFF),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "Activity & Alerts",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: txtPrimary,
                        ),
                      ),
                    ),
                    if (_unreadCount > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF005BFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "$_unreadCount",
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (_unreadCount > 0)
                TextButton(
                  onPressed: _markAllAsRead,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Mark read",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF005BFF),
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: txtSecondary, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Horizontal Category Filter Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(_filters.length, (index) {
              final isSelected = _selectedFilterIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => setState(() => _selectedFilterIndex = index),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF005BFF)
                          : (isDark ? const Color(0xFF131F37) : const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF005BFF)
                            : (isDark ? const Color(0xFF1E293B) : Colors.transparent),
                      ),
                    ),
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 12),
        const Divider(height: 1),

        // Notification List Body
        Expanded(
          child: _filteredList.isEmpty
              ? _buildEmptyState(isDark, txtPrimary, txtSecondary)
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  itemCount: _filteredList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = _filteredList[index];
                    return FadeSlideTransition(
                      delayMs: index * 40,
                      child: _buildNotificationTile(
                        item: item,
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        txtPrimary: txtPrimary,
                        txtSecondary: txtSecondary,
                      ),
                    );
                  },
                ),
        ),

        // Footer Actions
        if (_notifications.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_notifications.length} total updates",
                  style: TextStyle(fontSize: 12, color: txtSecondary),
                ),
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.delete_sweep_outlined, size: 16, color: Color(0xFFEF4444)),
                  label: const Text(
                    "Clear all",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFEF4444)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark, Color txtPrimary, Color txtSecondary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F1A30) : const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 44,
              color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF005BFF),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "All Caught Up!",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: txtPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "No active notifications in this filter category.",
            style: TextStyle(
              fontSize: 12.5,
              color: txtSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile({
    required NotificationItem item,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color txtPrimary,
    required Color txtSecondary,
  }) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
      ),
      onDismissed: (_) {
        setState(() {
          _notifications.removeWhere((n) => n.id == item.id);
        });
        widget.onNotificationsUpdated?.call();
      },
      child: InkWell(
        onTap: () {
          setState(() {
            item.isRead = true;
          });
          widget.onNotificationsUpdated?.call();
          _showDetailDialog(item);
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: item.isRead
                ? cardBg
                : (isDark ? const Color(0xFF101B34) : const Color(0xFFF0F7FF)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isRead
                  ? borderColor
                  : const Color(0xFF005BFF).withValues(alpha: 0.4),
              width: item.isRead ? 1.0 : 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Badge with Category Accent
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: item.accentColor.withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item.accentColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(item.icon, color: item.accentColor, size: 22),
              ),
              const SizedBox(width: 12),

              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag & Time Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.categoryLabel,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: item.accentColor,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              item.timeAgo,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: txtSecondary,
                              ),
                            ),
                            if (!item.isRead) ...[
                              const SizedBox(width: 6),
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF005BFF),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Title
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: item.isRead ? FontWeight.w700 : FontWeight.w900,
                        color: txtPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Message
                    Text(
                      item.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: txtSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(NotificationItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txtPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final txtSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Company Tag & Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(item.icon, color: item.accentColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.companyName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: txtPrimary,
                            ),
                          ),
                          Text(
                            item.categoryLabel,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: item.accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Main Title
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: txtPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                // Message
                Text(
                  item.message,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: txtSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // Extra info chips
                if (item.roleTitle != null) ...[
                  _buildDetailRow(Icons.work_outline_rounded, "Role", item.roleTitle!, isDark, txtPrimary),
                  const SizedBox(height: 8),
                ],
                if (item.compensation != null) ...[
                  _buildDetailRow(Icons.payments_outlined, "Compensation", item.compensation!, isDark, txtPrimary),
                  const SizedBox(height: 8),
                ],
                if (item.meetingTime != null) ...[
                  _buildDetailRow(Icons.access_time_rounded, "Schedule", item.meetingTime!, isDark, txtPrimary),
                  const SizedBox(height: 8),
                ],
                if (item.recruiterName != null) ...[
                  _buildDetailRow(Icons.person_outline_rounded, "Contact", item.recruiterName!, isDark, txtPrimary),
                  const SizedBox(height: 8),
                ],

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Close"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF10B981),
                              content: Text("Action confirmed for ${item.companyName}!"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Accept / Open"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDark, Color txtPrimary) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF005BFF)),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF005BFF)),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: txtPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
