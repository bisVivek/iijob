import 'package:flutter/material.dart';

enum NotificationCategory {
  interview,
  recruiter,
  assessment,
  offer,
  system,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final DateTime timestamp;
  final NotificationCategory category;
  final String companyName;
  final String? roleTitle;
  final String? compensation;
  final String? meetingTime;
  final String? recruiterName;
  final IconData icon;
  final Color accentColor;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.timestamp,
    required this.category,
    required this.companyName,
    this.roleTitle,
    this.compensation,
    this.meetingTime,
    this.recruiterName,
    required this.icon,
    required this.accentColor,
    this.isRead = false,
  });

  String get categoryLabel {
    switch (category) {
      case NotificationCategory.interview:
        return "INTERVIEW INVITE";
      case NotificationCategory.recruiter:
        return "RECRUITER VIEW";
      case NotificationCategory.assessment:
        return "SCORECARD VERIFIED";
      case NotificationCategory.offer:
        return "DIRECT OFFER";
      case NotificationCategory.system:
        return "SYSTEM ALERT";
    }
  }

  static List<NotificationItem> getInitialMockNotifications(String candidateName) {
    return [
      NotificationItem(
        id: "notif_01",
        title: "Interview Scheduled: Flutter Architect",
        message:
            "Razorpay Engineering team reviewed your verified scorecard (100% Score) and confirmed a technical architecture round.",
        timeAgo: "12m ago",
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        category: NotificationCategory.interview,
        companyName: "Razorpay",
        roleTitle: "Flutter Architect & Mobile Lead",
        compensation: "₹45 - 60 LPA / Remote",
        meetingTime: "Tomorrow at 3:00 PM IST (Google Meet)",
        recruiterName: "Priya Sharma (Principal Talent Partner)",
        icon: Icons.video_camera_front_rounded,
        accentColor: const Color(0xFF10B981),
        isRead: false,
      ),
      NotificationItem(
        id: "notif_02",
        title: "Google Recruiter Viewed Your Scorecard",
        message:
            "Staff Technical Recruiter from Google Core Systems viewed $candidateName's verified score badge (#11J-VERIFIED-VB-100).",
        timeAgo: "1h ago",
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        category: NotificationCategory.recruiter,
        companyName: "Google",
        roleTitle: "Staff Mobile Systems Engineer",
        compensation: "\$180,000 - \$220,000 / Hybrid",
        recruiterName: "Alex Mercer ( Staff Recruiter)",
        icon: Icons.visibility_rounded,
        accentColor: const Color(0xFF005BFF),
        isRead: false,
      ),
      NotificationItem(
        id: "notif_03",
        title: "Direct Offer Match: High-Speed Trading App Lead",
        message:
            "Zerodha FinTech matched with your 100% score in concurrency & isolate optimizations for Lead Flutter Developer.",
        timeAgo: "3h ago",
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        category: NotificationCategory.offer,
        companyName: "Zerodha",
        roleTitle: "Lead Flutter Performance Architect",
        compensation: "₹50 - 65 LPA + Stock Options",
        recruiterName: "Nithin K. (Engineering Director)",
        icon: Icons.local_offer_rounded,
        accentColor: const Color(0xFF8B5CF6),
        isRead: false,
      ),
      NotificationItem(
        id: "notif_04",
        title: "11Jobs Assessment Score Verified & Published",
        message:
            "Your Dart, State Management & Isolates test was ranked in the 99.8th percentile. Global employers can now fast-track your applications.",
        timeAgo: "6h ago",
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        category: NotificationCategory.assessment,
        companyName: "11Jobs AI Engine",
        roleTitle: "Global Verification Node",
        icon: Icons.verified_rounded,
        accentColor: const Color(0xFF0284C7),
        isRead: true,
      ),
      NotificationItem(
        id: "notif_05",
        title: "Uber Core Mobility Shortlist Match",
        message:
            "Uber Driver App Infrastructure team requested permission to view your verified code repo and architecture samples.",
        timeAgo: "Yesterday",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        category: NotificationCategory.recruiter,
        companyName: "Uber",
        roleTitle: "Cross-Platform Framework Architect",
        compensation: "\$150,000 / Remote",
        recruiterName: "Sarah Jenkins (Technical Sourcing Lead)",
        icon: Icons.hub_rounded,
        accentColor: const Color(0xFF059669),
        isRead: true,
      ),
    ];
  }
}
