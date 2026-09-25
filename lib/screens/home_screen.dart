import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/notification_item.dart';
import '../services/auth_storage_service.dart';
import '../services/profile_storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_picker_modal.dart';
import '../widgets/brand_logo.dart';
import '../widgets/fade_slide_transition.dart';
import '../widgets/animated_counter.dart';
import '../widgets/interactive_card.dart';
import '../widgets/notification_center_modal.dart';
import '../widgets/pulsing_badge.dart';
import '../widgets/theme_switcher_button.dart';
import 'animated_signin_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final bool isVerified;
  final int score;

  const HomeScreen({
    super.key,
    this.username = "Vivek Bisht",
    this.isVerified = true,
    this.score = 100,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _bottomNavIndex = 0;
  int _selectedFilterIndex = 0;
  late List<NotificationItem> _notifications;

  // Candidate Details (Defaults to Vivek Bisht, Flutter Developer)
  String get _candidateName =>
      (widget.username.isNotEmpty && widget.username != "User") ? widget.username : "Vivek Bisht";
  final String _candidateRole = " Flutter Developer & Mobile Systems Architect";
  final String _candidateEmail = "vivek5832017@gmail.com";
  final String _candidatePhone = "8171152213";
  final String _candidateFormattedPhone = "+91 8171152213";

  @override
  void initState() {
    super.initState();
    _notifications = NotificationItem.getInitialMockNotifications(_candidateName);
  }

  int get _unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  final List<String> _filterChips = [
    "All Active Pipelines",
    "Remote",
    "Flutter & Mobile",
    "Workflow Automation",
    "AI & Full Stack",
    "Immediate Start",
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verifiedId = "11J-VERIFIED-${(_candidateName.hashCode.abs() % 9000 + 1000)}";

    final bgColor = isDark ? const Color(0xFF060919) : const Color(0xFFF6F8FC);
    final cardBg = isDark ? const Color(0xFF0D1527) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final txtPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final txtSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,

      // Right-Side Hamburger Drawer (11Jobs official layout)
      endDrawer: _buildHamburgerDrawer(verifiedId, isDark, cardBg, borderColor, txtPrimary, txtSecondary),

      // Top Navigation Bar
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF070C1E) : Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
        titleSpacing: 18,
        automaticallyImplyLeading: false,

        // Left Side: 11Jobs Brand Logo
        title: const BrandLogo(height: 24),
        centerTitle: false,

        // Right Side: Notification Bell & Right Hamburger Menu Button
        actions: [
          // Notification Bell with Interactive Badge & Modal Sheet
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              IconButton(
                key: const Key('notificationBellButton'),
                icon: Icon(
                  _unreadNotificationCount > 0
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_rounded,
                  color: _unreadNotificationCount > 0
                      ? const Color(0xFF005BFF)
                      : txtPrimary,
                  size: 23,
                ),
                tooltip: 'Activity & Notifications',
                onPressed: () {
                  NotificationCenterModal.show(
                    context,
                    candidateName: _candidateName,
                    notifications: _notifications,
                    onUpdated: () => setState(() {}),
                  );
                },
              ),
              if (_unreadNotificationCount > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF005BFF),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF005BFF).withValues(alpha: 0.5),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "$_unreadNotificationCount",
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Hamburger Menu Button on RIGHT SIDE
          IconButton(
            key: const Key('hamburgerMenuButton'),
            tooltip: 'Open Menu',
            icon: Icon(
              Icons.menu_rounded,
              color: txtPrimary,
              size: 26,
            ),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Bottom Navigation Bar (5-tab responsive navigation with smooth active indicator)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF070C1E) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            child: Row(
              children: [
                Expanded(child: _buildNavItem(0, Icons.dashboard_rounded, "Dashboard", isDark)),
                Expanded(child: _buildNavItem(1, Icons.alt_route_rounded, "Pipelines", isDark)),
                Expanded(child: _buildNavItem(2, Icons.work_outline_rounded, "Jobs", isDark)),
                Expanded(child: _buildNavItem(3, Icons.hub_outlined, "MCP", isDark)),
                Expanded(child: _buildNavItem(4, Icons.person_outline_rounded, "Profile", isDark)),
              ],
            ),
          ),
        ),
      ),

      // Dynamic Tab Body Content with Animated Transition
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.02),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _buildCurrentTabBody(verifiedId, isDark, cardBg, borderColor, txtPrimary, txtSecondary),
      ),
    );
  }

  Widget _buildCurrentTabBody(
    String verifiedId,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    switch (_bottomNavIndex) {
      case 1:
        return _buildPipelinesTab(isDark, cardBg, borderColor, txtPrimary, txtSecondary);
      case 2:
        return _buildOpportunitiesTab(isDark, cardBg, borderColor, txtPrimary, txtSecondary);
      case 3:
        return _buildMcpToolsTab(isDark, cardBg, borderColor, txtPrimary, txtSecondary);
      case 4:
        return _buildProfileTab(verifiedId, isDark, cardBg, borderColor, txtPrimary, txtSecondary);
      case 0:
      default:
        return _buildDashboardTab(verifiedId, isDark, cardBg, borderColor, txtPrimary, txtSecondary);
    }
  }

  // ==========================================
  // TAB 0: 11JOBS MAIN DASHBOARD
  // ==========================================
  Widget _buildDashboardTab(
    String verifiedId,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('dashboardTabBody'),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Hero Banner with Welcome message and Staggered Entrance
          FadeSlideTransition(
            delayMs: 30,
            child: _build11JobsHeroSection(verifiedId, isDark, cardBg, borderColor, txtPrimary, txtSecondary),
          ),

          const SizedBox(height: 20),

          // 2. Active Hiring Workflow Pipeline Tracker
          FadeSlideTransition(
            delayMs: 100,
            child: _buildHiringPipelineTracker(isDark, cardBg, borderColor, txtPrimary, txtSecondary),
          ),

          const SizedBox(height: 22),

          // 3. Platform Capabilities Grid
          FadeSlideTransition(
            delayMs: 180,
            child: _buildPlatformCapabilitiesSection(isDark, cardBg, borderColor, txtPrimary, txtSecondary),
          ),

          const SizedBox(height: 22),

          // 4. AI-Matched High Priority Opportunities
          FadeSlideTransition(
            delayMs: 260,
            child: _buildOpportunitiesSection(isDark, cardBg, borderColor, txtPrimary, txtSecondary),
          ),

          const SizedBox(height: 22),

          // 5. Model Context Protocol (MCP) & ATS Integration Card
          FadeSlideTransition(
            delayMs: 340,
            child: _buildMcpIntegrationSection(isDark, cardBg, borderColor, txtPrimary, txtSecondary),
          ),

          const SizedBox(height: 22),

          // 6. Live Pipeline Performance Metrics
          FadeSlideTransition(
            delayMs: 420,
            child: _buildPipelineMetricsSection(isDark, cardBg, borderColor, txtPrimary, txtSecondary),
          ),

          const SizedBox(height: 36),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: PIPELINES (ACTIVE HIRING PIPELINES)
  // ==========================================
  Widget _buildPipelinesTab(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('pipelinesTabBody'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeSlideTransition(
            delayMs: 30,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Active Hiring Pipelines",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: txtPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Real-time status of your screening workflows",
                      style: TextStyle(fontSize: 11.5, color: txtSecondary),
                    ),
                  ],
                ),
                PulsingBadge(
                  glowColor: const Color(0xFF10B981),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt_rounded, color: Color(0xFF059669), size: 13),
                        SizedBox(width: 3),
                        Text(
                          "3 ACTIVE",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Fast-Track Banner
          FadeSlideTransition(
            delayMs: 90,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF16233B) : const Color(0xFFFEF9C3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFFFACC15).withValues(alpha: 0.4) : const Color(0xFFFDE047),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Pipelines are automatically fast-tracked with your verified ${widget.score}% score.",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFFACC15) : const Color(0xFF854D0E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Pipeline 1
          FadeSlideTransition(
            delayMs: 150,
            child: _buildActivePipelineCard(
              company: "TechFlow Systems",
              role: " Flutter Architect",
              stage: "Stage 3 of 4: Recruiter Review",
              statusColor: const Color(0xFF3B82F6),
              progress: 0.75,
              actionLabel: "Schedule AI Screener",
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              txtPrimary: txtPrimary,
              txtSecondary: txtSecondary,
            ),
          ),

          const SizedBox(height: 12),

          // Pipeline 2
          FadeSlideTransition(
            delayMs: 220,
            child: _buildActivePipelineCard(
              company: "AutoHire AI",
              role: "Full Stack Workflow Engineer",
              stage: "Stage 2 of 4: Assessment Verified",
              statusColor: const Color(0xFF10B981),
              progress: 0.50,
              actionLabel: "Nudge Recruiter",
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              txtPrimary: txtPrimary,
              txtSecondary: txtSecondary,
            ),
          ),

          const SizedBox(height: 12),

          // Pipeline 3
          FadeSlideTransition(
            delayMs: 290,
            child: _buildActivePipelineCard(
              company: "StreamLine DevTools",
              role: "Mobile Systems Lead",
              stage: "Stage 1 of 4: Application Dispatched",
              statusColor: const Color(0xFFF59E0B),
              progress: 0.25,
              actionLabel: "View Application",
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              txtPrimary: txtPrimary,
              txtSecondary: txtSecondary,
            ),
          ),

          const SizedBox(height: 20),

          // Action: Back to Dashboard
          FadeSlideTransition(
            delayMs: 360,
            child: Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _bottomNavIndex = 0;
                  });
                },
                icon: const Icon(Icons.arrow_back_rounded, size: 15),
                label: const Text("Return to Dashboard"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryBlue,
                  side: const BorderSide(color: AppTheme.primaryBlue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildActivePipelineCard({
    required String company,
    required String role,
    required String stage,
    required Color statusColor,
    required double progress,
    required String actionLabel,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color txtPrimary,
    required Color txtSecondary,
  }) {
    return InteractiveCard(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: [
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: txtPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${(progress * 100).toInt()}% Done",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              "$company • $stage",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.5, color: txtSecondary),
            ),
            const SizedBox(height: 10),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, animVal, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: animVal,
                    minHeight: 5,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$actionLabel: Request sent to hiring team!"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                  foregroundColor: AppTheme.primaryBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 2: OPPORTUNITIES (CURATED MATCHES)
  // ==========================================
  Widget _buildOpportunitiesTab(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('opportunitiesTabBody'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeSlideTransition(
            delayMs: 30,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Curated Opportunities",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: txtPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Matched with $_candidateName's verified Flutter credentials",
                      style: TextStyle(fontSize: 11.5, color: txtSecondary),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Text(
                    "🔥 98% MATCH",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Filter Chips
          FadeSlideTransition(
            delayMs: 90,
            child: SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filterChips.length,
                separatorBuilder: (context, i) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : (isDark ? const Color(0xFF0F172A) : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Text(
                        _filterChips[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Job 1
          FadeSlideTransition(
            delayMs: 150,
            child: _buildJobCard(
              title: " Flutter Architect",
              company: "TechFlow Systems",
              location: "Remote (Global)",
              matchScore: 98,
              salary: "₹24L - ₹36L / yr",
              type: "Full-Time",
              tags: ["Flutter", "Dart", "Clean Arch", "CI/CD"],
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              txtPrimary: txtPrimary,
              txtSecondary: txtSecondary,
            ),
          ),

          const SizedBox(height: 12),

          // Job 2
          FadeSlideTransition(
            delayMs: 220,
            child: _buildJobCard(
              title: "Lead Mobile Systems Engineer",
              company: "Nexus Automation Labs",
              location: "Remote / Bengaluru",
              matchScore: 95,
              salary: "₹22L - ₹32L / yr",
              type: "Full-Time",
              tags: ["Flutter", "Bloc", "WebSockets", "Offline Sync"],
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              txtPrimary: txtPrimary,
              txtSecondary: txtSecondary,
            ),
          ),

          const SizedBox(height: 12),

          // Job 3
          FadeSlideTransition(
            delayMs: 290,
            child: _buildJobCard(
              title: "AI & Workflow Solutions Developer",
              company: "HyperScale Intelligence",
              location: "Remote (US/India)",
              matchScore: 92,
              salary: "₹26L - ₹40L / yr",
              type: "Full-Time",
              tags: ["Flutter", "MCP", "AI Tooling", "REST/GraphQL"],
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              txtPrimary: txtPrimary,
              txtSecondary: txtSecondary,
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: MCP & TOOLS (MODEL CONTEXT PROTOCOL)
  // ==========================================
  Widget _buildMcpToolsTab(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('mcpToolsTabBody'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeSlideTransition(
            delayMs: 30,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MCP & Agent Tooling",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: txtPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Model Context Protocol integrations & ATS sync",
                      style: TextStyle(fontSize: 11.5, color: txtSecondary),
                    ),
                  ],
                ),
                PulsingBadge(
                  glowColor: const Color(0xFF3B82F6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: const Text(
                      "MCP v2.4",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // MCP Server Info Card
          FadeSlideTransition(
            delayMs: 90,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.dns_rounded, color: AppTheme.primaryBlue, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "11Jobs Native MCP Server",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: txtPrimary,
                              ),
                            ),
                            Text(
                              "mcp://api.11jobs.com/v1/agents",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: txtSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "CONNECTED",
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Connect your AI coding agents, IDEs, and ATS systems directly to 11Jobs to automate screening tests and candidate verification pipelines.",
                    style: TextStyle(fontSize: 11.5, height: 1.4, color: txtSecondary),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            "Registered Tools & Webhooks",
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: txtPrimary),
          ),
          const SizedBox(height: 10),

          // Tool 1
          FadeSlideTransition(
            delayMs: 150,
            child: _buildMcpToolRow(
              icon: Icons.psychology_rounded,
              name: "creative_assessment_screener",
              desc: "Dispatches scenario-based interactive assessments",
              status: "ACTIVE",
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              txtPrimary: txtPrimary,
              txtSecondary: txtSecondary,
            ),
          ),

          const SizedBox(height: 10),

          // Tool 2
          FadeSlideTransition(
            delayMs: 220,
            child: _buildMcpToolRow(
              icon: Icons.verified_user_rounded,
              name: "candidate_scorecard_verifier",
              desc: "Cryptographically signs assessment results with 100% score validation",
              status: "ACTIVE",
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              txtPrimary: txtPrimary,
              txtSecondary: txtSecondary,
            ),
          ),

          const SizedBox(height: 10),

          // Tool 3
          FadeSlideTransition(
            delayMs: 290,
            child: _buildMcpToolRow(
              icon: Icons.sync_alt_rounded,
              name: "ats_pipeline_sync_hook",
              desc: "Real-time bidirectional sync with Greenhouse, Lever, and Workday",
              status: "READY",
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              txtPrimary: txtPrimary,
              txtSecondary: txtSecondary,
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMcpToolRow({
    required IconData icon,
    required String name,
    required String desc,
    required String status,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color txtPrimary,
    required Color txtSecondary,
  }) {
    return InteractiveCard(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.primaryBlue, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                      color: txtPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10.5, color: txtSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF059669),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 4: PROFILE & VERIFIED SCORECARD (VIVEK BISHT)
  // ==========================================
  Widget _buildProfileTab(
    String verifiedId,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('profileTabBody'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Candidate Hero Card
          FadeSlideTransition(
            delayMs: 30,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                      : [const Color(0xFF005BFF), const Color(0xFF003CB3)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF005BFF).withValues(alpha: isDark ? 0.3 : 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar with camera edit badge
                  GestureDetector(
                    key: const Key('profileAvatarPickerButton'),
                    onTap: () {
                      AvatarPickerModal.show(context, candidateName: _candidateName);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ProfileStorageService.buildAvatarWidget(
                          candidateName: _candidateName,
                          radius: 40,
                          borderColor: Colors.white.withValues(alpha: 0.5),
                        ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFF003CB3),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Candidate Name
                  Text(
                    _candidateName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Role Designation
                  Text(
                    _candidateRole,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.75),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Verification Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFACC15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded, color: Color(0xFF1A1A1A), size: 13),
                        SizedBox(width: 5),
                        Text(
                          'VERIFIED CANDIDATE · 100% SCORE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Direct Contact Information Card
          FadeSlideTransition(
            delayMs: 90,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Text(
                        "Contact Details",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: txtPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "AVAILABLE FOR HIRE",
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Email Row
                  _buildContactTile(
                    icon: Icons.email_outlined,
                    label: "Email Address",
                    value: _candidateEmail,
                    actionIcon: Icons.copy_rounded,
                    actionTooltip: "Copy Email",
                    onAction: () {
                      Clipboard.setData(ClipboardData(text: _candidateEmail));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF005BFF),
                          content: Text("Copied email '$_candidateEmail' to clipboard!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    isDark: isDark,
                    txtPrimary: txtPrimary,
                    txtSecondary: txtSecondary,
                  ),

                  const Divider(height: 18),

                  // Phone Row
                  _buildContactTile(
                    icon: Icons.phone_outlined,
                    label: "Phone / WhatsApp",
                    value: _candidateFormattedPhone,
                    actionIcon: Icons.phone_forwarded_rounded,
                    actionTooltip: "Call / Connect",
                    onAction: () {
                      Clipboard.setData(ClipboardData(text: _candidatePhone));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF10B981),
                          content: Text("Phone number '$_candidateFormattedPhone' copied!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    isDark: isDark,
                    txtPrimary: txtPrimary,
                    txtSecondary: txtSecondary,
                  ),

                  const Divider(height: 18),

                  // Location & Availability Row
                  _buildContactTile(
                    icon: Icons.location_on_outlined,
                    label: "Location & Notice",
                    value: "India • Immediate Joiner (Remote / Hybrid)",
                    actionIcon: Icons.check_circle_outline_rounded,
                    actionTooltip: "Immediate",
                    onAction: null,
                    isDark: isDark,
                    txtPrimary: txtPrimary,
                    txtSecondary: txtSecondary,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3. Verified Assessment Scorecard Details
          FadeSlideTransition(
            delayMs: 160,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Text(
                        "Assessment Breakdown",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: txtPrimary,
                        ),
                      ),
                      Text(
                        verifiedId,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Animated KPI Counters
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          label: "Creative Score",
                          value: widget.score.toDouble(),
                          suffix: "%",
                          color: const Color(0xFF10B981),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricTile(
                          label: "Accuracy",
                          value: 100,
                          suffix: "%",
                          color: AppTheme.primaryBlue,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricTile(
                          label: "Percentile",
                          value: 99.8,
                          suffix: "%",
                          color: const Color(0xFFF59E0B),
                          isDark: isDark,
                          fractionDigits: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 4. Verified Skill Proficiency Bars
          FadeSlideTransition(
            delayMs: 230,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verified Technical Proficiencies",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: txtPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildSkillProgressBar(
                    skill: "Flutter & Dart Architecture",
                    level: "Expert",
                    percentage: 1.0,
                    color: const Color(0xFF005BFF),
                    isDark: isDark,
                    txtPrimary: txtPrimary,
                    txtSecondary: txtSecondary,
                  ),
                  const SizedBox(height: 10),

                  _buildSkillProgressBar(
                    skill: "Cross-Platform UI & Animations (60/120 FPS)",
                    level: "Expert",
                    percentage: 0.98,
                    color: const Color(0xFF10B981),
                    isDark: isDark,
                    txtPrimary: txtPrimary,
                    txtSecondary: txtSecondary,
                  ),
                  const SizedBox(height: 10),

                  _buildSkillProgressBar(
                    skill: "State Management (Bloc / Provider / Riverpod)",
                    level: "Advanced",
                    percentage: 0.96,
                    color: const Color(0xFF8B5CF6),
                    isDark: isDark,
                    txtPrimary: txtPrimary,
                    txtSecondary: txtSecondary,
                  ),
                  const SizedBox(height: 10),

                  _buildSkillProgressBar(
                    skill: "REST, GraphQL & Real-time WebSockets",
                    level: "Advanced",
                    percentage: 0.95,
                    color: const Color(0xFFF59E0B),
                    isDark: isDark,
                    txtPrimary: txtPrimary,
                    txtSecondary: txtSecondary,
                  ),
                  const SizedBox(height: 10),

                  _buildSkillProgressBar(
                    skill: "CI/CD, Fastlane, Google Play & App Store",
                    level: "Advanced",
                    percentage: 0.93,
                    color: const Color(0xFF06B6D4),
                    isDark: isDark,
                    txtPrimary: txtPrimary,
                    txtSecondary: txtSecondary,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 5. Contact & Connect Action Buttons
          FadeSlideTransition(
            delayMs: 300,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: "$_candidateName: $_candidateEmail | $_candidateFormattedPhone"));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF005BFF),
                          content: Text("$_candidateName's complete contact details copied!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: Text(
                      "Contact $_candidateName",
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
                          content: const Text("11Jobs Verified Certificate & Scorecard downloaded."),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_download_outlined, size: 16),
                    label: const Text("Download CV"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: txtPrimary,
                      side: BorderSide(color: borderColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String label,
    required String value,
    required IconData actionIcon,
    required String actionTooltip,
    required VoidCallback? onAction,
    required bool isDark,
    required Color txtPrimary,
    required Color txtSecondary,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppTheme.primaryBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: txtSecondary),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: txtPrimary,
                ),
              ),
            ],
          ),
        ),
        if (onAction != null)
          IconButton(
            icon: Icon(actionIcon, size: 17, color: AppTheme.primaryBlue),
            tooltip: actionTooltip,
            onPressed: onAction,
          ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String label,
    required double value,
    required String suffix,
    required Color color,
    required bool isDark,
    int fractionDigits = 0,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedCounter(
              value: value,
              suffix: suffix,
              fractionDigits: fractionDigits,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillProgressBar({
    required String skill,
    required String level,
    required double percentage,
    required Color color,
    required bool isDark,
    required Color txtPrimary,
    required Color txtSecondary,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                skill,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: txtPrimary),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "${(percentage * 100).toInt()}% • $level",
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: color),
            ),
          ],
        ),
        const SizedBox(height: 5),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: percentage),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
          builder: (context, animVal, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: animVal,
                minHeight: 6,
                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================
  // SECTION: 11JOBS HERO BANNER
  // ==========================================
  Widget _build11JobsHeroSection(
    String verifiedId,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF070C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005BFF).withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 28,
            offset: const Offset(0, 10),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges Row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              PulsingBadge(
                glowColor: const Color(0xFF10B981),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, color: Color(0xFF059669), size: 12),
                      SizedBox(width: 4),
                      Text(
                        "VERIFIED CANDIDATE",
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF059669),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  verifiedId,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    color: txtSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Welcome greeting
          Text(
            "Welcome, $_candidateName!",
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 4),

          // Main Tagline
          Text(
            "Hire Smarter.\nScreen Faster.",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -0.8,
              color: txtPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            "An enterprise hiring platform powered by AI agents, Model Context Protocol (MCP), and interactive screening tests.",
            style: TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: txtSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // Hero Metric Badges
          Row(
            children: [
              Expanded(
                child: _buildHeroMetricCard(
                  title: "Score",
                  value: widget.score.toDouble(),
                  suffix: "%",
                  icon: Icons.emoji_events_rounded,
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildHeroMetricCard(
                  title: "Match",
                  value: 98,
                  suffix: "%",
                  icon: Icons.auto_awesome_rounded,
                  color: AppTheme.primaryBlue,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildHeroMetricCard(
                  title: "Pipelines",
                  value: 3,
                  suffix: " Active",
                  icon: Icons.alt_route_rounded,
                  color: const Color(0xFFF59E0B),
                  isDark: isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // CTAs
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _bottomNavIndex = 1;
                    });
                  },
                  icon: const Icon(Icons.rocket_launch_rounded, size: 15),
                  label: const Text("View Pipelines"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _bottomNavIndex = 4;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: txtPrimary,
                    side: BorderSide(color: borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("View Profile"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMetricCard({
    required String title,
    required double value,
    required String suffix,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedCounter(
              value: value,
              suffix: suffix,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION: HIRING PIPELINE TRACKER
  // ==========================================
  Widget _buildHiringPipelineTracker(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hiring Workflow Pipeline",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: txtPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    " Flutter Architect • TechFlow Systems",
                    style: TextStyle(fontSize: 11, color: txtSecondary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "STAGE 3/4",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Interactive Pipeline Stages
          _buildPipelineStep(
            stepNumber: 1,
            title: "Application Dispatched",
            status: "Completed",
            isDone: true,
            isCurrent: false,
            isDark: isDark,
            txtPrimary: txtPrimary,
            txtSecondary: txtSecondary,
          ),
          _buildPipelineStep(
            stepNumber: 2,
            title: "Creative Assessment Verified",
            status: "Passed (100%)",
            isDone: true,
            isCurrent: false,
            isDark: isDark,
            txtPrimary: txtPrimary,
            txtSecondary: txtSecondary,
          ),
          _buildPipelineStep(
            stepNumber: 3,
            title: "Enterprise Recruiter Review",
            status: "In Review",
            isDone: false,
            isCurrent: true,
            isDark: isDark,
            txtPrimary: txtPrimary,
            txtSecondary: txtSecondary,
          ),
          _buildPipelineStep(
            stepNumber: 4,
            title: "Final Technical Interview",
            status: "Upcoming",
            isDone: false,
            isCurrent: false,
            isLast: true,
            isDark: isDark,
            txtPrimary: txtPrimary,
            txtSecondary: txtSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineStep({
    required int stepNumber,
    required String title,
    required String status,
    required bool isDone,
    required bool isCurrent,
    bool isLast = false,
    required bool isDark,
    required Color txtPrimary,
    required Color txtSecondary,
  }) {
    Color stepColor = isDone
        ? const Color(0xFF10B981)
        : (isCurrent ? AppTheme.primaryBlue : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone || isCurrent ? stepColor : Colors.transparent,
                border: Border.all(color: stepColor, width: 2),
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
                    : Text(
                        "$stepNumber",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isCurrent ? Colors.white : stepColor,
                        ),
                      ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: isDone ? const Color(0xFF10B981) : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                color: isCurrent ? txtPrimary : (isDone ? txtPrimary : txtSecondary),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDone
                  ? const Color(0xFFECFDF5)
                  : (isCurrent ? const Color(0xFFEFF6FF) : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                color: isDone
                    ? const Color(0xFF059669)
                    : (isCurrent ? const Color(0xFF1D4ED8) : txtSecondary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SECTION: PLATFORM CAPABILITIES GRID
  // ==========================================
  Widget _buildPlatformCapabilitiesSection(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Platform Architecture",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: txtPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCapabilityCard(
                  icon: Icons.psychology_rounded,
                  title: "Agent Screener",
                  desc: "Interactive situational testing with automatic validation.",
                  color: const Color(0xFF005BFF),
                  isDark: isDark,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  txtPrimary: txtPrimary,
                  txtSecondary: txtSecondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCapabilityCard(
                  icon: Icons.bolt_rounded,
                  title: "MCP Webhooks",
                  desc: "Live ATS synchronization with enterprise hiring portals.",
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  txtPrimary: txtPrimary,
                  txtSecondary: txtSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color txtPrimary,
    required Color txtSecondary,
  }) {
    return InteractiveCard(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: txtPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10.5, height: 1.35, color: txtSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SECTION: CURATED OPPORTUNITIES (DASHBOARD PREVIEW)
  // ==========================================
  Widget _buildOpportunitiesSection(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text(
                "Curated Matches",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: txtPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _bottomNavIndex = 2),
                child: const Text(
                  "View All (12)",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildJobCard(
            title: " Flutter Architect",
            company: "TechFlow Systems",
            location: "Remote (Global)",
            matchScore: 98,
            salary: "₹24L - ₹36L / yr",
            type: "Full-Time",
            tags: ["Flutter", "Dart", "Clean Arch", "CI/CD"],
            isDark: isDark,
            cardBg: cardBg,
            borderColor: borderColor,
            txtPrimary: txtPrimary,
            txtSecondary: txtSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard({
    required String title,
    required String company,
    required String location,
    required int matchScore,
    required String salary,
    required String type,
    required List<String> tags,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color txtPrimary,
    required Color txtSecondary,
  }) {
    return InteractiveCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: txtPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$company • $location",
                      style: TextStyle(fontSize: 11.5, color: txtSecondary),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Text(
                    "🔥 $matchScore% Match",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: txtSecondary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  "$salary • $type",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: txtPrimary,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF005BFF),
                        content: Text("Application submitted for $title! Fast-tracked with verified score."),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("1-Click Apply", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SECTION: MCP INTEGRATION CARD
  // ==========================================
  Widget _buildMcpIntegrationSection(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1527) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.hub_rounded, color: AppTheme.primaryBlue, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Model Context Protocol (MCP)",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: txtPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Connected to enterprise ATS & AI screening engines.",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: txtSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => setState(() => _bottomNavIndex = 3),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: const Text("Manage", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION: PIPELINE METRICS
  // ==========================================
  Widget _buildPipelineMetricsSection(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Platform Performance",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: txtPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  value: 99.4,
                  suffix: "%",
                  fractionDigits: 1,
                  label: "Platform SLA",
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  txtSecondary: txtSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricItem(
                  value: 4.8,
                  suffix: "x",
                  fractionDigits: 1,
                  label: "Hiring Speedup",
                  color: AppTheme.primaryBlue,
                  isDark: isDark,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  txtSecondary: txtSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricItem(
                  value: 99.8,
                  suffix: "%",
                  fractionDigits: 1,
                  label: "Verification Accuracy",
                  color: const Color(0xFFF59E0B),
                  isDark: isDark,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  txtSecondary: txtSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required double value,
    required String suffix,
    required String label,
    required Color color,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color txtSecondary,
    int fractionDigits = 0,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedCounter(
              value: value,
              suffix: suffix,
              fractionDigits: fractionDigits,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: txtSecondary),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // NAVIGATION BAR ITEM BUILDER
  // ==========================================
  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _bottomNavIndex == index;
    return GestureDetector(
      key: Key('bottomNavItem_$index'),
      onTap: () {
        setState(() {
          _bottomNavIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryBlue.withValues(alpha: isDark ? 0.25 : 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isSelected
                  ? AppTheme.primaryBlue
                  : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected
                    ? AppTheme.primaryBlue
                    : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // RIGHT HAMBURGER DRAWER (11JOBS OFFICIAL MENU)
  // ==========================================
  Widget _buildHamburgerDrawer(
    String verifiedId,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF070C1E) : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BrandLogo(height: 22),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: txtPrimary, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Candidate Summary Card with Image Upload & Storage Trigger
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                key: const Key('drawerCandidateCard'),
                onTap: () {
                  AvatarPickerModal.show(context, candidateName: _candidateName);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ProfileStorageService.buildAvatarWidget(
                            candidateName: _candidateName,
                            radius: 20,
                            borderColor: const Color(0xFF005BFF),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2.5),
                              decoration: const BoxDecoration(
                                color: Color(0xFF005BFF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, size: 9, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    _candidateName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: txtPrimary),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.edit_outlined, size: 12, color: Color(0xFF005BFF)),
                              ],
                            ),
                            Text(
                              _candidateEmail,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 10.5, color: txtSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildDrawerItem(
                    icon: Icons.dashboard_rounded,
                    title: "Dashboard",
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _bottomNavIndex = 0);
                    },
                    txtPrimary: txtPrimary,
                  ),
                  _buildDrawerItem(
                    icon: Icons.alt_route_rounded,
                    title: "Active Pipelines",
                    badge: "3 Active",
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _bottomNavIndex = 1);
                    },
                    txtPrimary: txtPrimary,
                  ),
                  _buildDrawerItem(
                    icon: Icons.work_outline_rounded,
                    title: "Job Opportunities",
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _bottomNavIndex = 2);
                    },
                    txtPrimary: txtPrimary,
                  ),
                  _buildDrawerItem(
                    icon: Icons.hub_outlined,
                    title: "MCP & Tools",
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _bottomNavIndex = 3);
                    },
                    txtPrimary: txtPrimary,
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_outline_rounded,
                    title: "$_candidateName's Profile",
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _bottomNavIndex = 4);
                    },
                    txtPrimary: txtPrimary,
                  ),
                  const Divider(height: 20),
                  _buildDrawerItem(
                    icon: Icons.business_center_outlined,
                    title: "For Employers",
                    onTap: () {
                      Navigator.of(context).pop();
                      _showDrawerInfoModal("For Employers", "Deploy automated AI screening tests, custom coding sandboxes, and integrate with your existing ATS workflow in minutes.");
                    },
                    txtPrimary: txtPrimary,
                  ),
                  _buildDrawerItem(
                    icon: Icons.payments_outlined,
                    title: "Pricing Plans",
                    onTap: () {
                      Navigator.of(context).pop();
                      _showDrawerInfoModal("Pricing Plans", "• Starter: Free for verified developers\n• Team: \$199/month for 50 active screens\n• Enterprise: Custom dedicated MCP nodes.");
                    },
                    txtPrimary: txtPrimary,
                  ),
                ],
              ),
            ),

            // Theme Toggle Card in Drawer
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DrawerThemeToggleCard(),
            ),

            // Sign Out Option
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
              child: OutlinedButton.icon(
                key: const Key('drawerLogoutButton'),
                onPressed: () async {
                  await AuthStorageService.clearSession();
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AnimatedSignInScreen()),
                  );
                },
                icon: const Icon(Icons.logout_rounded, size: 16, color: Color(0xFFEF4444)),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? badge,
    required VoidCallback onTap,
    required Color txtPrimary,
  }) {
    return ListTile(
      leading: Icon(icon, color: txtPrimary, size: 20),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txtPrimary),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF059669),
                ),
              ),
            )
          : null,
      onTap: onTap,
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  void _showDrawerInfoModal(String title, String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Got It"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
